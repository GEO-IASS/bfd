function model = bfdOptimiseBFD(model, options)

% BFDOPTIMISEBFD Optimises a BFD model

% BFD

% Monitoring bound
boundOld = -Inf;
counter = 1;
boundNew = bfdBound(model);
boundDiff = abs(boundNew-boundOld);

% Monitoring beta
betaOld = -Inf;
betaNew = model.beta;
betaDiff = abs(betaNew-betaOld);

% Monitoring paramters
thetaOld = -Inf;
thetaNew = kernExtractParam(model.kern);
thetaDiff = abs(thetaNew-thetaOld);

% Cycles counter
counter = 0;

% Displaying initial bound
fprintf('Initial bound is %2.6f\n', boundNew);

% Optimisation loop
while boundDiff > options(20) & counter < options(21) & ...
      betaDiff > options(22) & any(thetaDiff > options(23))
  
    % Updating counters
    counter = counter + 1;
    boundOld = boundNew;
    betaOld = betaNew;
    thetaOld = thetaNew;
    
    % M step
    params = kernExtractParam(model.kern);
    params = scg('bfdKernelObjective', params, ...
                  options, 'bfdKernelGradient', model);
    model.kern = kernExpandParam(model.kern, params);
    
    % E step
    model.kern.Kstore = kernCompute(model.kern, model.X);
    model = bfdUpdateBeta(model); 
    model = bfdComputeAlpha(model);
    model = bfdUpdateSigma(model);
        
    % Updating bound, beta and theta   
    boundNew = bfdBound(model);
    betaNew = model.beta;
    thetaNew = params;
    
    % Displaying relevant values
    if options(19) == 1
      fprintf('Iteration %d, The bound is %2.6f and beta: %2.9f\n', ...
              counter, boundNew, model.beta);
    end
    
    % Computing differences on monitored parameters
    boundDiff = abs(boundNew-boundOld);
    betaDiff = abs(betaNew-betaOld);
    thetaDiff = abs(thetaNew-thetaOld);
    
end

% Displaying final bound and final beta
boundNew = bfdBound(model);
fprintf('Value of bound after training is: %2.4f\n', boundNew);
fprintf('The value of beta is: %2.9f\n', model.beta);