function model = bfdUpdateBeta(model)

% BFDUPDATEBETA Update the value for beta.

% BFD

% 
% Syntax:
% model = bfdUpdateBeta(model);
%
% Description:
% This function is used to compute a new value of the parameter
% \Beta according to the update equation specified in [1], see
% README file.
% 
% Inputs
%   model     : data structure with information to train a BFD alg.
% Outputs
%   model     : the same data structure but with the updated field
%               BETA
% 
% See also: README file, BFD 
%

% Projecting training data over direction of discrimination
K = computeKernel(model.kern.lntheta, model.kern.type, model.X, model.X);
f = K*model.alpha;
    
% Computing the variance of the training points
matVar = bfdMatVar(model);
likevar = diag(K'*matVar*K);
sigma_star =  diag(model.kern.K) - likevar; 

% Computing the max. likelihood estimates of the class centres
c0 = mean(f(find(model.y==0)));
c1 = mean(f(find(model.y==1)));

% Computing sample variances for each class
f0 = f(find(model.y==0));
v0 = f0.*f0   - 2*c0*f0 + c0*c0 + sigma_star(find(model.y==0));
sigbar0 = sum(v0);
f1 = f(find(model.y==1));
v1 = f1.*f1  - 2*c1*f1 + c1*c1 + sigma_star(find(model.y)); 
sigbar1 = sum(v1);

% Fetching information from the prior over \Beta
a = model.gamma.a;
b = model.gamma.b;
N = length(model.y);

% Setting the new value for \Beta
model.beta = (N + 2*a - 2)/(sigbar1 + sigbar0 + 2*b);


