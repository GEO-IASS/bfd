function [trainF, testF, model] = qbfdProjectData(trainX, trainY, testX, ...
                                              testY, modSpecs, params)

% QBFDPROJECTDATA Projects training and test data over discriminant

% QBFD

%Creating a model with training data 
[model, K] = qbfd(trainX, trainY, modSpecs, ...
                           params(1:end-2), params(end-1), params(end));
  
% Projecting the data on the line of discrimination
trainF = K*model.alpha;
  
% Obtaining projections of new test points
testF  = kernCompute(model.kern, testX, model.X)*model.alpha;