function [params, selection] = bfdSelectWidthFromFiles(dataset, kernelType)

% Moving to the data repository
orig_path = pwd;
try 
  cd(dataset);
catch
  fprintf('Directory doesn''t seem to exist');
end

% Creating a list with resulting files
dataList = dir([kernelType, '*_Error.mat']);
nFiles = length(dataList);

% Fetching the number nTrialWidths and 
% nPartitions from the registers on the files
for it = 1:nFiles
  file{it,1} = load(dataList(it).name);
  idxPartitions(it) = file{it}.params.info.it;
  idxTrialWidths(it) = file{it}.params.info.jit;
end

% Reading parameters for every stored file
for it = idxPartitions
  for jit = idxTrialWidths %idxTrialWidths
     paramRecord{it, jit} = file{jit + (it-1)*3}.params.params;
     likeRecord(it, jit) = file{jit + (it-1)*3}.params.bound;
  end
end

cd(orig_path);
[params, selection] = selectWidth(paramRecord, likeRecord);    

