function [kx, rbfPart, linearPart, n2] = computeKernel(lntheta, type, x, x2)

% COMPUTEKERNEL Compute kernel given parameters LNTHETA and data X  

% BFD

%
% Syntax: 
% [kx, rbfPart, linearPart, n2] = computeKernel(lntheta, ...
%                                               type, x, x2);
%
% Description:
% This function is based on Neil D. Lawrence's utilities toolbox 
% code. It computes the kernel matrix according to the data X,
% optionally X2, and the vector of parameters LNTHETA. 
% The kernel matrix will vary according to the specified TYPE.
% 
% The function by default computes a kernel composed of the
% following parts (see BFD paper for more details)
% 
% 1. RBF part
% 2. LINEAR part
% 3. BIAS part
% 4. NOISE part
%
% If the specified kernel TYPE does not include some of the four
% parts mentioned, then the function returns that part as an EMPTY
% value.
%
% Inputs
%   lntheta   : a [t,1] vector with kernel parameters (in
%                                                      log-space)
%   type      : string that specifies the kernel to be used,
%               eg. RBF, RBFARDLINARDBIASWHITE.
%   X         : data to compute the kernel K(ij) = K(X,X)
%   X2        : additional data input to compute K(ij) = K(X,X2)
% Outputs
%   kx        : the kernel matrix given by 
%                   RBF + LINEAR + BIAS + NOISE
%   rbfpart   : the kernel matrix computed with RBF functions
%   linearPart: the kernel matrix computed with linear dot prods
%   n2        : diagonal matrix with the noise part of the total K
%
% Other info  : If only X is given as data, then the kernel K is 
%               computed with a diagonal term added. This extra 
%               term represents the correlation of the input 
%               x_{i}.
%
% See also: URL http://www.dcs.shef.ac.uk/~neil/kern/ which
%           contains a newer version of Neil D. Lawrence's
%           utilities toolbox. It is not necessary to download the
%           toolbox but it helps to read its documentation.
%
%
% NOTE: This function is a modification of code written by Neil
%       D. Lawrence. This code is distributed under his explicit
%       permission. 
%

% Fetching parameters and verifying they're within a proper range
% of values
lntheta=log(thetaConstrain(exp(lntheta)));
theta = exp(lntheta);
numIn = size(x,2);
    

% Computing K according to specified TYPE. If X2 is given as extra
% argument, then the diagonal matrix representing the noise model
% is omitted.
if nargin < 4
  % We do K(X,X) here
  switch type
   
   case 'white'
    rbfPart = [];
    n2 = [];
    linearPart = [];
    kx = theta(1)*eye(size(x,1));
    
   case 'bias'
    rbfPart = [];
    n2 = [];
    linearPart = [];
    kx = theta(1);
    
   case 'biaswhite'
    rbfPart = [];
    n2 = [];
    linearPart = [];
    kx = theta(1) + theta(2)*eye(size(x,1));
    
   case 'linbiaswhite'
    rbfPart = [];
    n2 = [];
    linearPart = x*x'*theta(1);
    kx = linearPart + theta(3)*eye(size(x, 1)) + theta(2);
  
   case 'linardbiaswhite'
    rbfPart = [];
    n2 = [];
    scales = diag(sqrt(theta(2:numIn+1)));
    x = x*scales;
    linearPart = theta(1)*x*x';
    kx = linearPart  + theta(numIn+2) + theta(numIn+3)*eye(size(x, 1));

   case 'rbfbiaswhite'
    n2 = dist2(x, x);
    wi2 = (.5 .* theta(1));
    rbfPart = theta(2)*exp(-n2*wi2);
    kx = rbfPart  + theta(3) + theta(4)*eye(size(x, 1));
    linearPart = [];
    
   case 'rbfardbiaswhite'
    scales = diag(sqrt(theta(3:numIn+2)));
    x = x*scales;
    n2 = dist2(x, x);
    wi2 = (.5 .* theta(1));
    rbfPart = theta(2)*exp(-n2*wi2);
    linearPart = [];
    kx = rbfPart + theta(numIn+3) + theta(numIn+4)*eye(size(x, 1));
    
   case 'rbflinbiaswhite'
    n2 = dist2(x, x);
    wi2 = (.5 .* theta(1));
    rbfPart = theta(2)*exp(-n2*wi2);
    linearPart = x*x'*theta(5);
    kx = rbfPart + theta(3)+ theta(4)*eye(size(x, 1)) + linearPart;
    
   case {'rbfardlinardbiaswhite'}
    scales = diag(sqrt(theta(6:(5+size(x, 2)))));
    x = x*scales;
    n2 = dist2(x, x);
    wi2 = (.5 .* theta(1));
    rbfPart = theta(2)*exp(-n2*wi2);
    linearPart = x*x'*theta(5);
    kx = rbfPart + theta(3) + theta(4)*eye(size(x, 1)) + linearPart;
  end
  
else
  % We compute K(X,X2) in this section
  switch type 
   
   case 'white'
    rbfPart = [];
    linearPart = [];
    n2 = [];
    kx = zeros(size(x,1), size(x2,1));
   
   case 'bias'
    rbfPart = [];
    linearPart = [];
    n2 = [];
    kx = theta(1);
    
   case 'biaswhite'
    rbfPart = [];
    linearPart = [];
    n2 = [];
    kx = theta(1) + zeros(size(x,1), size(x2,1)); %biasVariance
     
   case 'linbiaswhite'
    rbfPart = [];
    n2 = [];
    linearPart = x*x2'*theta(1);
    kx = linearPart + theta(2);
   
   case 'linardbiaswhite'
    rbfPart = [];
    n2 = [];
    numIn = size(x,2);
    scales = diag(sqrt(theta(2:numIn+1)));
    x = x*scales;
    x2 = x2*scales;
    linearPart = theta(1)*x*x2';
    kx = linearPart  + theta(numIn+2);
    
   case 'rbfbiaswhite'
    n2 = dist2(x, x2);
    wi2 = (.5 .* theta(1));
    rbfPart = theta(2)*exp(-n2*wi2);
    linearPart = [];
    kx = rbfPart + theta(3);

   case 'rbfardbiaswhite'
    scales = diag(sqrt(theta(3:numIn+2)));
    x = x*scales;
    x2 = x2*scales;
    n2 = dist2(x, x2);
    wi2 = (.5 .* theta(1));
    rbfPart = theta(2)*exp(-n2*wi2);
    linearPart = [];
    kx = rbfPart + theta(numIn+3);
    
   case 'rbflinbiaswhite'
    n2 = dist2(x, x2);
    wi2 = (.5 .* theta(1));
    rbfPart = theta(2)*exp(-n2*wi2);
    linearPart = x*x2'*theta(5);
    kx = rbfPart + theta(4) + linearPart;
    
   case {'rbfardlinardbiaswhite'}
    scales = diag(sqrt(theta(6:(5+size(x, 2)))));
    x = x*scales;
    x2 = x2*scales;
    n2 = dist2(x, x2);
    wi2 = (.5 .* theta(1));
    rbfPart = theta(2)*exp(-n2*wi2);
    linearPart = x*x2'*theta(5);
    kx = rbfPart + theta(4) + linearPart;
    
  end
end




