function [trainF, testF, model] = bfdProjectData(trainX, trainY, testX, ...
                                              testY, modSpecs, params)

% BFDPROJECTDATA Projects training and test data over discriminant

% BFD

% VERSION 1.11 IN CVS
%

%Creating a model with training data 
[model, K] = bfd(trainX, trainY, modSpecs, ...
                           params(1:end-1), params(end));
  
% Projecting the data on the line of discrimination
trainF = K*model.alpha;
  
% Obtaining projections of new test points
testF  = kernCompute(model.kern, testX, model.X)*model.alpha;