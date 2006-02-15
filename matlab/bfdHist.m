function [class1, class0] = bfdHist(testf, ytest, fig)

% BFDHIST Generates plot with histograms of projected data

% BFD
 
% 
% Syntax:
% [class1, class0] = bfdHist(testf, ytest, fig);
%
% Description:
% This function generates a plot with two histograms of projections
% of some given vector of data, TESTF. The projections should be 
% accompanied by a vector of labels YTEST. An optional string  FIG
% can be given to indicate wether a plot should with the histograms
% should be displayed. By default each histogram will have 15
% bins.
% The function will return structures CLASS 1 and CLASS 0 with the
% parameters of the histograms, MEAN, STD, COUNTS and bin CENTRES.
% Typically BFDHIST will only be used by GENERATEHIST.
%
% Inputs
%   testF     : a [N,1] vector with data X that has been projected 
%               over the direction of discrimination.
%   ytest     : a [N,1] vector with the labels of the data.
%   fig       : a string {'figure', 'nofigure'} 
% Outputs
%   class1    : a structure with parameters of histogram associated
%               to class 1.
%   class0    : a structure with parameters of histograms
%               associated to class 0.
%
% See also: GENERATEHIST
%

% Separating projections into classes
idx0 = find(ytest == -1);
idx1 = find(ytest == 1);
testf0 = testf(idx0);
testf1 = testf(idx1);

% Computing means and standard deviations
class0.m = mean(testf0);
class1.m = mean(testf1);
class0.sd = std(testf0);
class1.sd = std(testf1);

% Obtaining bin centres and counts
nbins = 15;
[counts0, cntrs0] = hist(testf0, nbins);
[counts1, cntrs1] = hist(testf1, nbins);

% Storing in structure
class0.centres = cntrs0;
class0.counts = counts0;
class1.centres = cntrs1;
class1.counts = counts1;

% Normalising counts
ndata = length(ytest);
ncounts0 = counts0/ndata;
ncounts1 = counts1/ndata;

% Some parameters for the plot
markerSize = 10;
fontName = 'times';
fontSize = 16;
map = [1 1 1]; % bins in all black


% Some parameters of the bins
m0 = class0.m;
m1 = class1.m;

% Veryfying whether to plot or not
if nargin > 2
  if fig(1) == 'f'
    hold on;
    width = 0.8;
    h0 = bar(cntrs0, ncounts0, width); 
    h1 = bar(cntrs1, ncounts1, width); 
    child = get(gca, 'children');
    set(gca, 'fontname', fontName, 'fontSize', fontSize)
    set(get(child(2), 'children'), 'facecolor', map)
    set(get(child(1), 'children'), 'facecolor', 1-map)

    % Adjusting the plot's limits
    xlim = get(gca, 'xlim');
    xlim = xlim*1.2;
    set(gca, 'xlim', xlim);
    ylim = get(gca, 'ylim');
    ylim = ylim*1.2;
    set(gca, 'ylim', ylim);


  end
end

