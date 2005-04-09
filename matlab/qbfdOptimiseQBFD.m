function [model, log_opt] = qbfdOptimiseQBFD(model, options)

% QBFDOPTIMISEBFD Optimises a BFD model

% QBFD

% Monitoring bound
boundOld = -Inf;
counter = 1;
boundNew = qbfdBound(model);
boundDiff = abs(boundNew-boundOld);

% Monitoring beta's
betaOld = -Inf;
betaNew = model.beta0 + model.beta1;
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
    params = scg('qbfdKernelObjective', params, ...
                  options, 'qbfdKernelGradient', model);
    model.kern = kernExpandParam(model.kern, params);
    model.kern.Kstore = kernCompute(model.kern, model.X);
    
    % E step
    model = qbfdUpdateBetas(model); 
    model = qbfdComputeAlpha(model);
    model = qbfdUpdateSigma(model);
        
    % Updating bound, beta and theta   
    boundNew = qbfdBound(model);
    betaNew = model.beta0 + model.beta1;
    thetaNew = params;
    
    % Displaying relevant values
    if options(19) == 1
      fprintf('Iteration %d, The bound is %2.6f and added beta''s: %2.9f\n', ...
              counter, boundNew, model.beta0 + model.beta1);
    end
    
    % Computing differences on monitored parameters
    boundDiff = abs(boundNew-boundOld);
    betaDiff = abs(betaNew-betaOld);
    thetaDiff = abs(thetaNew-thetaOld);
    
end

% Displaying final bound and final beta
boundNew = qbfdBound(model);
fprintf('Value of bound after training is: %2.4f\n', boundNew);
fprintf('The value of added beta''s is: %2.9f\n', model.beta0 + model.beta1);

% Storing log 
log_opt{1} = boundDiff;
log_opt{2} = betaDiff;
log_opt{3} = counter;