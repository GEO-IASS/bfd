function model = qbfdComputeLg(model)

% QBFDCOMPUTELG Computes matrix that clusters targets

% QBFD

% Defining label vectors Y1, Y0
y1 = model.y; 
y0 = 1-model.y;
N1 = sum(y1,1); N0 = sum(y0,1); 
N = N1+N0;
beta1 = model.beta1;
beta0 = model.beta0;

% Computing matrix L from outer products
model.Lg = beta1*diag(y1) + beta0*diag(y0) ...
          - (beta1/N1)*y1*y1' - (beta0/N0)*y0*y0';