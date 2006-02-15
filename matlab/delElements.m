function [paramMtrx, betaMtrx, ...
          likeMtrx, widths, parts] = ...
                                     delElements(paramMtrx, betaMtrx, ...
                                              likeMtrx, delWidth, ...
                                                 delPart);

% DELELEMENTS deletes columns or rows of a given matrix

% BFD/PROJECTDATA

%
% Syntax:
% [paramMtrx, betaMtrx, ...
% likeMtrx, widths, parts] = delElements(paramMtrx, betaMtrx, ...
%                                        likeMtrx, delWidth, delPart);
% 
% Description:
% This is an auxiliary function that is used exclusively by
% SELECTPARAMSFROMARRAY. It is used in case a particular inverse
% width or a partition wants to be ignored from the selcetion
% process. By selection we mean the process of choosing the MEDIAN
% value of the parameters, as described in references [2,3,4]; see
% README file.
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
%   paramMtrx  : a reduced cell array storing the kernel
%                parameters
%   betaMtrx   : a reduced  matrix with the values of the
%                precision parameter \beta
%   likeMtrx   : a reduced matrix with the values of the
%                likelihoods obtained after training a BFD.
%   widths     : a vector specifying which widths weren't ignored
%   parts      : a vector specifying the partitions that weren't
%                ignored
% 
% See also: SELECTPARAMSFROMARRAY, README file
%

% In case no optional input arguments are given 
if nargin < 4
  delWidth = [];
end

if nargin < 5
  delPart = [];
end

% Size of the original matrices
[nPart, nWidths] = size(likeMtrx);

% Inv Widths for rbfbiaswhite & 
% rbfardlinardbiaswhite kernels
switch nWidths
 case 8
  widths = [1e-4, 1e-3, 1e-2, 1, 10, 100, 1000, 10000];
 case 3
  widths = [1e-3, 1, 10];
end

% Deleting selected width
[widths, idxUsedWidths] = setdiff(widths, delWidth);


% The number of partitions used was the same
% for rbfbiaswhite & rbfardlinardbiaswhite
% kernels
parts = 1:5;

% Deleting selected partition
[parts, idxUsedParts] = setdiff(parts, delPart);


% Forming matrices
[col,row] = meshgrid(idxUsedWidths, idxUsedParts); 
indices = [row(:), col(:)];
for it = 1:length(indices)
  paramMtrx_r(it,1) = paramMtrx(indices(it,1), indices(it,2));
  betaMtrx_r(it,1) = betaMtrx(indices(it,1), indices(it,2));
  likeMtrx_r(it,1) = likeMtrx(indices(it,1), indices(it,2));
end

% Formatting reduced outputs
newSize = [length(idxUsedParts), length(idxUsedWidths)];
paramMtrx = reshape(paramMtrx_r, newSize);             
likeMtrx = reshape(likeMtrx_r, newSize);
betaMtrx = reshape(betaMtrx_r, newSize);
