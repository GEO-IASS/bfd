function model = bfdUpdateSigma(model)

% BFDUPDATESIGMA Update the posterior for Fisher's discriminant.

model.Sigma = pdinv(pdinv(model.kern.Kstore) ...
                   + model.beta*model.L);