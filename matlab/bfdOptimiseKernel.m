function model = bfdOptimiseKernel(model, options, optiMethod);

% BFDOPTIMISEKERNEL Optimise the kernel parameters.

% BFD

if nargin < 2
  options(1) = 0; % Display error values
  options(9) = 0; % Gradient check
  options(14) = 500; % Iterations
end


if nargin < 3
  optiMethod = 'scg'
end

model = optimiseParams('kern', optiMethod, 'bfdKernelObjective', ...
                       'bfdKernelGradient', options, model);
  