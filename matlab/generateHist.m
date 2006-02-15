function generateHist(dataset, dataType, kernelType)

% GENERATEHIST Creates histogram of the output distribution

% BFD

%
% Syntax:
% generateHist(dataset, dataType, kernelType);
%
% Description:
% This function generates histograms of the output distribution
% of a given dataset. The histograms are created from the
% projections of a given DATASET. The BFD algorithm is used to generate
% such projections.
% 
% Inputs:
%   dataset   : string specifying the name of the data to use
%   dataType  : any of the strings {'train', 'test'}
%   kernelType: a cell array of strings 
%
% See also: BFD, README file
%

% Loading file with projections
orig_path = pwd;
cd([dataset, 'Projections']);
fileProjStr = [strcat(kernelType{:}), '_', dataset, '*', ...
               dataType, '*projections', '.mat'];
fileProj = dir(fileProjStr);
dataProj = load(fileProj.name);
cd(orig_path);

% Sweeping through all files
Ninst = 100;
if isequal(dataset, 'splice') | isequal(dataset, 'image')
  Ninst = 20;
end

% Generating histograms 
testf = [];
ytest = [];
for jit = 1:Ninst
  testf = [normal(dataProj.testF{jit,1}); testf];
  ytest = [2*dataProj.testY{jit,1}-1; ytest];
end

% Saving plots and parameters
[class1, class0] = bfdHist(testf, ytest, 'fig');
t = get(gca, 'title');
set(t, 'string', [upper(dataset(1)), dataset(2:end), ' ', ...
                  dataType, ' set']);
set(t, 'fontname', 'times', 'fontsize', 16);
drawnow;

% Saving results and pictures
saveHist(dataset, dataType, kernelType, testf, ytest, orig_path);  


%%%
%%% Auxiliary functions
%%%

% Function to save histogram. Creates special directory to store
% results 
function saveHist(dataset, dataType, kernelType, ...
                  testf, ytest, orig_path);

% Creating directory to save results
cd(orig_path);
result_path = [dataset, '_avgHistogram/'];
[status, msg] = mkdir(result_path);
if status ~= 0  
  cd(result_path);
else 
  fprintf(['generateHist: ', msg, '\n']);
end

% Constructing file name
kernelStr = strcat(kernelType{:});
histStr = [dataset, '_', kernelStr, '_', dataType, '_avg_Hist'];
dataStr = [dataset, '_', kernelStr, '_', dataType, '_Data.mat'];

% Saving results
save(dataStr, 'dataset', 'dataType', 'kernelType', 'testf', 'ytest');

% Displaying figure and closing
figure(1); 
print(figure(1), '-depsc2', histStr); 
delete(1); pause(0.01);

% Going back to original directory
cd(orig_path);