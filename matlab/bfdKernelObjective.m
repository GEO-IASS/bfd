function f = bfdKernelObjective(lntheta, model)

% BFDKERNELOBJECTIVE Likelihood 

% BFD

%
% Syntax:
% f = bfdKernelObjective(lntheta, model);
%
% Description:
% This function will typically by used by BFDKERNELGRADIENT. 
% It computes the value of the log-posterior, where the posterior
% distribution is a multivariate Gaussian with covariance 
% matrix given by Sigma. 
%
% Inputs
%   lntheta   : a [t,1] vector with kernel parameters
%   model     : the structure that holds the information for BFD
% Outputs
%   f         : a scalar with the value of the marginal
%               log-likelihood
%
% Other info  : the value of `f' depends on the value of LNTHETA
%
% See also: BFDKERNELGRADIENT
%

x = model.X;
% Verifying values in LNTHETA are within a computable range
lntheta=log(thetaConstrain(exp(lntheta)));

% Computing the log-likelihood
K = computeKernel(lntheta, model.kern.type, x);
[invK, UC] = pdinv(K); 
f = - 0.5*logdet(K, UC) - 0.5*sum(sum(invK.*(model.Sigma)));
f = -f;
