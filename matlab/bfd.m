function [model, K] = bfd(X, Y, modSpecs, params, beta)

% BFD Creates a model with parameters and required specifications


% Setting mandatory fields
model.X = X;
model.y = Y;
numIn = size(model.X,2);
model = bfdComputeL(model);
model.d = modSpecs.d;
  
N = size(model.X,1);
model.I = (1:N);

kernelType = modSpecs.kernelType;

%  Creating Kernel structure
model.kern = kernCreate(model.X, kernelType);

if modSpecs.TieARD
  model.kern = cmpndTieParameters(model.kern, {[3, 6], [4, 7]});
  model.kern.comp{1}.transforms(2).type = 'negLogLogit';
  model.kern.comp{2}.transforms(2).type = 'negLogLogit';
end

% Setting parameters
if nargin == 3
  params = bfdParamInit(kernelType, numIn);
  model.kern = kernExpandParam(model.kern, params);
elseif nargin == 5
  model.kern = kernExpandParam(model.kern, params);
end

% Computing kernel
model.kern.Kstore = kernCompute(model.kern, model.X);

if nargout == 2
  K = kernCompute(model.kern, model.X, model.X);
end

% Setting beta and prior over it
if nargin == 3
  model.gamma.a = 0.5;
  model.gamma.b = 0.5;
  model.beta = 1;
elseif nargin == 5
  model.gamma = modSpecs.gamma;
  model.beta = beta;
end

% Computing alpha
model = bfdComputeAlpha(model);

% Setting Sigma
model = bfdUpdateSigma(model);
