function [ noiseIntervals ] = roughNoise( emg, inds )
%ROUGHNOISE Roughly identify the noise region used to build noise model
%   
%   Return: 
%   noiseRegions: [n-by-2] matrix. Each row represents a noise interval
%   using the indices of the interval end points
%
%   Reference: 
%   A randomisation method for discriminating between signal and noise in recordings 
%   of rhythmic electromyographic activity
%   A.J. Thexton
%

% TODO: multiscale
hwSize = 11;
emg = integrateEMG(emg, hwSize);

figure
plot(inds(hwSize + (1: length(emg))), emg);

lb = 1;
ub = 25;
% k: number of moving horizontal lines tried
k = ub - lb;
step = 0.1; 
numIntersect = zeros(k / step + 1, 1);
count = 0;
for i = 1: step: k
    count = count + 1;
    numIntersect(count) = sum(emg > (i - 1) & emg < i);
end
diffNum = diff(numIntersect);

figure
hold on
plot(1: step: ub, numIntersect, 'b');
plot((1: step: ub - step) + step / 2, diffNum / step, 'm');
legend('number of intersections', 'derivative');
hold off

[~, ind] = min(diffNum);
tolerance = 0.3;
threshold = ind * step + 1 - step/2 + tolerance;
fprintf('Threshold set at: %d\n', threshold);

%% use threshold to find noise regions

isNoise = emg < threshold;
if ~isrow(isNoise)
    isNoise = isNoise';
end
% a noise region has to be of length at least minDuration
minDuration = 500;

diffNoise = diff([0, isNoise, 0]);
startIndex = find(diffNoise > 0);
endIndex = find(diffNoise < 0) - 1;
duration = endIndex-startIndex+1;

rmIntervals = duration < minDuration;
startIndex(rmIntervals) = [];
endIndex(rmIntervals) = [];

noiseIntervals = [startIndex', endIndex'];

end

