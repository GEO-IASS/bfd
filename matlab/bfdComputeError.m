function [err, predY, probY] = bfdComputeError(trainData, testData, ...
                                              modSpecs, params)

% BFDCOMPUTEERROR Computes prediction error on test data

% BFD

% VERSION 1.11 IN CVS
%

% Note: this function uses training data to compute the centres
% and std's of the Gaussians that model both classes. This is
% required to project the test data & to compute the class. error

% Verifying training/test data
if size(trainData) ~= size(testData)
  error(['ComputeError: there''s something wrong with train/test ' ...
         'data']);
end
nInst = length(trainData{1});

for it = 1:nInst
  % Assigning data
  trainX = trainData{1}{it}; trainY = trainData{2}{it};
  testX = testData{1}{it}; testY = testData{2}{it};
  
  [trainF, testF, model] = bfdProjectData(trainX, trainY, testX, testY, ...
                             modSpecs, params);
  [predY{it,1}, probY{it,1}] = bfdMakePredictions(model, trainF, ...
                                                  trainY, testF);
  
end % End of For

% Computing prediction error
% Computing the test error
for it = 1:nInst
  err(it,1) = sum(predY{it} ~= testData{2}{it})./...
                      length(testData{2}{it});
end

