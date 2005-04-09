function model = qbfdUpdateSigma(model)

% QBFDUPDATESIGMA Update the posterior for BFD

% QBFD

model.Sigma = pdinv(pdinv(model.kern.Kstore) + model.Lg);