function params = bfdParamInit(kernelType, numIn, x)

% BFDPARAMINIT Initialises kernel parameters

% BFD

  
% Sets the parameter(1) = 1
if nargin < 3
  x = 1;
end

% Initialise parameters according to kernel type
switch strcat(kernelType{:})
 case 'white'
  params(1) =  negLogLogitTransform(exp(log(x)), 'xtoa'); % white
 case 'biaswhite'
  params(1) =  negLogLogitTransform(exp(log(x)), 'xtoa'); % bias
  params(2) =  negLogLogitTransform(exp(1), 'xtoa'); % white
 case 'linbiaswhite'
  params(1) = negLogLogitTransform(exp(log(x)), 'xtoa'); % linVariance
  params(2) = negLogLogitTransform(exp(1), 'xtoa'); % bias
  params(3) = negLogLogitTransform(exp(1), 'xtoa'); % white
 case 'rbfbiaswhite'
  params(1) = negLogLogitTransform(exp(log(x)), 'xtoa'); % rbfInvWidth
  params(2) = negLogLogitTransform(exp(1), 'xtoa'); % rbfVariance
  params(3) = negLogLogitTransform(exp(1), 'xtoa'); % bias
  params(4) = negLogLogitTransform(exp(1), 'xtoa'); % white
 case {'rbfardlinardbiaswhite'} 
  params(1) = negLogLogitTransform(exp(log(x)), 'xtoa'); % rbfInvWidth
  params(2) = negLogLogitTransform(exp(1), 'xtoa'); % rbfVariance
  params(3:numIn+2) = negLogLogitTransform(exp(1), 'xtoa'); % InputScales
  params(numIn+3) = negLogLogitTransform(exp(1), 'xtoa'); % linVariance
  params(numIn+4) = negLogLogitTransform(exp(1), 'xtoa'); % bias 
  params(numIn+5) = negLogLogitTransform(exp(1), 'xtoa'); % white
  
end
