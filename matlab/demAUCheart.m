
% DEMAUCHEART Demo to obtain AUC statistics for heart dataset

% BFD

% 
% Syntax:
% demAUCheart
%
% Description:
% This script can be run to recreate the results of the BFD paper,
% see [1] in 
%

% Defining parameters
dataset = 'heart';
kernelType = {'rbfard', 'linard', 'bias', 'white'};
dataType = 'test';
% Selecting parameters from stored results
selectParamsAndProject(dataset, kernelType, dataType, [], []);
% Generating ROC curves. Stores plots in a directory
generateROC(dataset, dataType, kernelType);
% Processing ROC data. Writes results into file.
processROCdata(dataset, dataType, kernelType); 