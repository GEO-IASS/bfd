function [cellX, cellY] = bfdLoadData(name, type, Ninst)

% BFDLOADDATA Loads NINST files belonging to data set NAME

% BFD

% Moving to the data repository
orig_path = pwd;
try 
  if strfind(version, '7.0.1.24704')
    cd(['~/datasets/' name]);
  end
catch
  fprintf('Directory doesn''t seem to exist');
end

% Loading ALL instances of only the specified 
% amount NINST
switch nargin
 case 3
    [cellX, cellY] = loadFiles(name, type, Ninst);
 case 2
    [cellX, cellY] = loadFiles(name, type);
 otherwise
  error('LOADDATA: Error with number of input arguments');
end
cd(orig_path);

% Returning vectors in case only 
% 1 instance is requested
if Ninst == 1
  cellX = cellX{1};
  cellY = cellY{1};
end

%%%
%%% Auxiliary function to load the data
%%%
function [cellX, cellY] = loadFiles(name, type, Ninst)

% Constructing string to obtain file list
switch type
 case 'train'
  string = 'train';
 case 'test'
  string = 'test';
 otherwise
  error('There are only 2 options {train, test}');
end

% Constructing names of labels and data according to specified type
dataPrefix = [name, '_', string, '_data_']; 
labelPrefix = [name,'_', string, '_labels_'];

dataList = dir(['*', string, '*data*']);
labelList = dir(['*', string, '*labels*']); 
if Ninst > size(dataList,1);
  error(['Number of requested files is bigger than actual ' ...
         'realisations']);
elseif size(dataList,1) ~= size(labelList,1)
  error('There''s something fishy with the number of files');
end

cellX = cell(Ninst,1);
cellY = cell(Ninst,1);
for it = 1:Ninst
  cellX(it) = {load([dataPrefix, num2str(it), '.asc'], '-ascii')};
  cellY(it) = {0.5*(load([labelPrefix, num2str(it), '.asc'], '-ascii')+1)};
end
