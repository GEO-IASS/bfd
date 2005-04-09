function [model, K] = qbfd(X, Y, modSpecs, params, beta0, beta1)

% QBFD Creates a model according to input arguments

% QBFD

% Setting mandatory fields
model.X = X;
model.y = Y;
numIn = size(model.X,2);
model.d = modSpecs.d;  
N = size(model.X,1);
model.I = (1:N);

% Setting beta and prior over it
if nargin == 3
  model.gamma0.a = 0.5;
  model.gamma0.b = 0.5;
  model.gamma1.a = 0.5;
  model.gamma1.b = 0.5;
  model.beta0 = 1;
  model.beta1 = 1;
elseif nargin > 4
  model.gamma = modSpecs.gamma;
  model.beta0 = beta0;
  model.beta1 = beta1;
end

% Computing matrix Lg (requires beta's)
model = qbfdComputeLg(model);

%  Creating Kernel structure
kernelType = modSpecs.kernelType;
model.kern = kernCreate(model.X, kernelType);

if modSpecs.TieARD
  tiedParams = genParamTying(numIn);
  model.kern = cmpndTieParameters(model.kern, tiedParams);
  model.kern.comp{1}.transforms(2).type = 'negLogLogit';
  model.kern.comp{2}.transforms(2).type = 'negLogLogit';
end

% Setting parameters
if nargin == 3
  params = qbfdParamInit(kernelType, numIn);
  model.kern = kernExpandParam(model.kern, params);
elseif nargin == 5
  model.kern = kernExpandParam(model.kern, params);
end

% Computing kernel
model.kern.Kstore = kernCompute(model.kern, model.X);

% Computing kernel without autocorrelated noise
if nargout == 2
  K = kernCompute(model.kern, model.X, model.X);
end


% Computing alpha
model = qbfdComputeAlpha(model);

% Setting Sigma
model = qbfdUpdateSigma(model);


function tiedParams = genParamTying(numIn)

for it = 1:numIn
  tiedParams{1,it} = [it+2,it+3+numIn];
end
