function options = setOptions(optimset)

% SETOPTIONS Converts an optimset structure to a vector foptions
  
% BFD
  
% Constants
defaultTolBound = 1e-6;
defaultBound = 'off';
defaultOuterIter = 50;
defaultTolBeta = 1e-6;
defaultTolTheta = 1e-3;

% Setting default options
if nargin == 0
  options = foptions;
  options(19) = defaultBound;  %%% Don't display bound
  options(20) = tolBound; %%% Tolerance on bound
  options(21) = defaultOuterIter; %%% Outer loop iters
  options(22) = defaultTolBeta; %%% Tolerance on beta
  options(23) = defaultTolTheta; %%% Tolerance on params
  return;
end

% Checking inputs
if ~isstruct(optimset)
  error('setOptions: incorrect input');
end

% Getting standard options
Display = optimget(optimset, 'Display');
TolX = optimget(optimset, 'TolX');
TolFun = optimget(optimset, 'TolFun');
DerivativeCheck = optimget(optimset, 'DerivativeCheck');
MaxFunEvals = optimget(optimset, 'MaxFunEvals');
MaxIter = optimget(optimset, 'MaxIter');

% Getting FBD options
if isfield(optimset, 'Bound')
  Bound = optimset.Bound;
else
  Bound = defaultBound;
end

if isfield(optimset, 'TolBound')
  TolBound = optimset.TolBound;
else
  TolBound = defaultTolBound;
end

if isfield(optimset, 'TolBeta')
  TolBeta = optimset.TolBeta;
else
  TolBeta = defaultTolBeta;
end

if isfield(optimset, 'TolTheta')
  TolTheta = optimset.TolTheta;
else
  TolTheta = defaultTolTheta;
end

if isfield(optimset, 'MaxOuterIter')
  MaxOuterIter = optimset.MaxOuterIter;
else
  MaxOuterIter = defaultOuterIter;
end

% Getting options that don't exist in optimset
% format
if isfield(optimset, 'MaxGradEvals')
  MaxGradEvals = optimset.MaxGradEvals; 
else
  MaxGradEvals = 0;
end

% Mapping optimset values into options' format
%%% Display error
if isempty(Display) | isequal(Display, 'off')
  options(1) = 0;
elseif isequal(Display, 'iter') | isequal(Display, 'notify') |...
        isequal(Display, 'on')
  options(1) = 1;
else
  error('setOptions: error in assigning options(1)');
end

%%% Termination tolerance on X
if isempty(TolX)
  options(2) = 1e-4;
else
  options(2) = TolX;
end

%%% Termination tolerance on the function value
if isempty(TolFun)
  options(3) = 1e-4;
else 
  options(3) = TolFun;
end

%%% Gradient Check
if isempty(DerivativeCheck)
  options(9) = 0;
elseif isequal(DerivativeCheck, 'on')
  options(9) = 1;
elseif isequal(DerivativeCheck, 'off')
  options(9) = 0;
else
  error('setOptions: assignment error in options(9)');
end

%%% Max number of function evaluations
if isempty(MaxFunEvals)
  options(10) = 0;
else
  options(10) = MaxFunEvals;
end

%%% Max number of gradient evaluations
if isempty(MaxGradEvals)
  options(11) = 0;
else
  options(11) = MaxGradEvals;
end

%%% Max number of iterations for optimiser
if isempty(MaxIter)
  options(14) = 100;
else 
  options(14) = MaxIter;
end

%%% Bound options
if isempty(Bound)
  options(19) = 0;
elseif isequal(Bound, 'on')
  options(19) = 1;
elseif isequal(Bound, 'off')
  options(19) = 0;
end

%%% Bound options
if isempty(Bound)
  options(20) = defaultTolBound;
else
  options(20) = TolBound;
end

%%% Outer (loop) iterations
if isempty(MaxOuterIter)
  options(21) = defaultOuterIter;
else
  options(21) = MaxOuterIter;
end

%%% Beta options
if isempty(TolBeta)
  options(22) = defaultTolBeta;
else
  options(22) = TolBeta;
end

%%% Theta (kernel params) options
if isempty(TolTheta)
  options(23) = defaultTolTheta;
else
  options(23) = TolTheta;
end
