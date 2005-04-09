function model = bfdOptimiseKernel(model, options, optiMethod);

% BFDOPTIMISEKERNEL Applies OPTIMETHOD to optimise parameters of a MODEL

% BFD

% Setting default values for optimisation 
% (in case they have not been given)
if nargin < 2
  options(1) = 0; % Display error values
  options(9) = 0; % Gradient check
  options(14) = 500; % Iterations
end

% Default optimisationmethod is SCG (Netlab)
if nargin < 3
  optiMethod = 'scg'
end

model = optimiseParams('kern', optiMethod, 'bfdKernelObjective', ...
                       'bfdKernelGradient', options, model);
  