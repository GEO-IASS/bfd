function f = bfdKernelObjective(params, model)

% KERNELOBJECTIVE Likelihood approximation.
%
% f = kernelObjective(params, model, prior)

% Copyright (c) 2004 Tonatiuh Pena Centeno and Neil D. Lawrence
% File version 
% BFD toolbox version 0.1


%/~
if any(isnan(params))
  warning('Parameter is NaN');
end
%~/

x = model.X(model.I, :);
model.kern = kernExpandParam(model.kern, params);

K = kernCompute(model.kern, x);
[invK, UC] = pdinv(K); 
f = -.5*logdet(K, UC) - 0.5*sum(sum(invK.*(model.Sigma)));
f = -f;
