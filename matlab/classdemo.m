% CLASSDEMO Script to classify a given data set (e.g. from UCI)

% BFD


% Setting optimisation options
optimset.Display = 'off';
optimset.TolX = 1e-6;
optimset.TolFun = 1e-6;
optimset.DerivativeCheck = 'off'; 
optimset.MaxFunEvals = 0;
optimset.MaxIter = 500;   % optimiser iters
optimset.MaxOuterIter = 5000; % loop iters
optimset.Bound = 'off';
optimset.TolBound = 1e-6;
optimset.TolBeta = 1e-6;
optimset.TolTheta = 1e-6;
options = setOptions(optimset);

% Model specifications
modSpecs.kernelType = {'rbf', 'bias', 'white'};
modSpecs.TieARD = length(findstr('ard', strcat(modSpecs.kernelType{:}))) > 0;
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.d = 2;
modSpecs.beta = 1;

% Other information
dataset = 'thyroid';
partitions = [1, 2, 3, 4, 5];
trialWidths = [1e-1, 1, 1e1];
trainInst = 100;
testInst = 100;
orig_path = pwd;

fprintf('Working with dataset: %s\n', dataset);
  
%%% Training models with different data realisations and
%%% different trialWidths
[paramRecord, likeRecord]  = bfdTrainModel(partitions, trialWidths,...
                                    modSpecs, optimset, dataset);
% Selecting the 'best' parameter set
params = bfdSelectWidth(paramRecord, likeRecord);

%%% Loading training and test data
%%% 

% Training and testing the model for each 
% data partition in the specified data set
fprintf('Loading training & test data\n');
[trainX, trainY] = bfdLoadData(dataset, 'train', trainInst);
[testX, testY] = bfdLoadData(dataset, 'test', testInst);
trainData = {trainX; trainY};
testData = {testX; testY};
  
fprintf('Making predictions & computing Prediction error\n')
[error, predY, probY] = bfdComputeError(trainData, testData, ...
                                      modSpecs, params);
fprintf('Errors were computed.\n');

% Computing average
fprintf('Average error rate = %2.4f with std = %2.4f\n',...
         mean(error), std(error));
  
% Uncomment this line if you want to save the final results
%bfdSaveData(modSpecs.kernelType, dataset, 'UCIResults', params);
