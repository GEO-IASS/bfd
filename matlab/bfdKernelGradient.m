function g = bfdKernelGradient(params, model)

% BFDKERNELGRADIENT Gradient of KL divergence wrt kernel parameters.

% BFD 

% VERSION 1.11 IN CVS
%

% Verifying parameters are fine
if any(isnan(params))
  warning('Parameter is NaN')
end

% Computing the gradient
x = model.X(model.I, :);
model.kern = kernExpandParam(model.kern, params);
K = kernCompute(model.kern, x);
g = zeros(size(params));

invK = pdinv(K);
covGrad = bfdCovarianceGradient(invK, model.Sigma);

g = kernGradient(model.kern, x, covGrad);
g = -g;