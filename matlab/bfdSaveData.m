function bfdSaveData(kernelType, dataset, resultType, params, varargin)

if isequal(version, '6.1.0.450 (R12.1)')
  result_path = ['/home/tpena/mlprojects/bfd/matlab/', ...
                    resultType, '/'];
  orig_path = '/home/tpena/mlprojects/bfd/matlab/';
elseif isequal(version, '6.5.0.180913a (R13)')
  result_path = ['H:\mlprojects\bfd\matlab\', resultType, '\'];
  orig_path = 'H:\mlprojects\bfd\matlab';
else
  result_path = ['/home/tpena/mlprojects/bfd/matlab/', ...
                    resultType, '/'];
  orig_path = '/home/tpena/mlprojects/bfd/matlab/';
end

% Going to recipient directory
if isequal(resultType, 'partialResults')
  if isequal(version, '6.1.0.450 (R12.1)')
    cd([result_path, dataset]);
  else
    cd([result_path, dataset]);
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
    fprintf('Error when saving, skipping...\n');
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

cd(orig_path);


