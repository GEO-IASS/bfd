% RUNCLASSBKGRNDTHYROID Classifies Thyroid on the background 

% BFD

% VERSION 1.11 IN CVS
%


% Including Netlab, and General utilities in matlab's path
path('/home/tpena/netlab', path)
path('/home/tpena/general', path)
path('/home/tpena/mlprojects/matlab/general', path)

% Importing KERN, NDLUTIL and other toolboxes
importTool('kern')
importTool('ivm')
importTool('ndlutil')
importTool('optimi')
importTool('noise')
importTool('prior')
path('/home/tpena/mlprojects/tpenaUtil', path)
runClassThyroid