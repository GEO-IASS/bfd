function model = bfdComputeL(model)

y1 = model.y; 
y0 = 1-model.y;
N1 = sum(y1,1); N0 = sum(y0,1); 
N = N1 + N0;
model.L = eye(N,N) - (1/N1)*y1*y1' - (1/N0)*y0*y0';