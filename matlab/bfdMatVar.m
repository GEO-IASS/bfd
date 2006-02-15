function matVar = bfdMatVar(model)

% BFDMATVAR Computes matrix associated to likelihood variance

% BFD

%
% Syntax:
% matVar = bfdMatVar(model);
% 
% Description:
% This function is used exclusively by BFDUPDATEBETA.
% In GP's for regression, the variance of a test point outside the
% training data is given by a prior component and a likelihood
% component.  This function computes the matrix (invK-invD) which
% is required to evaluate the likelihood part of the variance. See
% [4] for further details on the computation of the variance of a
% test point in BFD.
%
% Inputs
%   model     : data structure with information to train a BFD
% Outputs
%   matVar    : an [N,N] matrix with the value (invK-invD)
%
% See also: BFDUPDATEBETA, README file
%

% Computing deltaYhat
y1 = model.y;
y0 = 1 - model.y;
N1 = sum(y1,1); N0 = sum(y0,1);
deltaYhat = (1/N0)*y0-(1/N1)*y1;

% Computing matrix invD 
A = model.beta*model.kern.K*model.L*model.kern.K + model.kern.K;
invA = pdinv(A);
kHat = model.kern.K*deltaYhat;
invD = invA - invA*kHat*pdinv(kHat'*invA*kHat)*kHat'*invA;
% Inverting K
invK = pdinv(model.kern.K);

% Computing matVar
matVar = invK - invD;
