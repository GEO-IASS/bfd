function bfdTestRecords(dataset, kernelType, idxPartitions)

% This function computes the error rate
% for a data set. It assumes that the
% parameters obtained from training the
% model ares stored inside a directory
% called DATASET

% Selecting the width first
 [params, selection] = selectWidthFromFile(dataset, kernelType, idxPartitions);
 
 fprintf('Loading training & test data\n');
fprintf('Working with dataset: %s\n', dataset);
trainInst = 100;
testInst = 100;
[trainX, trainY] = loadData(dataset, 'train', trainInst);
[testX, testY] = loadData(dataset, 'test', testInst);
trainData = {trainX; trainY};
testData = {testX; testY};

% Model specifications
modSpecs.kernelType = kernelType;
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.d = 2;
 

fprintf('Parameters are: %2.4f\n', params);
% $$$ fprintf('Associated bound: %2.4f\n', params.bound);
% $$$ fprintf('Other info: partition=%d, invWidth=%2.4f\n', ...
% $$$         params.info.partition, params.info.width);
 
fprintf('Making predictions & computing Prediction error\n')
error = computeError(trainData, testData, ...
                                   modSpecs, params);
meanError = mean(error);
stdError = std(error);
fprintf('mean = %2.4f and std = %2.4f\n', meanError, stdError);

if isequal(dataset, 'banana')
  [model,K]=createModel(trainData{1}{1}, trainData{2}{1}, ...
                        modSpecs, params.params(1:end-1), ...
                        params.params(end));
  f = K*model.alpha;
  model.bias = mean(f);
  fbdPlot(model, '');
end
  

