function [ rightEnd ] = findGap( arr, startInd, gapSize )
%FINDGAP Find a gap with size gapSize (a sequence of zeros before index 
%   startInd in an array, or
%   the gap (if any) before the first non-zero element in the array
%   
% Returns the right end point of the gap found, 0 if no such gap exists

rightEnd = 0;

ind = startInd;
while ind > 0
    if arr(ind) ~= 0
        ind = ind - 1;
        continue;
    else
        isGap = true;
        for i = 1: gapSize - 1
            if ind <= i % at the beggining of array: count as gap
                break;
            end
            if arr(ind - i) ~= 0
                isGap = false;
                break;
            end
        end
        if isGap
            rightEnd = ind;
            break;
        else
            ind = ind - 1;
        end
    end
end

