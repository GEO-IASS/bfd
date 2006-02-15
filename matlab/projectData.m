function [ftrain, ftest, model] = projectData(Xtrain, ytrain, ...
                                              Xtest, ytest, modSpecs, ...
                                              params, beta)

% PROJECTDATA Projects training and test data over discriminant

% BFD

%
% Syntax:
% [ftrain, ftest, model] = projectData(Xtrain, ytrain, ...
%                                      Xtest, testY, modSpecs, ...
%                                      params, beta)
%
% Description:
% This function takes a set of training data (XTRAIN,YTRAIN), a set
% of test data (XTEST, YTEST) and projects it over the direction of
% discrimination obtained with BFD. The inputs MODSPECS, PARAMS and
% BETA give the MODEL specifications, the parameters of the kernel
% (PARAMS) and the value of the precision (BETA).  
% This function should be used exclusively by SELECTPARAMSANDPROJECT.
%
% Inputs:
%   Xtrain    : an [Npart,1] cell array with all the training
%               instances of a given dataset
%   ytrain    : an [Npart,1] cell array with all the training
%               labels of a given dataset
%   Xtest     : an [Npart,1] cell array with all the test instances
%               of the dataset
%   ytest     : an [Npart,1] cell array with all the test labels of
%               of the dataset
%   modSpecs  : a structure with the fields: {kernel, gamma, ...
%                                             dist, beta}
%   params    : a [t,1] vector of kernel parameters \Theta.
%   beta      : a scalar that is the precision of the noise model
%
% See also: SELECTPARAMSANDPROJECT
%

% Creating a model with training data 
[model, K] = bfd(Xtrain, ytrain, modSpecs, params, beta);
  
% Projecting the data on the line of discrimination
ftrain = K*model.alpha;
  
% Obtaining projections of new test points
ftest  = computeKernel(model.kern.lntheta, model.kern.type, ...
                       Xtest, model.X)*model.alpha;