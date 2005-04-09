function Ltheta = qbfdBound(model)

% QBFDBOUND Computes bound on marginal log-likelihood

% QBFD

% Computes the bound of the logmarginal likelihood
% Priors over Beta's are included
[invSigma,UC] = pdinv(model.Sigma);
K = model.kern.Kstore;
N = length(model.y);
N1 = sum(model.y);
N0 = sum(1-model.y);
beta1 = model.beta1;
beta0 = model.beta0;
Ltheta = - 0.5*( N*log(2*pi) - N1*log(beta1) - N0*log(beta0) ...
                 + logdet(K) + logdet(invSigma, UC) )...
         + gammaPriorLogProb(model.gamma0, model.beta0) ...
         + gammaPriorLogProb(model.gamma1, model.beta1);