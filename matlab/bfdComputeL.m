function model = bfdComputeL(model)

% BFDCOMPUTEL Computes matrix that clusters targets

% BFD

% Defining label vectors Y1, Y0
y1 = model.y; 
y0 = 1-model.y;
N1 = sum(y1,1); N0 = sum(y0,1); 
N = N1 + N0;
% Computing matrix L from outer products
model.L = eye(N,N) - (1/N1)*y1*y1' - (1/N0)*y0*y0';