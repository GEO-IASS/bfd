function [cellX, cellY] = bfdLoadData(name, type, Ninst)

% Loads NINST files in the data set named NAME

% Moving to the data repository
orig_path = pwd;
try 
  if isequal(version, '6.1.0.450 (R12.1)')
    cd(['/home/tpena/datasets/' name]);
  elseif isequal(version, '6.5.0.180913a (R13)')
    cd(['H:\datasets\' name]);
  else
    cd(['/home/tpena/datasets/' name]);
  end
catch
  fprintf('Directory doesn''t seem to exist');
end

switch nargin
 case 3
    [cellX, cellY] = loadData(name, type, Ninst);
 case 2
    [cellX, cellY] = loadData(name, type);
 otherwise
  error('LOADDATA: Error with number of input arguments');
end
cd(orig_path);


%%%
%%% Auxiliary function to load the data
%%%
function [cellX, cellY] = loadData(name, type, Ninst)

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
