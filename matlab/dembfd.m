% DEMOBFD Demo for classifying a given Toy data set

% BFD

% Setting Optimisation options
optimset.Display = 'off';
optimset.TolX = 1e-8;
optimset.TolFun = 1e-8;
optimset.DerivativeCheck = 'off'; 
optimset.MaxFunEvals = 0;
optimset.MaxIter = 500;   % optimiser iters
optimset.MaxOuterIter = 5000; % loop iters
optimset.Bound = 'off';
optimset.TolBound = 1e-4;
optimset.TolBeta = 1e-7;
optimset.TolTheta = 1e-6;
options = setOptions(optimset);

% Model specifications (kernel and param. tying)
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.d = 2;
modSpecs.kernelType = {'rbfard', 'linard', 'bias', 'white'};
modSpecs.TieARD = findstr('ard', strcat(modSpecs.kernelType{:})) > 0;

% Loading data set
dataset = 'bumpy';
fprintf('Working with data-set %s\n', dataset);
[X, y] = bfdLoadData(dataset, 'train', 1);

% Creating BFD model
model = bfd(X, y, modSpecs);

% Setting inverseWidth
params = kernExtractParam(model.kern);
invWidth = 1;
numIn = size(X,2);
params = bfdParamInit(modSpecs.kernelType, numIn, invWidth);
model.kern = kernExpandParam(model.kern, params);
fprintf('Using initial invWidth = %2.4f\n', invWidth);

% Resetting prior and posterior kernels
model.kern.Kstore = kernCompute(model.kern, model.X);
model.beta = model.beta; % just a reminder
model = bfdUpdateSigma(model);

% Optimising the model
model = bfdOptimiseBFD(model, options);

% Creating a new model with leanrt parameters 
params = kernExtractParam(model.kern);
newSpecs = modSpecs;
[newModel, K] = bfd(X, y, newSpecs, params, model.beta);
newModel = bfdComputeAlpha(model);

% Projecting data to obtain model bias
f = K*newModel.alpha;
newModel.bias = mean(f);

% Plotting the discriminant
bfdPlot(newModel);


