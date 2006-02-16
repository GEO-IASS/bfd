
% CLASSSPECSRBFBIASWHITE Script that generates vector of OPTIONS

% BFD

%
% Syntax:
% classSpecsRBFBIASWHITE
%
% Description:
% This script generates the vector of optimisation OPTIONS that
% were used for the BFD experiments with RBF kernel. These
% parameters are specified in reference [1]. See REAME file.
%
% See also: classSpecsRBFARDLINARDBIASWHITE, BFDOPTIMISEBFD, README
%           file 
%


% Setting optimisation options
optset.Display = 'off';
optset.TolX = 1e-8;
optset.TolFun = 1e-8;
optset.DerivativeCheck = 'off'; 
optset.MaxFunEvals = 0;
optset.MaxIter = 500;   % optimiser iters
optset.MaxOuterIter = 5000; % loop iters
optset.Bound = 'off';
optset.TolBound = 1e-6;
optset.TolBeta = 1e-6;
optset.TolTheta = 1e-6;
options = setOptions(optset);





 
