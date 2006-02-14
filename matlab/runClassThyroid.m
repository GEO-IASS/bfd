% RUNCLASSTHYROID Classification script for thyroid 

% BFD 

% VERSION 1.11 IN CVS
%

% Setting optimisation options
optimset.Display = 'off';
optimset.TolX = 1e-6;
optimset.TolFun = 1e-6;
optimset.DerivativeCheck = 'off'; 
optimset.MaxFunEvals = 0;
optimset.MaxIter = 500;   % max. optimiser iters
optimset.MaxOuterIter = 5000; % max. loop iters
optimset.Bound = 'off';
optimset.TolBound = 1e-6;
optimset.TolBeta = 1e-6;
optimset.TolTheta = 1e-6;
options = setOptions(optimset);

% Model specifications
modSpecs.kernelType = {'sqexp'}; %{'rbf', 'bias', 'white'};
modSpecs.TieARD = length(findstr('ard', strcat(modSpecs.kernelType{:}))) > 0;
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.d = 2;
modSpecs.optimset = optimset;


% Other information
fileNames = {'thyroid'};   
partitions = [1, 2, 3, 4, 5];
trialWidths = [1e-1, 1, 1e1]; %[1e-2, 1e-1, 1, 1e1, 1e2];
trainInst = 100;
testInst = 100;
orig_path = pwd;

for it = 1:length(fileNames)
  
  fprintf('Working with dataset: %s\n', fileNames{it});
  
  %%% Training models with different data realisations and
  %%% different trialWidths
  [paramRecord, likeRecord]  = bfdTrainModel(partitions, trialWidths,...
                                      modSpecs, optimset, fileNames{it});
  % Selecting the 'best' parameter set
  [params, selection] = bfdSelectWidth(paramRecord, likeRecord);
  
  %%% Loading training and test data
  %%% 

  % Training and testing the model for each 
  % data partition in the specified data set
  fprintf('Loading training & test data\n');
  [trainX, trainY] = bfdLoadData(fileNames{it}, 'train', trainInst);
  [testX, testY] = bfdLoadData(fileNames{it}, 'test', testInst);
  trainData = {trainX; trainY};
  testData = {testX; testY};
  
  fprintf('Making predictions & computing Prediction error\n')
  [err, predY, probY] = bfdComputeError(trainData, testData, ...
                                        modSpecs, params);
  % Computing average error etc.
  fprintf('Average error rate = %2.4f with std = %2.4f\n',...
         mean(err), std(err));

  bfdSaveData(modSpecs.kernelType, fileNames{it}, 'partialResults', params, ...
            err, predY, probY, paramRecord, likeRecord, optimset, ...
              modSpecs, partitions, trialWidths, selection);
  fprintf('Errors were computed.\n');
  
end % End of For loop

