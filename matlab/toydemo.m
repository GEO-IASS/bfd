% TOYDEMO Script to classify Toy data and to plot the results

% BFD

% Setting optimisation options
optimset.Display = 'off';
optimset.TolX = 1e-8;
optimset.TolFun = 1e-8;
optimset.DerivativeCheck = 'off'; 
optimset.MaxFunEvals = 0;
optimset.MaxIter = 1500;   % optimiser iters
optimset.MaxOuterIter = 5000; % loop iters
optimset.Bound = 'off';
optimset.TolBound = 1e-4;
optimset.TolBeta = 1e-7;
optimset.TolTheta = 1e-6;
options = setOptions(optimset);

% Model specifications
modSpecs.kernelType = {'rbfard', 'linard', 'bias', 'white'};
modSpecs.TieARD = length(findstr('ard', strcat(modSpecs.kernelType{:}))) > 0;
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.d = 2;

% Specifying toy data and initialisation
% parameters
fileNames = {'bumpy', 'overlap', ...
             'toyARD', 'full-spiral'};
partitions = [1];
otherWidths = [1, 10, 100];
spiralWidths = [1, 500, 5000];
orig_path = pwd;

% Iterating over every file
for it = 1:length(fileNames)

  % Initialisations change according to data set
  if length(findstr('spiral', fileNames{it})) ~= 0
    trialWidths = spiralWidths;
  else
    trialWidths = otherWidths;
  end
  
  fprintf('Working with dataset: %s\n', fileNames{it});
  
  % Training models with different data realisations and
  % different inverse widths
  [paramRecord, likeRecord]  = bfdTrainModel(partitions, trialWidths,...
                                      modSpecs, optimset, fileNames{it});
  % Selecting the 'best' parameter set
  params = bfdSelectWidth(paramRecord, likeRecord);
  
  % Creating a new model and projecting test data
  newSpecs = modSpecs;
  [testX, testY] = bfdLoadData(fileNames{it}, 'train', length(partitions));
  [newModel, K] = bfd(testX{1}, testY{1}, newSpecs, params(1:end-1), params(end));
  f = K*newModel.alpha;
  newModel.bias = mean(f);
  
  % Plotting results
  bfdPlot(newModel, 'Using original code', ...
           modSpecs.kernelType, fileNames{it});
  %bfdSaveData(modSpecs.kernelType, fileNames{it}, 'toyResults', params); 
 
end % End of For loop

