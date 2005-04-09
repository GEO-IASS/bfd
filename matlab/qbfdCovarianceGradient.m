function g = bfdCovarianceGradient(invK, postK)

% BFDCOVARINCEGRADIENT Gradient of marginal log-likelihood wrt K

% BFD

% invK is the inverted Kernel
g = -invK + invK*(postK)*invK;
g = g*.5;
