% DEMBFD Demo for classifying a given toy data set 

% BFD 

% VERSION 1.11 IN CVS
%

% Note: this script implements by itself the EM algorithm, i.e.
% it does not use the function bfdOptimiseBFD

% Setting optimisation options
optimset.Display = 'off';
optimset.TolX = 1e-6;
optimset.TolFun = 1e-6;
optimset.DerivativeCheck = 'off'; 
optimset.MaxFunEvals = 0;
optimset.MaxIter = 2500;   % max. optimiser iters
optimset.MaxOuterIter = 5000; % max. loop iters
optimset.Bound = 'on';
optimset.TolBound = 1e-3;
optimset.TolBeta = 1e-4;
optimset.TolTheta = 1e-4;
options = setOptions(optimset);


% Kernel type and parameter tying
kernelType = {'rbfard', 'linard', 'bias', 'white'};
TieARD = length(findstr('ard', strcat(kernelType{:}))) > 0;

% Load data set
dataset = 'full-spiral';
[cellX, cellY] = loadData(dataset, 'train', 1);
model.X = cellX{1};
model.y = cellY{1};
fprintf(['Working with dataset:', dataset, '\n']);

% Creating MODEL
model.beta = 1;
model.d = 2;
N = size(model.X,1);
model.I = (1:N);
model.gamma.a = 0.5; % Prior over beta
model.gamma.b = 0.5;
model = bfdComputeL(model); % Computing matrix L
model.kern = kernCreate(model.X, kernelType); %  Creating Kernel 
if TieARD
  model.kern = cmpndTieParameters(model.kern, {[3, 6], [4, 7]});
  model.kern.comp{1}.transforms(2).type = 'negLogLogit';
  model.kern.comp{2}.transforms(2).type = 'negLogLogit';
end

% Setting INVERSEWIDTH
numIn = size(model.X, 2);
params = kernExtractParam(model.kern);
invWidth = 1;
params = bfdParamInit(kernelType, numIn, invWidth);
model.kern = kernExpandParam(model.kern, params);

% Displaying initial inverse Width used
fprintf('Using inversewidth = %2.4f\n', ...
           negLogLogitTransform(params(1), 'atox'));

% Initial E-step
model.kern.Kstore = kernCompute(model.kern, model.X);
model = bfdUpdateSigma(model);
model = bfdComputeAlpha(model);

% Monitoring beta
counter = 0;
betaOld = -Inf;
betaNew = model.beta;
betaDiff = abs(betaNew-betaOld);

% Monitoring the bound
boundOld = -Inf;
boundNew = bfdBound(model);
boundDiff = abs(boundNew-boundOld);

counter = 0;

fprintf('Initial bound is %2.6f and beta is %2.6f\n', boundNew, model.beta);

% Training the BFD model
while boundDiff > options(20) & counter < options(21) & ...
      betaDiff > options(22)
      
    counter = counter + 1;
    betaOld = betaNew;
    boundOld = boundNew;
    
    
    % M step
    params = kernExtractParam(model.kern);
    params = scg('bfdKernelObjective', params, options,...
                             'bfdKernelGradient', model);
    model.kern = kernExpandParam(model.kern, params);
    model.kern.Kstore = kernCompute(model.kern, model.X);

		
    % E step
    model = bfdUpdateBeta(model); 
    model = bfdComputeAlpha(model);
    model = bfdUpdateSigma(model);
    
    % Computing differentials
    betaNew = model.beta;
    betaDiff = abs(betaNew-betaOld);
    boundNew = bfdBound(model);
    boundDiff = abs(boundNew-boundOld);
    
    % Printing update
    if options(19) == 1
      fprintf('Iteration %d, The bound is %2.6f and beta: %2.6f\n', ...
               counter, boundNew, model.beta);
    end  
    
    % Displaying the value of the inverseWidth
    fprintf('Inversewidth is %2.4f\n', ...
            negLogLogitTransform(params(1), 'atox'));
    
end

model = bfdComputeAlpha(model);
K = kernCompute(model.kern, model.X, model.X);
f = K*model.alpha;
model.bias = mean(f);
bfdPlot(model); drawnow
