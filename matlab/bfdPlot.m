function bfdPlot(model, titleStrng, kernelType, dataset, axHandle)

% BFDPLOT Plot the results of the discriminant.
%
% bfdplot(model, axHandle)

% Copyright (c) 2004 Tonatiuh Pena Centeno and Neil D. Lawrence
% File version 
% BFD toolbox version 0.1


markerSize = 10;
fontName = 'times';
fontSize = 16;
if nargin < 5
    figure(1); clf
else
    axes(axHandle)
end 
x0 = model.X(find(model.y==0),:);
x1 = model.X(find(model.y==1),:);

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generating test data
xnum = 1;
ynum = 1;
x_test_num = 100;
y_test_num = 100;
range = 10;
test_num = x_test_num*y_test_num;
x_range = linspace(xlim(1), xlim(2), x_test_num);
y_range = linspace(ylim(1), ylim(2), y_test_num);

[xs, ys] = meshgrid(x_range, y_range);
xtest(:, 1) = xs(:);
xtest(:, 2) = ys(:);

% plotting data and features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
optMean = kernCompute(model.kern, xtest, model.X)*model.alpha;


% Plotting the mean of projected test points using the optimised
% hyperparameters
optMean = reshape(optMean(:,1), y_test_num, x_test_num);
[void, a] = contour(x_range, y_range, optMean, [model.bias model.bias], 'b'); 
[void, a] = contour(x_range, y_range, optMean, [model.bias+0.25 model.bias+0.25], 'b'); 
set(a, 'linewidth', 2, 'linestyle', ':');
[void, a] = contour(x_range, y_range, optMean, [model.bias-0.25 model.bias-0.25], 'b'); 
set(a, 'linewidth', 2, 'linestyle', ':');
drawnow
hold off;		

% $$$ % Setting title
% $$$ if nargin > 1
% $$$   title(titleStrng);
% $$$ end

% Saving the plot
if nargin > 3
  if isequal(version, '6.1.0.450 (R12.1)')
    results_path = '/home/tpena/mlprojects/bfd/matlab/toyResults';
    orig_path = '/home/tpena/mlprojects/bfd/matlab/';
  else
    results_path = 'c:\mlprojects\bfd\matlab\toyResults';
    orig_path = 'c:\mlprojects\bfd\matlab';
  end
  cd(results_path);
  print('-depsc', [kernelType{:}, '_', dataset ,'.eps']);
  cd(orig_path); pause(1); close; % close figure
end
