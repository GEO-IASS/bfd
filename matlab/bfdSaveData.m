function bfdSaveData(kernelType, dataset, resultType, params, varargin)

% BFDSAVEDATA Saves into a file the results of training a BFD model
  
% BFD
  
%
% Syntax:
% bfdSaveData(kernelType, dataset, resultType, params, varargin);
%
% Description:
% It is recommended to apply this function after having trained a
% BFD model. The function stores in .MAT format the following
% information,
% 
% 1. MODEL      : the BFD structure
% 2. BOUND      : scalar with the value of the bound
% 3. DATASET    : string with the name of the training data used 
% 4. PARTITION  : The partition number according to the format used
%                 by Gunnar Raetsch.
% 5. KERNELTYPE     : a string with the name of the kernel used, eg RBF
% 6. INVWIDTH   : value of the initial INVWIDTH used for training
% 7. OPTIONS    : vector of parameters giving the optimization
%                 options
% 8. MODSPECS   : model specifications, see BFD function for more
%                 info
%
% If a TOY dataset is being used, then a plot of the discriminant
% and of the training data is saved in an .EPS file.
%
% Inputs
%   kernelType    : string with the name of the kernel, eg RBFARD,
%                                                      RBF...
%   dataset   : string with the name of the dataset used
%   resultType: fixed string to "partialResults" (legacy from an
%               older version of the toolbox
%   params    : a [t,1] vector with the parameters of the kernel
%   varargin  : it might be composed of two parts - INFO and/or
%                                                   TOYDATA
% Outputs
%   No value is returned from calling this function
%
% Other info  : INFO is a structure storing the data of points
%               (1)-(8) mentioned above.
%
% See also: BFDCLASSIFYDATA, DEMTOY
%

% Setting path to store results
orig_path = pwd;
result_path = dataset;

% Creating recipient directory (if it doesn't exist)
% and moving path to it
if isequal(resultType, 'partialResults')
  [status, msg] = mkdir(result_path);
  if status ~= 0  
    cd(dataset);
  else 
    fprintf(['bfdSaveData: ', msg, '\n']);
  end
  % Storing time tag only for toy data, i.e. if flag is set to one 
  if varargin{2}
    dataString  = [dataset, datestr(clock,30)];
  else 
    dataString = dataset;
  end
else
  error('SAVEDATA: only partial results can be saved');
end

% Saving. If the length of VARARGIN > 1, then a plot of the model
% is made, as this option is valid only for TOYDATA
if nargin > 4
  try
    model = varargin{1}{1}; 
    bound = varargin{1}{2};
    dataset = varargin{1}{3};
    dataType = varargin{1}{4};
    partition = varargin{1}{5};
    kernelType = varargin{1}{6};
    invWidth = varargin{1}{7};
    options = varargin{1}{8};
    modSpecs = varargin{1}{9};

    % Creating string with the name of the file to be saved
    partitionStr = num2str(partition);
    invWidthStr = num2str(invWidth);
    fileString = [kernelType{:}, '_', dataString, '-par-', partitionStr, ...
                  '-invW-', invWidthStr];
    save([fileString, '.mat'], 'model', 'bound', ...
         'dataset', 'dataType', 'partition', 'kernelType', ...
         'invWidth', 'options', 'modSpecs');
    % We save a plot of the 'toy' flag is set to one 
    if varargin{2}
      bfdPlot(model);
      print('-depsc2', [fileString, '.eps']);
      pause(1.5); close all;
    end   
  catch
    fprintf('Error when saving, skipping...\n');
    keyboard;
  end  
end
% Going back to original directory
cd(orig_path);


