function model = bfdUpdateSigma(model)

% BFDUPDATESIGMA Update the posterior for BFD

% BFD

% VERSION 1.11 IN CVS
%

model.Sigma = pdinv(pdinv(model.kern.Kstore) ...
                   + model.beta*model.L);