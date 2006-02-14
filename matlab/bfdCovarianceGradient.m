function g = bfdCovarianceGradient(invK, postK)

% BFDCOVARINCEGRADIENT Gradient of marginal log-likelihood wrt K

% BFD

% VERSION 1.11 IN CVS
%

% invK is the inverted Kernel
g = -invK + invK*(postK)*invK;
g = g*.5;
