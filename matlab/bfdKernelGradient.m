function g = bfdKernelGradient(lntheta, model)

% BFDKERNELGRADIENT Gradient of likelihood wrt kernel parameters.

% BFD

%
% Syntax:
% g = bfdKernelGradient(lntheta, model);
%
% Description:
% Computes the gradient of L(\Theta) wrt \Theta. This computation
% is carried out in two parts, that is BFDKERNELGRADIENT (1) 
% computes the derivative of L(\Theta) wrt the Kernel matrix and 
% (2), computes the derivative of K wrt \Theta. Note that we 
% operate in Log-space to compute derivative (2). See Ian 
% Nabney's book on Netlab for information about this type of 
% computation.
% The derivative (1) depends on the type of kernel used, so it is
% computed separately according to the value of MODEL.KERN.TYPE.
%
% Inputs
%   lntheta   : a [t,1] vector with parameters of the kernel
%   model     : the structure that holds all the informatin for BFD
% Outputs
%   g         : a scalar with the value of the gradient
%
% Other info  : the value of g depends on the value of LNTHETA
% 
% See also: BFDCOVARIANCEGRADIENT, BFDKERNELOBJECTIVE, SCG
%

% Fetching some parameters
x = model.X;
numIn = size(x,2);
% Verifying values in LNTHETA are within a computable range
lntheta=log(thetaConstrain(exp(lntheta)));
theta = exp(lntheta);
K = zeros(size(x,1), size(x,1));
invK = zeros(size(x,1), size(x,1));

% Computing the kernel matrix according to value of the 
% vector LNTHETA 
[K, rbfPart, ...
 linearPart, dist2xx] = computeKernel(lntheta, model.kern.type, x);
g = zeros(size(lntheta));
invK = pdinv(K);

% Computing the derivative of L(\Theta) wrt to K
covGrad = bfdCovarianceGradient(invK, model.Sigma);

% Computing the derivative of K wrt LNTHETA. This computation
% depends on the type of kernel being used
switch model.kern.type
  
 case 'white'
  g(1) = g(1) + sum(sum(covGrad.*eye(size(x, 1))))*theta(1);  
 case 'bias'
  g(1) = g(1) + sum(sum(covGrad))*theta(1);
 case 'biaswhite'
  g(1) = g(1) + sum(sum(covGrad))*theta(1);
  g(2) = g(2) + sum(sum(covGrad.*eye(size(x, 1))))*theta(2); 
 case 'linbiaswhite'
  g(1) = g(1) + sum(sum(covGrad.*(x*x')))*theta(1);
  g(2) = g(2) + sum(sum(covGrad))*theta(2);
  g(3) = g(3) + sum(sum(covGrad.*eye(size(x, 1))))*theta(3);
  
 case 'linardbiaswhite'
  scales = diag(sqrt((theta(1:numIn))));
  g(1) = g(1) + sum(sum(covGrad.*linearPart));
  for it = 1:numIn
    g(it+1) =  g(it+1) + x(:, it)'*covGrad*x(:, it)*theta(1)*theta(it+1); 
  end
  g(numIn+2) = g(numIn+2) + sum(sum(covGrad))*theta(numIn+2);
  g(numIn+3) = g(numIn+3) + sum(sum(covGrad.*eye(size(x, 1))))* ...
                                                       theta(numIn+3);
 
 case 'rbfbiaswhite'
  dotProd = covGrad.*rbfPart;
  g(1) = g(1) - .5*sum(sum(dotProd.*dist2xx))*theta(1);
  g(2) = g(2) + sum(sum(dotProd/(theta(2))))*theta(2);
  g(3) = g(3) + sum(sum(covGrad))*theta(3);
  g(4) = g(4) + sum(sum(covGrad.*eye(size(x, 1))))*theta(4); 
  
 case 'rbfardbiaswhite'
  dotProd = covGrad.*rbfPart;
  g(1) = g(1) - .5*sum(sum(dotProd.*dist2xx))*theta(1);
  g(2) = g(2) + sum(sum(dotProd));
  for it = 1:numIn
    dist2xx = dist2(x(:, it), x(:, it));
    kernDer =  -.5*theta(1)*dist2xx.*rbfPart;
    g(it+2) = g(it+2) + sum(sum(covGrad.*kernDer))*theta(2+it);   
  end
  g(numIn+3) = g(numIn+3) + sum(sum(covGrad))*theta(numIn+3);
  g(numIn+4) = g(numIn+4) + sum(sum(covGrad.*eye(size(x, 1))))* ...
                                                       theta(numIn+4); 

 case 'rbflinbiaswhite'
  g(1) = g(1) - .5*sum(sum(covGrad.*rbfPart.*dist2xx))*theta(1);
  g(2) = g(2) + sum(sum(covGrad.*rbfPart/(theta(2))))*theta(2);
  g(3) = g(3) + sum(sum(covGrad))*theta(3);
  g(4) = g(4) + sum(sum(covGrad.*eye(size(x, 1))))*theta(4);
  g(5) = g(5) + sum(sum(covGrad.*(x*x')))*theta(5);
  
 case {'ard', 'rbfardlinardbiaswhite'}
  g(1) = g(1) - .5*sum(sum(covGrad.*rbfPart.*dist2xx))*theta(1);
  g(2) = g(2) + sum(sum(covGrad.*rbfPart/(theta(2))))*theta(2);
  g(3) = g(3) + sum(sum(covGrad))*theta(3);
  g(4) = g(4) + sum(sum(covGrad.*eye(size(x, 1))))*theta(4);
  scales = diag(sqrt((theta(6:(5+size(x, 2))))));
  g(5) = g(5) + sum(sum(covGrad.*(x*(scales*scales)*x')))*theta(5);
  for i = 1:size(x, 2)
    g(5+i) = g(5+i) + sum(sum(covGrad.*((theta(5))*x(:, i)*x(:, i)' ...
                                        -.5*(theta(1))*dist2(x(:, i), ...
					x(:, i)) ...
                                       .*rbfPart)))*theta(5+i);
  end

end
g = -g;

