function [trainF, testF] = selectParamsAndProject(dataset, kernelType, ...
                                       dataType, delWidth, delPart)

% SELECTPARAMSANDPROJECT projects data with selected model params 
  
% BFD

% 
% Syntax:
% [trainF, testF] = selectParamsAndProject(dataset, kernelType, ...
%                                          dataType, delWidth, delPart)
%
% Description:
% This function has been designed for processing the UCI data
% provided by Gunnar Raetsch, see references [5,6] in the README
% file. 
% The processing consists of projecting Training and Test instances
% of a given DATASET over the line of discrimination obtained by
% applying a `Bayesian Fisher discriminant', see [1].
% We follow the methodology of model selection proposed by [6] and
% [7] whereby the first 5 instances of the Training
% instances of a given DATASET are used to train an algorithm, in
% this case BFD. According to [6] and [7], among the 5 
% resulting sets of parameters, the median value was selected.
%
% How this works...
% This function takes the results of having trained BFD over the 5 
% training sets and takes the median value.
% This toolbox includes the BFD results from training the DATASET in
% a directory called `DATASETResults/'. 
% There are two types of results stored:
% a) those obtained from applying an RBF kernel and b) those from
% applying an ARD one. Check the directory DATASETResults/ for more
% information. Hence the KERNELTYPE parameter should
% specify something like the following:
%               RBF - {'rbf', 'bias', 'white'}
%               ARD - {'rbfard', 'linard', 'bias', 'white'}
% 
% The parameter DATATYPE specifies which type of data should be
% projected, either Training or Test type. This is a legacy from an
% older version of the toolbox, so it should be set to TEST. 
% DELWIDTH and DELPART are optional parameters that allow to ignore
% certain initialisations (inverse widths) or partitions used in
% the selection process. As a rule of thumb, both parameters should
% be set to EMPTY, i.e. `[]'.
% 
% Inputs:
%
%   dataset    : string with the name of the dataset
%   kernelType : cell array of strings specifying the type of 
%                kernel used. See README.txt
%   dataType   : string with either of the values {'train', 'test'}
%   delWidth(*): scalar specifying which inverse Width to ignore 
%   delPart(*) : scalar specifying which partition to ignore
% Outputs:
%   trainF     : cell with projections over all instances of
%                training data
%   testF      : cell with projections over all instances of test
%                data 
%
% See also: README file
%

% Checking input arguments
if nargin < 4
  delWidth = [];
end
if nargin < 5
  delPart = [];
end
  
% Moving to directory where results are stored
orig_path = pwd;
storedResults = 'gunnarClassResults';
results_path = [orig_path, '/', storedResults];
cd(results_path);

% Loading likeMtrx, betaMtrx, paramMtrx and going back to original 
% directory 
resFile = dir([strcat(kernelType{:}), '*', dataset, '.mat']);
fileMtrx = load(resFile.name);
paramMtrx = fileMtrx.paramMtrx;
betaMtrx = fileMtrx.betaMtrx;
likeMtrx = fileMtrx.likeMtrx;
cd(orig_path);

% Selecting Median parameters 
[params, beta, like, ...
 selPart, selWidth] = selectParamsFromArray(...
                         paramMtrx, betaMtrx, likeMtrx, delWidth, delPart);

% Model specifications
modSpecs.kernelType = strcat(kernelType{:});
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.dist = 2;

% Loading training and test data
fprintf('Loading training & test data\n');
fprintf('Working with dataset: %s\n', dataset);
fprintf('Working with kernel: %s\n', strcat(kernelType{:}));
Ninst = 100;
if isequal(dataset, 'splice') | isequal(dataset, 'image')
  Ninst = 20;
end

% Projecting data
fprintf('Projecting data\n')  
for it = 1:Ninst
  [Xtrain, Ytrain] = loadData(dataset, 'train', it); %%%'train' before
  [Xtest, Ytest] = loadData(dataset, dataType, it);
  [ftrain, ftest, model] = projectData(Xtrain, Ytrain, ...
                                          Xtest, Ytest, ...
                                          modSpecs, params, beta);
  testY{it,1} = Ytest;
  trainF{it,1} = ftrain;
  testF{it,1} = ftest;
end

% Saving projections & other stuff
fileName = fetchFileName(selPart, selWidth, dataset, kernelType);
saveProjectedData(fileName, dataset, trainF, testF, testY, dataType);


%%% 
%%% Auxiliary functions
%%%
 
% Function to save data
function saveProjectedData(fileName, dataset, trainF, testF, testY, dataType)

% Saving results
orig_path = pwd;
result_path = [dataset, 'Projections'];

% Going to recipient directory
[status, msg] = mkdir(result_path);
if status ~= 0  
   cd(result_path);
else 
  fprintf(['projectDataFromFiles: ', msg, '\n']);
end
dataString  = [strrep(fileName, '.mat', '_'), ...
               '_', dataType, '_Data_projections.mat'];
save(dataString, 'trainF', 'testF', 'testY');
cd(orig_path);
  

% Display info
function displayInfo(params, beta, like, selPart, selWidth) 
fprintf('After exp. parameters are: %2.4f\n', exp(params));
fprintf('Beta is %2.4f\n', beta);
fprintf('Associated bound: %2.4f\n', like);
fprintf('Other info: partition=%d, invWidth=%2.4f\n', ...
        selPart, selWidth);


% Fetches name of selected parameter file
function fileName = fetchFileName(selPart, selWidth, dataset, kernelType)
partitionStr = num2str(selPart);
invWidthStr = num2str(selWidth);
fileName = [kernelType{:}, '_', dataset, '-par-', partitionStr, ...
              '-invW-', invWidthStr];

