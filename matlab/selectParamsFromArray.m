function [params, beta, like, ...
          selPart, selWidth] = selectParamsFromArray(paramMtrx, ...
                                             betaMtrx, likeMtrx, ...
                                             delWidth, delPart)
 
% SELECTPARAMSFROMARRAY selects median parameters 

% BFD

% 
% Syntax:
% [params, beta, like, ...
%  selPart, selWidth] = selectParamsFromArray(paramMtrx, ...
%                                             betaMtrx, likeMtrx, ...
%                                             delWidth, delPart);
%
% Description:
% This function accepts as input an array of kernel parameters, a
% matrix of beta parameters and a matrix of likelihoods, each with
% dimensions [Npart, Ninit], where Npart are the total number of
% partitions and Ninit are the number of initialisations used. In
% the experiments reported in [1] (see README file), Npart = 5 and
% Ninit = 8. 
% This function takes LIKEMTRX and selects the elements that
% maximise each partition, with the associated indexes `IDX' being
% kept. Using IDX, the corresponding elements of BETAMTRX and
% PARAMMTRX are selected. Furthermore, the first element of each
% vector forming the array PARAMMTRX is extracted and the median
% value is taken. An new index MEDIDX corresponding to this
% selction is taken. MEDIDX is used to to pick up the selected
% values PARAMS, BETA and LIKE, which are the output of this
% function.
% 
% Inputs:
%   paramMtrx  : an [Npart, Ninit] cell array storing the kernel
%                parameters
%   betaMtrx   : an [Npart, Ninit] matrix with the values of the
%                precision parameter \beta.
%   likeMtrx   : an [Npart, Ninit] matrix with the values of the
%                likelihoods obtained after training a BFD.
%   delPart(*) : scalar specifying if a partition should be ignored 
%   delWidth(*): scalar specifying if an inverse width should be
%                ignored 
% Outputs:
%   params     : a [1, Ntheta] vector with selected kernel
%                parameters
%   beta       : a scalar with the selected precision
%   like       : a scalar with the selected likelihood
%   selPart    : scalar with the index of the selected partition
%   selWidth   : scalar with the index of the selected width
%
%
% See also: README file, SELECTPARAMSANDPROJECT
%

% Optional arguments
if nargin < 4
  delWidth = [];
end
if nargin < 5
  delPart = [];
end

% Verifying dimension of inputs is correct
if size(paramMtrx) ~= size(betaMtrx) |...
  size(betaMtrx) ~= size(likeMtrx)
  error('selectParamsFromArray: inputs should have same dimensions');
end

% Deleting rows or columns, if this is required
[paramMtrx, betaMtrx, ...
 likeMtrx, widths, parts] = delElements(paramMtrx, betaMtrx, ...
                                 likeMtrx, delWidth, delPart);

% Determining partitions and inv-widths used
[nPart, nWidths] = size(likeMtrx);

% Forming matrix of inv-widths
for it = 1:nPart
  for jit = 1:nWidths
    invWidthMtrx(it,jit) = exp(paramMtrx{it,jit}(1));
  end
end

% Finding the set of inv-widths (for each 
% partition) that maximise the likelihood
if nWidths > 1
  [maxLike, likeCol] = nanmax(likeMtrx');
else 
  likeCol = ones(1,nPart);
end

% Forming vector of indices
maxLikeIdx = [1:nPart; likeCol]';

% Retreiving inv-width parameters
for it = 1:length(maxLikeIdx)
  invWidths(it,1) = invWidthMtrx(maxLikeIdx(it,1), maxLikeIdx(it,2));
end

% Computing the median of the inv-widths 
% associated with the vector of likelihoods
medInvWidth = nanmedian(invWidths);

% Selecting the complete set of parameters  
selIdxWidth = find(medInvWidth == invWidths);

% Determining which partition and inv-width does
% the seletion corresponds to
selection = maxLikeIdx(selIdxWidth,:);
usedWidth = widths(selection(:,2))';
usedPart = parts(selection(:,1))';

msg = 'selParamsFromArray: ';
switch length(selIdxWidth)
 case 1
  fprintf([msg, 'unique selection corresponds to INITIAL inv-width %2.4f', ...
          ' and partition %2.4f\n'], usedWidth, usedPart);
 case 0
  fprintf([msg, 'median doesn''t belong to likeMtrx\n']);
  keyboard;
 otherwise
  numSelected = length(selIdxWidth);
  fprintf([msg, 'there were %2.4f selections\n'], ...
          numSelected);
  keyboard;
  fprintf([msg, 'Multiple selections that correspond to width ', ...
          '%2.4f and partition %2d\n'], usedWidth, usedPart);
  fprintf([msg, 'Randomly selecting among them\n']);
  idx = randperm(length(selection));
  idx = idx(1);
  selection = selection(idx,:);
  usedWidth = widths(selection(:,2));
  usedPart = parts(selection(:,1));
  fprintf([msg, 'Selected inv-width = %2.4f from partition = %2d', ...
           usedWidth, usedPart]);
end

% Creating output matrices from the selection
params = paramMtrx{selection(1), selection(2)};
beta = betaMtrx(selection(1), selection(2));
like = likeMtrx(selection(1), selection(2));

% Printing selected parameter
fprintf('***************************************\n');
fprintf('Selected INITIAL inv-Width is %2.4f\n', usedWidth);
usedWidth = widths(selection(2));
fprintf('After training this value became = %2.4f\n', ...
        params(1));
usedPart = parts(selection(1));
fprintf('And was obtained from training partition %2.4f\n', ...
        usedPart);
fprintf('Associated bound is %2.4f\n', likeMtrx(selection(1), selection(2)));
fprintf('***************************************\n');


% Function outputs
selPart = usedPart;
selWidth = usedWidth;


