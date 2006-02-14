function Ltheta = bfdBound(model)

% BFDBOUND Computes bound on marginal log-likelihood

% BFD

% VERSION 1.11 IN CVS
%

% Computes the bound of the logmarginal likelihood
% Prior over Beta is included
[invSigma,UC] = pdinv(model.Sigma);
K = model.kern.Kstore;
N = size(model.y, 1);
Ltheta = - 0.5*( N*log(2*pi) - N*log(model.beta) ...
                + logdet(K) + logdet(invSigma, UC) )...
         + gammaPriorLogProb(model.gamma, model.beta);