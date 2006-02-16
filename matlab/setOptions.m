function options = setOptions(optset)

% SETOPTIONS Converts an OPTSET structure into a vector of OPTIONS

% BFD

%
% Syntax:
% options = setOptions(optset);
%
% Description:
% Receives an OPTSET structure and converts it into a vector of 
% FOPTIONS. It is used for backward compatibility with Netlab.
% We have added some extra fields and values both to OPTSET and
% OPTIONS in order to operate with BFD.
% This function will typically be used by the function
% BFDOPTIMISEBFD as it will give as a result the vector of OPTIONS
% that control the optimisation routine.
%
% Inputs
%   optSet     : structure with the information for the optimisation
%                routine 
% Outputs
%   Options    : a vector of dimensions [23,1]
%
% See also: SCG, BFDOPTIMISEBFD, FOPTIONS, OPTIMSET
%

% Defining constants with default values
defaultTolBound = 1e-6;
defaultBound = 'off';
defaultOuterIter = 50;
defaultTolBeta = 1e-6;
defaultTolTheta = 1e-3;

% Setting default options
if nargin == 0
  options = foptions;
  options(19) = defaultBound;  %%% Don't display BOUND
  options(20) = tolBound; %%% Tolerance on BOUND
  options(21) = defaultOuterIter; %%% Outer loop ITERS
  options(22) = defaultTolBeta; %%% Tolerance on \Beta
  options(23) = defaultTolTheta; %%% Tolerance on LNTHETA
  return;
end

% Checking inputs
if ~isstruct(optset)
  error('setOptions: incorrect input');
end

% Getting standard options
Display = optset.Display;
TolX = optset.TolX;
TolFun = optset.TolFun;
DerivativeCheck = optset.DerivativeCheck;
MaxFunEvals = optset.MaxFunEvals;
MaxIter = optset.MaxIter;

% Getting BFD-specific options
if isfield(optset, 'Bound')
  Bound = optset.Bound;
else
  Bound = defaultBound;
end

if isfield(optset, 'TolBound')
  TolBound = optset.TolBound;
else
  TolBound = defaultTolBound;
end

if isfield(optset, 'TolBeta')
  TolBeta = optset.TolBeta;
else
  TolBeta = defaultTolBeta;
end

if isfield(optset, 'TolTheta')
  TolTheta = optset.TolTheta;
else
  TolTheta = defaultTolTheta;
end

if isfield(optset, 'MaxOuterIter')
  MaxOuterIter = optset.MaxOuterIter;
else
  MaxOuterIter = defaultOuterIter;
end

% Getting options that don't exist in OPTSET format
if isfield(optset, 'MaxGradEvals')
  MaxGradEvals = optset.MaxGradEvals; 
else
  MaxGradEvals = 0;
end

% Mapping OPTSET values into OPTIONS' format
if isempty(Display) | isequal(Display, 'off')
  options(1) = 0;
elseif isequal(Display, 'iter') | isequal(Display, 'notify') |...
        isequal(Display, 'on')
  options(1) = 1;
else
  error('setOptions: error in assigning options(1)');
end

% Termination tolerance on X
if isempty(TolX)
  options(2) = 1e-4;
else
  options(2) = TolX;
end

% Termination tolerance on the function value
if isempty(TolFun)
  options(3) = 1e-4;
else 
  options(3) = TolFun;
end

% Gradient Check
if isempty(DerivativeCheck)
  options(9) = 0;
elseif isequal(DerivativeCheck, 'on')
  options(9) = 1;
elseif isequal(DerivativeCheck, 'off')
  options(9) = 0;
else
  error('setOptions: assignment error in options(9)');
end

% Max number of function evaluations
if isempty(MaxFunEvals)
  options(10) = 0;
else
  options(10) = MaxFunEvals;
end

% Max number of gradient evaluations
if isempty(MaxGradEvals)
  options(11) = 0;
else
  options(11) = MaxGradEvals;
end

% Max number of iterations for optimiser
if isempty(MaxIter)
  options(14) = 100;
else 
  options(14) = MaxIter;
end

% BOUND options
if isempty(Bound)
  options(19) = 0;
elseif isequal(Bound, 'on')
  options(19) = 1;
elseif isequal(Bound, 'off')
  options(19) = 0;
end

% BOUND options
if isempty(Bound)
  options(20) = defaultTolBound;
else
  options(20) = TolBound;
end

% Outer (loop) iterations
if isempty(MaxOuterIter)
  options(21) = defaultOuterIter;
else
  options(21) = MaxOuterIter;
end

% \Beta options
if isempty(TolBeta)
  options(22) = defaultTolBeta;
else
  options(22) = TolBeta;
end

% LNTHETA (kernel params) options
if isempty(TolTheta)
  options(23) = defaultTolTheta;
else
  options(23) = TolTheta;
end
