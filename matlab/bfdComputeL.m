function model = bfdComputeL(model)

% BFDCOMPUTEL Computes matrix L

% BFD

% 
% Syntax:
% model = bfdComputeL(model);
%
% Description:
% Computes matrix L and stores it in the MODEL structure. This
% function will typically be only called once, e.g. when the MODEL 
% is initialised.
% 
% Inputs:
%   model     : data structure with information to train a BFD alg.
% Outputs:
%   model     : the same structure with the field L updated
%
% See also: BFD
%

% Creating auxiliar vectors Y0 and Y1 and computing matrix
y1 = model.y; 
y0 = 1-model.y;
N1 = sum(y1,1); 
N0 = sum(y0,1); 
N = N1 + N0;
model.L = eye(N,N) - (1/N1)*y1*y1' - (1/N0)*y0*y0';