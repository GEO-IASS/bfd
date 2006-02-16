function [A, meanA, medA, ...
          minA, maxA] = processROCdata(dataset, dataType, kernelType)

% PROCESSROCDATA Computes mean and std from the ROC-generated data 

% BFD

% 
% Syntax:
% [A, meanA, medA, ...
%     minA, maxA] = processROCdata(dataset, dataType, kernelType)
%
% Description:
% Computes the mean, median, best & worst area `A' under the ROC
% curve for the datasets given by Gunnar Raetsch. See [5] for the
% data and [1] for the results. References given in the README
% file.  
% This function should be used only after GENERATEROC has been
% applied. 
%
% See also: GENERATEROC, README file
%

% Fetching data from directory 
orig_path = pwd;
result_path = [dataset, 'ROC'];
cd(result_path);

% Searching for files according to kernel type
% Files without kernel tag on their name belong 
% to 'rbfbiaswhite'
kernelStr = strcat(kernelType{:});
rocFiles = dir([dataset, '*', kernelStr, '*', ...
                dataType, '*.mat']);
fileStr = [dataset, '_', kernelStr, '_', dataType, ...
             '_AUC_info.txt'];

nInst = length(rocFiles);

% Loading data
for it = 1:nInst
  file(it,1) = load(rocFiles(it).name);
  AUC(it,1) = file(it).area; 
end

% Outputs
meanAUC = mean(AUC);
medAUC = median(AUC);
minAUC = min(AUC);
maxAUC = max(AUC);
stdAUC = std(AUC);

% Saving data to text file
fid = fopen(fileStr, 'w');
fprintf(fid, 'Dataset: %s\n', dataset);
fprintf(fid, 'Kernel used: %s\n', kernelStr); 
fprintf(fid, 'These are some statistics of the ROC curves\n');
fprintf(fid, '###########################################\n');
fprintf(fid, 'mean = %2.6f\n', meanAUC);
fprintf(fid, 'median = %2.6f\n', medAUC);
fprintf(fid, 'max = %2.6f\n', maxAUC);
fprintf(fid, 'min = %2.6f\n', minAUC);
fprintf(fid, 'std = %2.6f\n', stdAUC);
fclose(fid);

% Goind back to original directory
cd(orig_path);
