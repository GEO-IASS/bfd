function Ltheta = bfdBound(model)

% Computes the bound of the logmarginal likelihood
[invSigma,UC] = pdinv(model.Sigma);
K = model.kern.Kstore;
N = size(model.y, 1);
Ltheta = - 0.5*( N*log(2*pi) - N*log(model.beta) ...
                + logdet(K) + logdet(invSigma, UC) )...
         + gammaPriorLogProb(model.gamma, model.beta);