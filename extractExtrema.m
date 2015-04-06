function [ r, inds ] = extractExtrema( s )
%EXTRACTEXTREMA extract local maximums and minimums
%   inds: indices where extrema are located

r = zeros(size(s));
inds = zeros(size(s));
r(1) = s(1);
inds(1) = 1;
count = 1;
for j = 2: length(s) - 1
    if (s(j) - s(j - 1)) * (s(j+1) - s(j)) < 0  % local max/min
        count = count + 1;
        r(count) = s(j);
        inds(count) = j;
    end
end
r(count + 1) = s(end);
inds(count + 1) = length(s);
r = r(1: count + 1);
inds = inds(1: count + 1);

end

