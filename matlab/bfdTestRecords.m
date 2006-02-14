function bfdTestRecords(dataset, kernelType)

% BFDTESTRECORDS

% BFD

% VERSION 1.11 IN CVS
%

% This function computes the error rate
% for a data set. It assumes that the
% parameters obtained from training the
% model ares stored inside a directory
% called DATASET

% Selecting the width first
 [params, selection] = bfdSelectWidthFromFiles(dataset, kernelType);
 
fprintf('Loading training & test data\n');
fprintf('Working with dataset: %s\n', dataset);
toy = isToyData(dataset);
if ~toy
    trainInst = 100;
    testInst = 100;
    [trainX, trainY] = bfdLoadData(dataset, 'train', trainInst);
    [testX, testY] = bfdLoadData(dataset, 'test', testInst);
    trainData = {trainX; trainY};
    testData = {testX; testY};
else
    trainInst = 1;
    testInst = 1;
    [trainX, trainY] = bfdLoadData(dataset, 'train', trainInst);
    [testX, testY] = bfdLoadData(dataset, 'train', testInst);
    trainData = {{trainX}; {trainY}};
    testData = {{testX}; {testY}};
end


% Model specifications
modSpecs.kernelType = kernelType;
modSpecs.TieARD = length(findstr('ard', strcat(modSpecs.kernelType{:}))) > 1;
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.d = 2;
 

fprintf('Parameters are: %2.4f\n', params);
% $$$ fprintf('Associated bound: %2.4f\n', params.bound);
% $$$ fprintf('Other info: partition=%d, invWidth=%2.4f\n', ...
% $$$         params.info.partition, params.info.width);
 
fprintf('Making predictions & computing Prediction error\n')
error = bfdComputeError(trainData, testData, ...
                                   modSpecs, params);
meanError = mean(error);
stdError = std(error);
fprintf('mean = %2.4f and std = %2.4f\n', meanError, stdError);

if toy
  [model,K]=bfd(trainData{1}{1}, trainData{2}{1}, ...
                        modSpecs, params(1:end-1), params(end));
  f = K*model.alpha;
  model.bias = mean(f);
  bfdPlot(model, '');
  fprintf('Press any key\n'); %pause;
end
  

function toy = isToyData(dataset)
% Sets to flag to 1 if data set belongs to toy data
    toy = isequal(dataset, 'banana') | isequal(dataset, 'bumpy') | ...
        isequal(dataset, 'toyARD') | isequal(dataset, 'overlap') | ...
        isequal(dataset, 'full-spiral');