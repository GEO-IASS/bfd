function model = bfdComputeAlpha(model)

% BFDCOMPUTEALPHA Computes coefficients alpha

% BFD

% Syntax:
% model = bfdComputeAlpha(model);
% 
% Description:
% Computes the [N,1] vector of `support vector' coefficients
% ALPHA. Applying this function will result in the update
% of the field ALPHA within the MODEL structure.
% This function is typically called by BFDPLOT.
% 
% Inputs:
%   model     : data structure with information to train a BFD alg.
% Outputs:
%   model     : the same data structure but with the field ALPHA
%               updated.
%
% Other info  : this function can only be applied if the
%               sub-structure KERN exists inside MODEL.
%
% See also: BFDPLOT
%

% Takes a BFD model and computes the "alpha" coeffients
K = model.kern.K;
m1 = K*model.y/sum(model.y);
m0 = K*(1-model.y)/sum(1-model.y);
L = model.L;
alpha = pdinv(K/model.beta + K*L*K)*(m0-m1);
model.alpha = model.dist*alpha/(alpha'*(m0-m1));