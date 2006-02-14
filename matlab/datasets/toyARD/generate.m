function [data, labels] = generate_data()
% path(path,'home/tpena/MyDocuments/Documents/PhD/2003/Software/netlab');
% path(path,'/home/tpena/MyDocuments/Documents/PhD/2004/Data sets/Simple ARD');
% This program will create a binary data set to perform a simple 
% ARD checking with the Bayesian Fisher Discriminant

N = 100;

x1 = gsamp([0 0.7], [0.1 0; 0 0.01], N);
x2 = gsamp([0 0], [0.1 0; 0 0.01], N);
x3 = gsamp([0 -0.7], [0.1 0; 0 0.01], N);

lab1 = ones(N,1);
lab2 = -ones(N,1);
lab3 = ones(N,1);

x = [x1; x2; x3];
lab = [lab1; lab2; lab3];

% Standardising the data
xstd = (x - repmat(mean(x), 3*N,1)) / std(x) ;

% Plotting it, just in case
plot(x1(:,1), x1(:,2), 'r+', x2(:,1), x2(:,2), 'bo', x3(:,1), x3(:,2), 'r+');

simple_ard_data = x;
simple_ard_labels = lab;

save simple_ard_data.asc simple_ard_data -ASCII
save simple_ard_labels.asc simple_ard_labels -ASCII 
