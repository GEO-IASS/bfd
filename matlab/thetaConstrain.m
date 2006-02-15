function theta = thetaConstrain(theta)

% THETACONSTRAIN Prevents kernel parameters from getting too big or small.

% BFD

% 
% Syntax:
% theta = thetaConstrain(theta);
% 
% Description:
% This function has been taken from Neil D. Lawrence's toolbox of
% utilities. It verifies that the vector of hyperparameters THETA
% lies within an appropriate range for computation. It is 
% typically applied by an Optimisation routine as in some cases
% the values of the parameters used might drop or increase to
% ranges unsuitable for computation.
% Contrary to other optimisation-related functions in this toolbox,
% he values used in this function ARE NOT in log-space!
%
% Inputs
%   theta     : a [t,1] vector with the values of the hyperparmeters
% Outputs
%   theta     : the vector with (possibly) some values changed to
%               some manageable range.
%
% See also: BFDKERNELGRADIENT, BFDKERNELOBJECTIVE, COMPUTEKERNEL
%
%
% NOTE: This function is a modification of code written by Neil
%       D. Lawrence, under his explicit permission.
%

% Stop and ask user what to do in case NaN's are found 
if any(isnan(theta))
  fprintf('Theta is not a number. Check\n');
  keyboard;
end

% Set MAX and MIN range for the values of the hyperparameters
minTheta = 1e-6;
maxTheta = 1/minTheta;

% Substitute values that are outside the range [MINTHETA, MAXTHETA]
if any(theta < minTheta)
  theta(find(theta<minTheta)) = minTheta;
end
if any(theta>maxTheta)
  theta(find(theta>maxTheta)) = maxTheta;
end
