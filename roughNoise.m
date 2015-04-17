function [ noiseRegions ] = roughNoise( emg )
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
k = 25;
step = 0.1; 
numIntersect = zeros((k-1) / step + 1);
count = 0;
for i = 1: step: k
    count = count + 1;
    numIntersect(count) = sum(emg > (i - 1) & emg < i);
end
figure

hold on
plot(1: step: k, numIntersect);
plot(1: step: (k-step) + step / 2, diff(numIntersect) / step);
hold off
noiseRegions = 0;
end

