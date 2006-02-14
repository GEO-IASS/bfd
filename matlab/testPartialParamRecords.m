function testPartialParamRecords(dataset, kernelType)

% TESTPARTIALPARAMRECORDS computes error for partial parameter set 

% BFD


% VERSION 1.11 IN CVS
%

% Note:
% This script computes the errors associated with EACH
% of the parameters stored in the structure  PARAMRECORD.
% Therefore, if there were "Ni" different initialisations, 
% this function will produce "Ni" different errors.
%
% INFO: compare against TESTERRORRECORDS, as they might 
%       perform similar tasks.

% Loading training and test data
fprintf('Loading training & test data\n');
fprintf('Working with dataset: %s\n', dataset);
trainInst = 100;
testInst = 100;
[trainX, trainY] = bfdLoadData(dataset, 'train', trainInst);
[testX, testY] = bfdLoadData(dataset, 'test', testInst);
trainData = {trainX; trainY};
testData = {testX; testY};

% Model specifications
modSpecs.kernelType = kernelType;
modSpecs.TieARD = length(findstr('ard', strcat(modSpecs.kernelType{:}))) > 1;
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.d = 2;
 
% Going to the appropriate directory
orig_path = pwd;
result_path = [pwd, '/', dataset];

% loading file names
cd(result_path);
fileNames = dir([strcat(kernelType{:}), '*.mat']);

for it = 1:length(fileNames) % taking out (.) and (..) dir's
  cd(result_path);
  load(fileNames(it).name);
  fprintf('Parameters are: %2.4f\n', params.params);
  fprintf('Associated bound: %2.4f\n', params.bound);
  fprintf('Other info: partition=%d, invWidth=%2.4f\n', ...
          params.info.partition, params.info.width);
  
  cd(orig_path);
  fprintf('Making predictions & computing Prediction error\n')
  error{it} = bfdComputeError(trainData, testData, ...
                                     modSpecs, params.params);
  meanError(it) = mean(error{it});
  stdError(it) = std(error{it});
  fprintf('mean = %2.4f and std = %2.4f\n', meanError(it), stdError(it));

  if isequal(dataset, 'banana')
    [model,K]=createModel(trainData{1}{1}, trainData{2}{1}, ...
                          modSpecs, params.params(1:end-1), ...
                          params.params(end));
    f = K*model.alpha;
    model.bias = mean(f);
    bfdPlot(model, '');
  end
  

end

