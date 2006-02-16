
% DEMAUCBANANA Demo to obtain AUC statistics for banana dataset

% BFD

% 
% Syntax:
% demAUCbanana
%
% Description:
% This script can be run to recreate the results of the BFD paper,
% see [1] in README file.
%

% Defining parameters
dataset = 'banana';
kernelType = {'rbf', 'bias', 'white'};
dataType = 'test';
% Selecting parameters from stored results
selectParamsAndProject(dataset, kernelType, dataType, [], []);
% Generating ROC curves. Stores plots in a directory
generateROC(dataset, dataType, kernelType);
% Processing ROC data. Writes results into file.
processROCdata(dataset, dataType, kernelType); 