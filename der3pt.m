function [ der ] = der3pt( x, y, loc )
%DER3PT 3-point formula for calculating derivative
%   Derivative of Lagrange polynomial through 3 points
%
% x: [1-by-3] column or row vector of sample locations
% y: [1-by-3] column or row vector of sample values
% loc: 'le' denotes left-end, 're' denotes right-end

if nargin < 3
    p = x(2);
elseif loc == 'le'
    p = x(1);
elseif loc == 're'
    p = x(3);
else
    err('ERROR: unrecognized loc option');
end

der = y(1) * (2 * p - x(2) - x(3)) / (x(1) - x(2)) / (x(1) - x(3)) +  ...
    y(2) * (2 * p - x(1) - x(3)) / (x(2) - x(1)) / (x(2) - x(3)) + ...
    y(3) * (2 * p - x(1) - x(2)) / (x(3) - x(1)) / (x(3) - x(2));

end

