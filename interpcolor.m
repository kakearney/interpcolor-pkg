function col = interpcolor(x, cmap, lims, nancol)
%INTERPCOLOR Colormap interpolation
%
% col = interpcolor(x, cmap, lims)
%
% Assigns a color to each point in x based on a colormap, as though in a
% scatter plot.
%
% Input variables:
%
%   x:      numeric array
%
%   cmap:   n x 3 colormap
%
%   lims:   1 x 2 array of color limits.  If not included, limits will be
%           set to the minimum and maximum value of x.
%
%   nancol: 1 x 3 color vector to be used for NaN, Inf, and -Inf values.
%           If not included, will use first color in colormap. 

% Copyright 2010 Kelly Kearney

if nargin < 3 || isempty(lims)
    lims = [min(x(:)) max(x(:))];
end

if nargin < 4 || isempty(nancol)
    nancol = cmap(1,:);
end

if any(cmap(:) > 1 | cmap(:) < 0)
    error('cmap values must be between 0 and 1');
end

ncol = size(cmap,1);

step = linspace(lims(1), lims(2), ncol);

col = interp1(step, cmap, x(:));
ishi = x(:) > lims(2);
islo = x(:) < lims(1);
col(ishi,:) = repmat(cmap(end,:), sum(ishi), 1);
col(islo,:) = repmat(cmap(1,:), sum(islo), 1);

neednan = all(isnan(col), 2);
col(neednan,:) = repmat(nancol, sum(neednan), 1);

isneg = col < 0;
col(isneg) = 0; % TODO floating point?


if ~isvector(x)
    col = num2cell(col, 2);
    col = reshape(col, size(x));
end