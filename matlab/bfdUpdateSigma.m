function model = bfdUpdateSigma(model)

% BFDUPDATESIGMA Update the posterior for Fisher's discriminant.

% BFD

% 
% Syntax:
% model = bfdUpdateSigma(model);
% 
% Description:
% Updates the value of the posterior covariance \Sigma_{p}. See
% reference [4] (in the README file)for more details. 
% This function is used by BFDOPTIMISEBFD to adapt the kernel
% parameters to the training data.
% 
% Inputs
%   model     : data structure with information to train a BFD alg.
% Outputs
%  model      : same structure with the field SIGMA updated
% 
% See also: BFDOPTIMISEBFD, README file 
%

% \Sigma_{p} = (invK + \beta*L)^{-1}
model.Sigma = pdinv(pdinv(model.kern.K) ...
                   + model.beta*model.L);