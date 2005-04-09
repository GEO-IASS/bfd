function [paramRecord, likeRecord]  = ...
                               qbfdTrainModel(partitions, trialWidths,...
                                          modSpecs, optimset, dataset)

% QBFDTRAINMODEL Trains several BFD models according to partitions/trialWidths  

% QBFD

% Setting constants
nPartitions = length(partitions);
nTrialWidths = length(trialWidths);

% Loading data
[trainX, trainY] = loadData(dataset, 'train', max(partitions));

% Optimisation options
options = setOptions(optimset); 
itCntr = 0;

% Training nPartitions X nTrialWidths models and storing the results
% in a matrix (likelihoodRecord) and a cell (paramRecord)
for it = partitions
  itCntr = itCntr+1;
  for jit = 1:nTrialWidths
    fprintf('Parameters for Partition: %d and initial invWidth: %d\n', ...
            it, jit);
    % Adjusting X & Y according to the type of loaded data
    if iscell(trainX)
      X = trainX{it}; 
      Y = trainY{it};
    else
      X = trainX;
      Y = trainY;
    end
    
    % Creating model 
    model = qbfd(X, Y, modSpecs); 
    % Setting inverseWidth
    if ~isreal(trialWidths(jit))
      fprintf('inverseWidth is complex\n');
    end
    numIn = size(trainX{1},2);
    params = qbfdParamInit(modSpecs.kernelType, numIn, trialWidths(jit));
    model.kern = kernExpandParam(model.kern, params);
    % Resetting prior and posterior covariance kernels
    model.kern.Kstore = kernCompute(model.kern, model.X);
    model.beta1 = model.beta1;  % just a reminder
    model.beta0 = model.beta0;
    model = qbfdComputeAlpha(model);
    model = qbfdUpdateSigma(model);
    % Optimising model
    model = qbfdOptimiseQBFD(model, options);
    
    % Storing results
    likeRecord(itCntr, jit) = qbfdBound(model);
    params = kernExtractParam(model.kern);
    paramRecord{itCntr, jit} = [params, model.beta0, model.beta1]; 
    
    % Saving partial results
    partialInfo.params = paramRecord{itCntr,jit};
    partialInfo.bound = likeRecord(itCntr,jit);
    partialInfo.info = struct('partition', partitions(itCntr), ...
                              'width', trialWidths(jit), 'it', it, 'jit', jit);
    
    % Use these lines only if you want to save partial results
    qbfdSaveData(modSpecs.kernelType, [dataset], ...
             'partialResults', partialInfo);
  end
end

