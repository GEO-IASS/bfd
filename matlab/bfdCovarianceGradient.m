function g = bfdCovarianceGradient(invK, postK)

% BFDCOVARINCEGRADIENT Gradnt. of marg. log-likelihood wrt K

% BFD

% invK is the inverted Kernel
g = -invK + invK*(postK)*invK;
g = g*.5;
