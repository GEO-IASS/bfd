%function runbfd

% RUNBFD Run the BFD on a data-set.
%
% runbfd(dataName, rbfInit, tol);

% Copyright (c) 2004 Tonatiuh Pena Centeno and Neil D. Lawrence
% File version 
% BFD toolbox version 0.1

% Setting optimisation options
optimset.Display = 'off';
optimset.TolX = 1e-8;
optimset.TolFun = 1e-8;
optimset.DerivativeCheck = 'off'; 
optimset.MaxFunEvals = 0;
optimset.MaxIter = 1500;   % optimiser iters
optimset.MaxOuterIter = 5000; % loop iters
optimset.Bound = 'off';
optimset.TolBound = 1e-4;
optimset.TolBeta = 1e-7;
optimset.TolTheta = 1e-6;
options = setOptions(optimset);

% Set model specifications (kernel and param. tying)
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.d = 2;
modSpecs.kernelType = {'rbfard', 'linard', 'bias', 'white'};
modSpecs.TieARD = findstr('ard', strcat(modSpecs.kernelType{:})) > 0;

% Load data set
dataset = 'full-spiral';
fprintf('Working with data-set %s\n', dataset);
[cellX, cellY] = bfdLoadData(dataset, 'train', 1);
X = cellX{1}; y = cellY{1};
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

% Creating a new model and testing it
params = kernExtractParam(model.kern);
newSpecs = modSpecs;

[newModel, K] = bfd(X, y, newSpecs, params, model.beta);
newModel = bfdComputeAlpha(model);
f = K*newModel.alpha;
newModel.bias = mean(f);

bfdPlot(newModel);


