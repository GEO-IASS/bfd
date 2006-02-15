function [model, K] = bfd(X, Y, modSpecs, params, beta)
 
% BFDCREATEMODEL Creates a model with specified parameters

% BFD

%
% Syntax:
% [model, K] = bfd(X, Y, modSpecs, params, beta);
%
% Description:
% This function takes some Data D=(X,Y), some Model-Specifications,
% (MODSPECS), a vector of Parameters (PARAMS) and a Coefficient 
% (BETA) and initialises a MODEL structure that represents a BFD.
% The model contains all the relevant information for being trained
% with the BFD algorithm.
% 
% Inputs
%   X         : an [N,d] matrix with the measurements or variates
%   Y         : an [N,1] vector of labels in {1,0} format
%   modSpecs  : a structure with the fields: {kernelType, gamma, ...
%                                             dist, beta}
%   params(*) : a [t,1] vector of kernel parameters \Theta.
%   beta(*)   : a scalar that is the precision of the noise model
% Outputs
%   model     : data structure with information to train a BFD alg.
%   K         : the kernel matrix computed with the data X,
%               according to the KERNELTYPE.
% 
% ModSpecs structure:
%   kernel    : cell array of strings specifying the type of 
%               kernel used. See README file.
%   gamma     : a structure ifself with the fields {a,b} which
%               represent the SHAPE and INV-SCALE of the prior. 
%               See README.txt
%   dist      : the value of the distance constraint, typically '2'  
%   
% Other info  : N - number of training points
%             : d - data dimensionality
%             : t - number of kernel parameters
%             : (*) are optional parameters
%
% See also: README file
% 

% Verifying number of input arguments is correct
if nargin < 3
  error('BFD: wrong number of parameters');
end

% Setting mandatory fields
model.X = X;
model.y = Y;
[N, d] = size(X);
model.N = N;
model.d = d;
model.dist = modSpecs.dist;
model.kern.type = modSpecs.kernelType;

% Computing matrix L
model = bfdComputeL(model);

% Setting LNTHETA and GAMMA according to provided values
numIn = model.d;
if nargin == 3
  % Using default values
  model.gamma.a = 0.5;
  model.gamma.b = 0.5;
  model.beta = 1;
  model.kern.lntheta = initTheta(modSpecs.kernelType, numIn);
elseif nargin == 5
  % Using provided values
  model.gamma = modSpecs.gamma;
  model.beta = beta;
  model.kern.type = modSpecs.kernelType;
  model.kern.lntheta = params;
end

% Computing kernel, this depends on LNTHETA
model.kern.K = computeKernel(model.kern.lntheta, model.kern.type, ...
                             model.X);

% Givin K as separate output
if nargout == 2
  K = computeKernel(model.kern.lntheta, model.kern.type,...
                    model.X, model.X);
end


% Computing vectors ALPHA
model = bfdComputeAlpha(model);

% Updating posterior covariance SIGMA, this depends on 
% K and on BETA.
model = bfdUpdateSigma(model);
