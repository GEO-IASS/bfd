function [params, selection] = bfdSelectWidth(paramRecord, likeRecord)

% BFDSELECTWIDTH Selects arameters in terms of the marginal like

% BFD
  
% Verifying that likelihood & param's matrices 
% have the same dimensions
if size(paramRecord) ~= size(likeRecord)
  error('selectWidth: inputs should have same dimensions');
end

[nPartitions, nTrialWidths] = size(likeRecord);

% Locating parameters that maximise the
% bound in each partition
if nTrialWidths > 1
  [w, index] = max(likeRecord');
else 
  index = ones(1,nPartitions);
end

% Selecting the max. likelihoods per partition
for it = 1:nPartitions
  selLike(it,1) = likeRecord(it,index(it));
end

% Selecting the median inverseWidth
medianLike = median(selLike);

% Selecting the complete set of parameters  
selCounter = 0;
for it = 1:nPartitions
  for jit = 1:nTrialWidths
    if medianLike == likeRecord(it,jit)
      params = paramRecord{it,jit};
      selection = [it, jit];
      selCounter = selCounter + 1;
    end
  end
end

if selCounter > 1
  fprintf('bfdTrainModel: there were multiple selections\n');
  keyboard;
end

% Printing selected parameter
fprintf('***************************************\n');
fprintf('Selected invWidth is %2.4f\n', params(1));
fprintf('Which corresponds to initialisation No. %d\n', ...
        selection(2));
fprintf('Associated bound is %2.4f\n', likeRecord(selection(1), selection(2)));
fprintf('***************************************\n');
