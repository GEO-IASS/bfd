function g = bfdKernelGradient(params, model)

% KERNELGRADIENT Gradient of likelihood approximation wrt kernel parameters.
%
% g = kernelGradient(params, model, prior)

% Copyright (c) 2004 Tonatiuh Pena Centeno and Neil D. Lawrence
% File version 
% BFD toolbox version 0.1


%/~
if any(isnan(params))
  warning('Parameter is NaN')
end
%~/

x = model.X(model.I, :);
model.kern = kernExpandParam(model.kern, params);
K = kernCompute(model.kern, x);
g = zeros(size(params));

invK = pdinv(K);
covGrad = bfdCovarianceGradient(invK, model.Sigma);

g = kernGradient(model.kern, x, covGrad);
g = -g;