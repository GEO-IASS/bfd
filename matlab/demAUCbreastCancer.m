
% DEMAUCBREASTCANCER Demo to obtain AUC statistics for breast-cancer dataset

% BFD

% 
% Syntax:
% demAUCbreast-cancer
%
% Description:
% This script can be run to recreate the results of the BFD paper,
% see [1] in 
%

% Defining parameters
dataset = 'breast-cancer';
kernelType = {'rbf', 'bias', 'white'};
dataType = 'test';
% Selecting parameters from stored results
selectParamsAndProject(dataset, kernelType, dataType, [10, 100], []);
% Generating ROC curves. Stored plot in a directory
generateROC(dataset, dataType, kernelType);
% Processing ROC data. Writes results into a file
processROCdata(dataset, dataType, kernelType); 