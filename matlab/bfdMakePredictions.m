function [predY, probY] = bfdMakePredictions(model, trainF, ...
                                             trainY, testF)


% Computing Class conditional probs
[p1, p0] = bfdComputeCCProbs(model, trainF, trainY, testF);
predY = p1 >= p0;
probY = [p1, p0];

