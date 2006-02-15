
% CLASSSPECSRBFARDLINARDBIASWHITE Script that generates vector of OPTIONS 

% BFD

%
% Syntax:
% classSpecsRBFARDLINARDBIASWHITE
%
% Description:
% This script generates the vector of optimisation OPTIONS that
% were used for the BFD experiments with the ARD kernel mentioned in
% reference [1]. See README file.
%
% See also: classSpecsRBFBIASWHITE, BFDOPTIMISEBFD, README file
%


% Setting optimisation options
optset.Display = 'off';
optset.TolX = 1e-6;
optset.TolFun = 1e-6;
optset.DerivativeCheck = 'off'; 
optset.MaxFunEvals = 0;
optset.MaxIter = 500;   % optimiser iters
optset.MaxOuterIter = 2500; % loop iters
optset.Bound = 'off';
optset.TolBound = 1e-4;
optset.TolBeta = 1e-5;
optset.TolTheta = 1e-6;
options = setOptions(optset);



 
