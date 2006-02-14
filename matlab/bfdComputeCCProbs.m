function [p1, p0] = bfdComputeCCProbs(model, trainF, trainY, testF)

% QBFDCOMPUTECCPROBS Computes Class Conditional Probs for BFD

% QBFD

% VERSION 1.11 IN CVS
%

% Note: This function assumes binary labelled data with 
% the format y \in {0,1}
 
% Computing the means and STD for each class
m0 = mean(trainF(trainY == 0));
sd0 = std(trainF(trainY == 0));

m1 = mean(trainF(trainY == 1));
sd1 = std(trainF(trainY == 1));

% Taking out the prior probabilities
N = length(trainY);
prior0 = sum(trainY==0)/N;
prior1 = sum(trainY==1)/N;

% Class conditional probabilities
m0 = repmat(m0, length(testF),1);
logLike0 = -0.5*log(2*pi) - log(sd0) ...
            -0.5*((testF - m0).^2)./sd0^2;
logJ0 = logLike0 + log(prior0);

m1 = repmat(m1, length(testF),1);
logLike1 = -0.5*log(2*pi) - log(sd1) ...
            -0.5*((testF - m1).^2)./sd1^2;
logJ1 = logLike1 + log(prior1);

norm = exp(logJ0) + exp(logJ1);
if all(norm > 0)
  p0 = exp(logJ0 - log(norm));
  p1 = exp(logJ1 - log(norm));
else
  warning(['ComputeCCProbs: Z is zero. Rescaling probabilities']);
  const = max([logJ0; logJ1]);
  J0s = exp(logJ0/const);
  J1s = exp(logJ1/const);
  classRatio = [J1s./J0s].^const;
  p0 = 1./(1+classRatio);
  p1 = 1-p0;
end
