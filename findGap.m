function [ closestEnd ] = findGap( arr, startInd, gapSize, direction )
%FINDGAP Find a gap with size gapSize before/after startInd

%   a sequence of zeros before index startInd in an array, or
%   the gap (if any) before the first non-zero element in the array if
%   dir='before'.
%   after startInd or after the last non-zero element in array if
%   dir='after'.
%   
% Returns the right end point of the gap found, 0 if no such gap exists

closestEnd = 0;

forward = strcmp(direction, 'after');
if ~forward && ~strcmp(direction, 'before')
    error('unidentified direction');
end

function res = isG(x)
    if abs(x) <= 1
        res = 1;
    else
        res = 0;
    end
end

if ~forward
    ind = startInd;
    while ind > 0 
        if ~(isG(arr(ind)))
            ind = ind - 1;
            continue;
        else
            isGap = true;
            for i = 1: gapSize - 1
                if ind <= i % at the beggining of array: count as gap
                    break;
                end
                if ~(isG(arr(ind - i)))
                    isGap = false;
                    break;
                end
            end
            if isGap
                closestEnd = ind;
                break;
            else
                ind = ind - 1;
            end
        end
    end
else
    ind = startInd;
    while ind < length(arr)
        if ~(isG(arr(ind)))
            ind = ind + 1;
            continue;
        else
            isGap = true;
            for i = 1: gapSize - 1
                if ind + i > length(arr)  % at the beggining of array: count as gap
                    break;
                end
                if ~(isG(arr(ind + i)))
                    isGap = false;
                    break;
                end
            end
            if isGap
                closestEnd = ind;
                break;
            else
                ind = ind + 1;
            end
        end
    end
end

end