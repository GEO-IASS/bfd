function [paramRecord, likeRecord]  = ...
                               bfdTrainModel(partitions, trialWidths,...
                                          modSpecs, optimset, dataset)
 
% Setting constants
nPartitions = length(partitions);
nTrialWidths = length(trialWidths);

[trainX, trainY] = bfdLoadData(dataset, 'train', max(partitions));

% Optimisation options
options = setOptions(optimset); 
itCntr = 0;

for it = partitions
  itCntr = itCntr+1;
  for jit = 1:nTrialWidths
    fprintf('Parameters for Partition: %d and initial invWidth: %d\n', ...
            it, jit);
    % Creating model 
    model = bfd(trainX, trainY, modSpecs); 
    % Setting inverseWidth
    if ~isreal(trialWidths(jit))
      fprintf('inverseWidth is complex\n');
    end
    numIn = size(trainX,2);
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
    %bfdSaveData(modSpecs.kernelType, [dataset], ...
    %         'partialResults', partialInfo);
  end
end

