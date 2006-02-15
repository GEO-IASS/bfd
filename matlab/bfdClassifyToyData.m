function model = bfdClassifyToyData(dataset, kernelType)
 
% DEMTOY Function to classify TOY data sets

% BFD

% Syntax:
% model = demToy(dataset, kernelType);
%
% Description:
% This function classifies any of the four synthetic datasets used
% in the experiments reported in [4], see README file. The
% classification can be done according to any of the available
% kernels of the toolbox, see README file for futher reference.
%
% Inputs
%   dataset   : string with the name of the DATASET used
%   kernelType: cell array of string specifying the type of kernel
%               used. 
% Outputs
%   model     : data structure that stores the information related
%               to the DATASET after being trained with BFD.
%
% See also: README file
%


% Setting optimisation options
optset.Display = 'off';
optset.TolX = 1e-8;
optset.TolFun = 1e-8;
optset.DerivativeCheck = 'off'; 
optset.MaxFunEvals = 0;
optset.MaxIter = 1500;   % optimiser iters
optset.MaxOuterIter = 500; % loop iters
optset.Bound = 'off';
optset.TolBound = 1e-3;
optset.TolTheta = 1e-6;
options = setOptions(optset);

% Setting dataType, partition, etc.
dataType = 'train';
partition = 1;
% Setting inverseWidth
if isequal(dataset, 'spiral')
  invWidth = 100;
else
  invWidth = 1;
end

% Calling main function
[waste, model] = bfdClassifyData(dataset, dataType, partition, ...
                               kernelType, invWidth, options);
