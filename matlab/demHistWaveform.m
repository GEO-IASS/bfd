
% DEMHISTWAVEFORM Demo for histograms of projections of Waveform 

% BFD

% 
% Syntax:
% demHistWaveform
%
% Description:
% This script can be run to recreate the results of the BFD paper,
% see [1] in README file.
%

% Defining parameters
dataset = 'waveform';
kernelType = {'rbf', 'bias', 'white'};
dataType = 'test';
% Projecting TEST data
selectParamsAndProject(dataset, kernelType, dataType, ...
                       [10, 100, 1000, 10000], []);

% Generating histograms for test data
fprintf('Generating histograms for %s data\n', dataType);
fprintf('Data type: %s\n', dataType);
fprintf('Dataset: %s\n', dataset);
generateHist(dataset, dataType, kernelType);

% Generating histograms for training data
dataType = 'train';
% Projecting TRAIN data
selectParamsAndProject(dataset, kernelType, dataType, ...
                       [10, 100, 1000, 10000], []);
fprintf('Generating histograms for %s data\n', dataType);
fprintf('Data type: %s\n', dataType);
fprintf('Dataset: %s\n', dataset);
generateHist(dataset, dataType, kernelType);