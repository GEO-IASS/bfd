function g = bfdCovarianceGradient(invK, postK)

% COVARINCEGRADIENT The gradient of the likelihood approximation wrt the covariance.
%
% g = covarianceGradient(invK, postK)

% Copyright (c) 2004 Tonatiuh Pena Centeno and Neil D. Lawrence
% File version 
% BFD toolbox version 0.1

g = -invK + invK*(postK)*invK;
g = g*.5;
