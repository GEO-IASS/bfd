function [predY, probY] = bfdMakePredictions(model, trainF, ...
                                             trainY, testF)

% BFDMAKEPREDICTIONS Assigns labels to test data 

% BFD

% VERSION 1.11 IN CVS
%

% Computing Class conditional probs
[p1, p0] = bfdComputeCCProbs(model, trainF, trainY, testF);

% Assigning predicted labels according to class cond. probs
predY = p1 >= p0;
probY = [p1, p0];

