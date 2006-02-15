function g = bfdCovarianceGradient(invK, postK)

% BFDCOVARIANCEGRADIENT Gradient of L(\Theta) wrt Kernel matrix

% BFD

% Syntax: 
% g = bfdCovarianceGradient(invK, postK);
%
% Description:
% Function only used by BFDKERNELGRADIENT. In order to compute the
% gradient of L(\Theta) wrt \Theta it is necessary to apply the
% chain rule. From this process two terms are obtained, (1) the
% derivative of L(\Theta) wrt K and (2) the derivative of K wrt to
% \Theta. This function computes the first term.
%
% Inputs
%   invK      : an [N,N] matrix with the inverse of the kernel, K
%   postK     : an [N,N] matrix with the posterior covariance,
%               SIGMA
% Outputs
%   g         : a scalar with the gradient
%
% See also: BFDKERNELGRADIENT
%

% Computing the gradient of L wrt the Kernel matrix
g = -invK + invK*(postK)*invK;
g = g*.5;
