function model = qbfdUpdateBeta(model)

% QBFDUPDATEBETA Update precisions, i.e. beta0 & beta1

% QBFD

% Project training data
K = kernCompute(model.kern, model.X, model.X);
f = K*model.alpha;

% Computing variance around projections
midterm = qbfdMidProduct(model,model.L);
likevar = diag(K'*midterm*K);
sigma_star =  diag(model.kern.Kstore) - likevar; 

% Centres of projections
c0 = mean(f(find(model.y==0)));
c1 = mean(f(find(model.y==1)));

% Computing averages of projected means
f0 = f(find(model.y==0));
v0 = f0.*f0   - 2*c0*f0 + c0*c0 + sigma_star(find(model.y==0));
sigbar0 = sum(v0);

f1 = f(find(model.y==1));
v1 = f1.*f1  - 2*c1*f1 + c1*c1 + sigma_star(find(model.y)); 
sigbar1 = sum(v1);

% Updating beta0
a0 = model.gamma.a0;
b0 = model.gamma.b0;
N0 = sum(1-model.y);
model.beta0 = (0.5*N0 + a0 - 1)/(0.5*sigbar0 + b0);

% Updating beta1
a1 = model.gamma.a1;
b1 = model.gamma.b1;
N1 = sum(model.y);
model.beta1 = (0.5*N1 + a1 - 1)/(0.5*sigbar1 + b1);


