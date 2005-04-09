function model = qbfdComputeAlpha(model)

% QBFDCOMPUTEALPHA Computes the 'eigenvectors' of the model

% QBFD

% Computing projected means and alpha coeffs.
m1 = model.kern.Kstore*model.y/sum(model.y);
m0 = model.kern.Kstore*(1-model.y)/sum(1-model.y);
A = model.kern.Kstore + model.kern.Kstore*model.Lg*model.kern.Kstore;
alpha = pdinv(A)*(m0-m1);
model.alpha = model.d*alpha/(alpha'*(m0-m1));