function bfdTestToy(dataset, kernelType)

% TESTTOYPARAMS Plots 
  
% BFD 

% Model specifications
modSpecs.kernelType = kernelType;
modSpecs.TieARD = length(findstr('ard', strcat(modSpecs.kernelType{:}))) > 0;
modSpecs.gamma = struct('a', 0.5, 'b', 0.5);
modSpecs.d = 2;

% Going to the appropriate directory
orig_path = pwd;
result_path = dataset;

% Loading training data
[X, Y] = bfdLoadData(dataset, 'train', 1);
testData = {{X}; {Y}};
trainData = testData;

% loading file names
cd(result_path);
fileNames = dir([strcat(kernelType{:}), '_', dataset, '20*.mat']);
cd(orig_path);

for it = 1:length(fileNames) % taking out (.) & (..)
  % Loading 
  cd(result_path);
  load(fileNames(it).name);
  cd(orig_path);

  % Creating a new model and projecting test data
  
  [newModel, K] = bfd(X, Y, ...
                              modSpecs, params.params(1:end-1), ...
                              params.params(end));
  f = K*newModel.alpha;
  newModel.bias = mean(f);
  
  % Plotting results
  bfdPlot(newModel); title(['Model no.', num2str(it)]);
  fprintf('Initial width = %2.4f\n', params.info.width);
  fprintf('Bound associated to model = %2.6f\n', params.bound); 
  % Computing classification error over training set
  [error, predY, probY] = bfdComputeError(trainData, testData, ...
                                          modSpecs, params.params);
  fprintf('Classification error %2.4f\n', error);
  
  % Displaying the value of FINAL inverseWidth
  fprintf('Inversewidth is %2.4f\n', ...
          negLogLogitTransform(params.params(1), 'atox'));
  
  fprintf('****************************\n');
  fprintf('Press keyboard to continue\n');  
  if it < length(fileNames)
    pause;
  end 
end

