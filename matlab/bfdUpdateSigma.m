function model = bfdUpdateSigma(model)

% BFDUPDATESIGMA Update the posterior for BFD

% BFD

model.Sigma = pdinv(pdinv(model.kern.Kstore) ...
                   + model.beta*model.L);