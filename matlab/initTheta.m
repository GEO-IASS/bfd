function lntheta = initTheta(kernel, numIn)

% INITTHETA Initialise the kernel parameters.

% BFD

% Syntax:
% lntheta = initTheta(kernel, numIn);
%
% Description:
% Initialises the log values of the hyperparameters \Theta of the
% kernel function. The dimensions of the returned vector LNTHETA
% vary according to the type of KERNEL used and the dimensionality
% of the data, NUMIN. This function is used almost exclusively by
% BFD at the time of initialising a BFD model.
%
% Inputs
%   kernel    : string with the name of the kernel used
%   numIn     : scalar specifying the dimensions of the data X
% Outputs 
%   lntheta   : a [t,1] vector with the values of the hyper
%               -parameters in log-space
%
%
% See also: BFD
%
%
% NOTE: This function is a modification of code written by Neil
%       D. Lawrence, under his explicit permission.
%

% Verifying kernel type and initialising vector of parameters. 
switch kernel
  
 case 'white'
  lntheta = 1;
  
 case 'bias'
  lntheta = 1;
 
 case 'biaswhite'
  lntheta = [ones(1,2)];
 
 case 'linbiaswhite'
  lntheta = [ones(1, 3)];
  
 case 'linardbiaswhite'
  lntheta = [1, ones(1,numIn), ones(1, 2)]; % last terms are
                                               % bias & noise
 case 'rbfbiaswhite'
  lntheta = [ones(1, 4)];
  
 case 'rbfardbiaswhite'
  lntheta = [ones(1,2), ones(1,numIn), ones(1,2)]; % last terms
                                                    % are bias & noise
  
 case 'rbflinbiaswhite'
  lntheta = [ones(1, 5)];
  
 case {'ard', 'rbfardlinardbiaswhite'}
  lntheta = [ones(1,5), ones(1,numIn)]; % last terms
                                                    % are linVariance 
                                                    % bias & noise
  
 otherwise
  fprintf('initTheta: kernel not implemented\n');
  
end
