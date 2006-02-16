function model = bfdOptimiseBFD(model, options)

% BFDOPTIMISEBFD Adapts kernel parameters by EM algorithm

% BFD

%
% Syntax:
% model = bfdOptimiseBFD(model, options);
%
% Description:
% Routine used to maximise the bound on the marginal log-likelihood
% and adapt the parameters of the kernel. The routine is based on
% an EM algorithm which consists of the following steps:
% a) E step: approximate the posterior distribution
% b) M step: maximise kernel parameters
%
% The E-step thus is formed by the update of the posterior
% covariance SIGMA and update of the precision BETA. Meanwhile the
% M-step is based on the application of a conjugate gradient's
% routine to maximise L(\Theta) wrt \Theta. See the SCG function 
% in Ian Nabney's Netlab toolbox for more information about the
% implementation of conjugate gradients. See [1] for further
% details on EM applied to BFD.
% BFDOPTIMISEBFD can receive a vector of OPTIONS that control the
% optimisation in terms of TOLERANCE, ITERATIONS, among others.
%
% Inputs
%   model     : data structure with information to train a BFD alg.
%   options(*): a vector with parameters, typically of size [23,1]
% Outputs
%   model     : the same data structure with the uptated field -
%               model.kern.lntheta.
%
% See also: SCG, BFDKERNELGRADIENT, BFDCOVARIANCEGRADIENT
%

% Monitoring BOUND
boundOld = -Inf;
counter = 1;
boundNew = bfdBound(model);
boundDiff = abs(boundNew-boundOld);

% Monitoring \Beta
betaOld = -Inf;
betaNew = model.beta;
betaDiff = abs(betaNew-betaOld);

% Monitoring parameters \Theta
thetaOld = -Inf;
thetaNew = model.kern.lntheta;
thetaDiff = abs(thetaNew-thetaOld);

% Cycles counter
counter = 0;

% Displaying initial value of the BOUND
fprintf('Initial bound is %2.6f\n', boundNew);

% Optimisation loop. We verify convergence of \Theta, \Beta and BOUND 
while boundDiff > options(20) & counter < options(21) & ...
      betaDiff > options(22) & any(thetaDiff > options(23))
  
    % Updating counters
    counter = counter + 1;
    boundOld = boundNew;
    betaOld = betaNew;
    thetaOld = thetaNew;
    
    % M step
    model.kern.lntheta = scg('bfdKernelObjective', model.kern.lntheta, ...
                                 options, 'bfdKernelGradient', model);
        
    % E step
    model.kern.lntheta=log(thetaConstrain(exp(model.kern.lntheta)));
    model.kern.K = computeKernel(model.kern.lntheta, ...
                                     model.kern.type, model.X);
    model = bfdUpdateBeta(model); 
    model = bfdComputeAlpha(model);
    model = bfdUpdateSigma(model);
        
    % Updating BOUND, \Beta and \Theta   
    boundNew = bfdBound(model);
    betaNew = model.beta;
    thetaNew = model.kern.lntheta;
    
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

% Printing final value of the BOUND and of \Beta
boundNew = bfdBound(model);
fprintf('Value of bound after training is: %2.4f\n', boundNew);
fprintf('The value of beta is: %2.9f\n', model.beta);