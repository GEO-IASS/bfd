function model = bfdUpdateBeta(model)

% UPDATEBETA Update the value for beta.

K = kernCompute(model.kern, model.X, model.X);
f = K*model.alpha;
    
midterm = bfdMidProduct(model,model.L);
likevar = diag(K'*midterm*K);
sigma_star =  diag(model.kern.Kstore) - likevar; 

c0 = mean(f(find(model.y==0)));
c1 = mean(f(find(model.y==1)));

% Setting beta 
f0 = f(find(model.y==0));
v0 = f0.*f0   - 2*c0*f0 + c0*c0 + sigma_star(find(model.y==0));
sigbar0 = sum(v0);

f1 = f(find(model.y==1));
v1 = f1.*f1  - 2*c1*f1 + c1*c1 + sigma_star(find(model.y)); 
sigbar1 = sum(v1);

a = model.gamma.a;
b = model.gamma.b;
model.beta = length(model.y + 2*a - 2)/(sigbar1 + sigbar0 + 2*b);


