function Ltheta = bfdBound(model)

% BFDCOMPUTEBOUND Computes bound of marginal log-likelihood

% BFD

%
% Syntax:
% Ltheta = bfdBound(model);
%
% Description:
% Evaluates the bound of the marginal log-likelihood. This 
% computation takes into account the prior over \Beta, which is
% stored inside the structure GAMMA.
%
% Inputs:
%   model     : data structure with information to train a BFD alg.
% Outputs:
%   Ltheta    : the value of the bound according to the information 
%               stored in MODEL. 
%
% Other info  : this function is used to test convergence.
%
% See also: reference [1] in README file

[invSigma, UC] = pdinv(model.Sigma);
N = length(invSigma);
Ltheta = -0.5*( N*log(2*pi) - N*log(model.beta) ...
                + logdet(model.kern.K) ...
                + logdet(invSigma, UC) ) ...
                + gammaPriorLogProb(model.gamma, model.beta);


%%% Auxiliar function to compute the log-prior over \Beta
function l = gammaPriorLogProb(prior, beta)

% This is the log of a Gamma(a,b) distribution
% with SHAPE parameter A and INV-SCALE parameter B.
D = length(beta);
l = D*prior.a*log(prior.b)-D*gammaln(prior.a)+...
    (prior.a-1)*sum(log(beta))-prior.b*sum(beta);