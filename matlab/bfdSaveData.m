function bfdSaveData(kernelType, dataset, resultType, params, varargin)

% BFDSAVEDATA Saves results of (training a/classifying with a) BFD model
  
% BFD
  
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
  dataset  = [dataset, datestr(clock,30)];
else
  cd(result_path);
end

if nargin == 4
  try
    % Saving partial parameters
    save([kernelType{:} '_' dataset '_Error'], 'params');
  catch
    fprintf('bfdSaveData: Error when saving, skipping...\n');
  end  
else
  error = varargin{1}; 
  predY = varargin{2};
  probY = varargin{3};
  paramRecord = varargin{4};
  likeRecord = varargin{5};
  try
    % Saving final selection, error, among others
    save([kernelType{:} '_' dataset '_Error'], ...
                          'error', 'predY', 'probY', ...
                          'params', 'paramRecord', 'likeRecord');
  catch
    fprintf('Error when saving, skipping...\n');
  end  
end
% Going back to original directory
cd(orig_path);


