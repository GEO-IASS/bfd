function f = bfdKernelObjective(params, model)

% BFDKERNELOBJECTIVE KL divergence between prior and posterior kernels 

% BFD

% Verifying parameters are fine
if any(isnan(params))
  warning('Parameter is NaN');
end

% Computing the cost function
x = model.X(model.I, :);
model.kern = kernExpandParam(model.kern, params);

K = kernCompute(model.kern, x);
[invK, UC] = pdinv(K); 
f = -.5*logdet(K, UC) - 0.5*sum(sum(invK.*(model.Sigma)));
f = -f;
