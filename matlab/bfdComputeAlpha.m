function model = bfdComputeAlpha(model)

% BFDCOMPUTEALPHA Computes the 'eigenvectors' of the model

% BFD

% VERSION 1.11 IN CVS
%

% Computing projected means and alpha coeffs.
m1 = model.kern.Kstore*model.y/sum(model.y);
m0 = model.kern.Kstore*(1-model.y)/sum(1-model.y);
alpha = pdinv(model.kern.Kstore*1/model.beta ...
              + model.kern.Kstore*model.L*model.kern.Kstore)*(m0-m1);
model.alpha = model.d*alpha/(alpha'*(m0-m1));