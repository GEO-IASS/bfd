function [predY, probY] = qbfdMakePredictions(model, trainF, ...
                                             trainY, testF)

% BFDMAKEPREDICTIONS Assigns labels to test data 

% BFD

% Computing Class conditional probs
[p1, p0] = qbfdComputeCCProbs(model, trainF, trainY, testF);

% Assigning predicted labels according to class cond. probs
predY = p1 >= p0;
probY = [p1, p0];

