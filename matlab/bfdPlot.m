function model = bfdPlot(model, col)

% BFDPLOT Plots the discriminant function

% BFD

% 
% Syntax:
% bfdPlot(model, col);
% 
% Description
% Function used exclusively with 2D data. It plots the discriminant
% function over the space of training data. In order to do so,
% BFDPLOT creates a set of TEST points over a grid in data-space
% and projects them over the direction of discrimination. A string
% value COL is an optional parameter that specifies the colour to
% use to plot the line of discrimination.
%
% Inputs
%   model     : the data structure that stores the BFD information
%   col(*)    : string to specify the colour to plot discriminant
% Outputs
%   model     : the same data structure (without changes)
%
% See also: DEMTOY, BFDSAVEDATA
%

% Setting font type, size and other parameters for plotting
markerSize = 10;
fontName = 'times';
fontSize = 16;
figure(1);  
 
% Splitting training data according to label value
x0 = model.X(find(model.y==0),:);
x1 = model.X(find(model.y==1),:);

% Plotting training data and representing it with symbols according
% to their labels
hold on;
a = plot(x1(:,1), x1(:,2), 'r+');
set(a, 'markersize', markerSize, 'lineWidth', 2);
a = plot(x0(:,1), x0(:,2), 'go');
set(a, 'markersize', markerSize, 'lineWidth', 2);
set(gca, 'fontname', fontName, 'fontSize', fontSize)

% Adjusting the plot's limits
xlim = get(gca, 'xlim');
xlim = xlim*1.2;
set(gca, 'xlim', xlim);
ylim = get(gca, 'ylim');
ylim = ylim*1.2;
set(gca, 'ylim', ylim);

% Generating test data
xnum = 1;
ynum = 1;
x_test_num = 150;
y_test_num = 150;
range = 10;
test_num = x_test_num*y_test_num;
x_range = linspace(xlim(1), xlim(2), x_test_num);
y_range = linspace(ylim(1), ylim(2), y_test_num);
[xs, ys] = meshgrid(x_range, y_range);
xtest(:, 1) = xs(:);
xtest(:, 2) = ys(:);

% Projecting test data over direction of discrimination.
% This is equivalent to don f = \alpha^{T}*k_{test}
optMean = computeKernel(model.kern.lntheta, model.kern.type, xtest, ...
                        model.X)*model.alpha;


% Plotting the mean of projected test points using the stored
% hyperparameters 
if nargin < 2 % Checking if colour is specified
  col = 'b';
end
optMean = reshape(optMean(:,1), y_test_num, x_test_num);
[void, a] = contour(x_range, y_range, optMean, [model.bias model.bias], col); 
set(a, 'linewidth', 1.5, 'linestyle', '-');
% $$$ 
% $$$ Uncomment these lines if the contours at (1/4)th 
% of the mean are required.
% $$$ See the paper for further reference.
% $$$ 
[void, a] = contour(x_range, y_range, optMean, ... 
                    [model.bias+0.25 model.bias+0.25], col); 
set(a, 'linewidth', 1, 'linestyle', ':');
[void, a] = contour(x_range, y_range, optMean, ...
                    [model.bias-0.25 model.bias-0.25], col); 
set(a, 'linewidth', 1, 'linestyle', ':');
drawnow
	
