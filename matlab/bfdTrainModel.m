function [paramRecord, likeRecord]  = ...
                               bfdTrainModel(partitions, trialWidths,...
                                          modSpecs, optimset, dataset)

% BFDTRAINMODEL Trains several BFD models according to partitions/trialWidths  

% BFD

% VERSION 1.11 IN CVS
%

% Setting constants
nPartitions = length(partitions);
nTrialWidths = length(trialWidths);

% Loading data
[trainX, trainY] = bfdLoadData(dataset, 'train', max(partitions));

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
    model = bfd(X, Y, modSpecs); 
    % Setting inverseWidth
    if ~isreal(trialWidths(jit))
      fprintf('inverseWidth is complex\n');
    end
    numIn = size(X,2);
    params = bfdParamInit(modSpecs.kernelType, numIn, trialWidths(jit));
    model.kern = kernExpandParam(model.kern, params);
    % Resetting prior and posterior covariance kernels
    model.kern.Kstore = kernCompute(model.kern, model.X);
    model.beta = model.beta;  % just a reminder
    model = bfdComputeAlpha(model);
    model = bfdUpdateSigma(model);
    % Optimising model
    model = bfdOptimiseBFD(model, options);
    
    % Storing results
    likeRecord(itCntr, jit) = bfdBound(model);
    params = kernExtractParam(model.kern);
    paramRecord{itCntr, jit} = [params, model.beta]; 
    
    % Saving partial results
    partialInfo.params = paramRecord{itCntr,jit};
    partialInfo.bound = likeRecord(itCntr,jit);
    partialInfo.info = struct('partition', partitions(itCntr), ...
                              'width', trialWidths(jit), 'it', it, 'jit', jit);
    
% $$$     % Use these lines only if you want to save partial results
% $$$     bfdSaveData(modSpecs.kernelType, dataset, ...
% $$$              'partialResults', partialInfo);
  end
end

