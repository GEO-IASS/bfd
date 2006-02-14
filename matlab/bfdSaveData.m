function bfdSaveData(kernelType, dataset, resultType, params, varargin)

% BFDSAVEDATA Saves results of (training a/classifying with a) BFD model
  
% BFD
  
% VERSION 1.11 IN CVS
%

% Setting path to store results
orig_path = pwd;
result_path = dataset;

% Going to recipient directory
if isequal(resultType, 'partialResults')
  [status, msg] = mkdir(result_path);
  if status ~= 0  
    cd(dataset);
  else 
    fprintf(['bfdSaveData: ', msg, '\n']);
  end
  dataString  = [dataset, datestr(clock,30)];
else
  error('SAVEDATA: only partial results can be saved');
end

% Saving ...
if nargin > 4
  try
    err = varargin{1}; 
    predY = varargin{2};
    probY = varargin{3};
    paramRecord = varargin{4};
    likeRecord = varargin{5};
    optimset = varargin{6};
    modSpecs = varargin{7};
    partitions = varargin{8};
    trialWidths = varargin{9};
    selPart = varargin{10}(1);
    selInvW = varargin{10}(2);
    
    partitionStr = num2str(selPart);
    invWidthStr = num2str(selInvW);
    % Saving final selection, error, among others
    save([kernelType{:}, '_', dataString, '-par-', partitionStr, ...
         '-invW-', invWidthStr, '.mat'], 'err', 'predY', ...
         'probY', 'paramRecord', 'likeRecord', 'kernelType', ...
         'optimset', 'modSpecs', 'partitions', 'trialWidths', ...
         'selPart', 'selInvW');
  catch
    fprintf('Error when saving, skipping...\n');
  end  
end
% Going back to original directory
cd(orig_path);


