function generateROC(dataset, dataType, kernelType)

% GENERATEROC Creates ROC curves for a given dataset

% BFD

% 
% Syntax:
% generateROC(dataset, dataType, kernelType);
%
% Description:
% This function is to be used after a given DATASET has been
% projected with SELECTPARAMSANDPROJECT. It generates NINST plots
% with the ROC curves of the projected data, where NINST is the
% number of instances of the DATASET. DATATYPE specifies whether
% 'training' or 'test' data will be used, while KERNELTYPE
% indicates the type of kernel. Note that the input values of this
% function should go in accordance to the the ones used in
% SELECTPARAMSANDPROJECT. 
% The results from applying this function to Gunnar Raetsch's
% datasets are reported in [1], see README file.
% 
% Inputs:
%   dataset   : string with the name of the dataset
%   dataType  : string with either of the values {'train', 'test'}
%   kernelType: cell array of strings specifying the type of 
%               kernel used. See README.txt
%
% See also: SELECTPARAMSANDPROJECT, README file.
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

% Generating ROC curves and saving parameters. We use the ROC
% function provided by the ls-SVMlab toolbox
for jit = 1:Ninst
  testf = -dataProj.testF{jit,1};
  ytest = 2*dataProj.testY{jit,1}-1;
  [area, se, thres, onMinSpec, sens, ...
   TN, TP, FN, FP] = roc(testf, ytest, 'figure');
  drawnow;
  
  % Saving results and pictures
  saveROC(dataset, jit, area, se, thres, onMinSpec, ...
          sens, TN, TP, FN, FP, testf, ytest, orig_path, ...
          dataType, kernelType);  
end


%%%
%%% Auxiliary functions
%%%

% Function to save results in a directory ...
function saveROC(dataset, No, area, se, thres, ...
                 onMinSpec, sens, TN, TP, FN, FP, testf, ytest, ...
                 orig_path, dataType, kernelType);

% Creating directory to save results
cd(orig_path);
result_path = [dataset, 'ROC/'];
[status, msg] = mkdir(result_path);
if status ~= 0  
  cd(result_path);
else 
  fprintf(['generateROC: ', msg, '\n']);
end

% Constructing file name
kernelStr = strcat(kernelType{:});
rocStr = [dataset, '_', kernelStr, '_', dataType, '_ROC'];
dataStr = [dataset, '_', kernelStr, '_', dataType, '_Data_', ...
           num2str(No), '.mat'];

% Saving results
save(dataStr, 'area', 'se', 'thres', 'onMinSpec', 'sens', ...
     'TN', 'TP', 'FN', 'FP', 'testf', 'ytest');
figStr = [rocStr, '_figure','_', num2str(No)];
print(figure(1), '-depsc2', figStr); 
delete(1); pause(0.01);
cd(orig_path);
