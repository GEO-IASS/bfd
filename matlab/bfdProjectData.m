function [trainF, testF, model] = bfdProjectData(trainX, trainY, testX, ...
                                              testY, modSpecs, params)


  %%%
  %%% Creating a model with training data
  %%%
  
  [model, K] = bfd(trainX, trainY, modSpecs, ...
                             params(1:end-1), params(end));
  
  % Projecting the data on the line of discrimination
  trainF = K*model.alpha;
  
  %%%
  %%% TESTING THE MODEL
  %%%
  testF  = kernCompute(model.kern, testX, model.X)*model.alpha;