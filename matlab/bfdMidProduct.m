function midterm = bfdMidProduct(model, L)

% BFDMIDPRODUCT Auxiliary function to compute variance of a test point

% BFD

% VERSION 1.11 IN CVS
%

% Computing deltaYhat
y1 = model.y;
y0 = 1 - model.y;
N1 = sum(y1,1); N0 = sum(y0,1);
deltaYhat = (1/N0)*y0-(1/N1)*y1;

% Computing matrix A and D (see reference) 
A = model.beta*model.kern.Kstore*model.L*model.kern.Kstore + model.kern.Kstore;
invA = pdinv(A);
kHat = model.kern.Kstore*deltaYhat;
Dlim = invA - invA*kHat*pdinv(kHat'*invA*kHat)*kHat'*invA;
invK = pdinv(model.kern.Kstore);
midterm = invK - Dlim;
