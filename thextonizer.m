function [ threshold, isSignal ] = thextonizer( signal )
%THEXTONIZER Implement a thextonizer
%  
%   Given an input EMG signal, find a threshold that best distinguishes noise
%   from EMG.
%

% for integration
hwSize = 49;
signalInt = integrateEMG(signal, hwSize);

figure
title('integrated signal');
plot(signalInt);

thresholds = 0.1: 0.5: 50;

nCrossings = zeros(size(thresholds));
nCrossingsRand = zeros(size(thresholds));
nCrossingsDiffs = zeros(size(thresholds));
for i = 1 : length(thresholds)
    inds = randperm(length(signal));
    randSignal = signal(inds);
    nCrossings(i) = countThresholdCrossing(signal, thresholds(i), hwSize);
    nCrossingsRand(i) = countThresholdCrossing(randSignal, thresholds(i), hwSize);
end
nCrossingsDiffs = nCrossingsRand - nCrossings;

figure
plot(nCrossingsRand, 'r');
hold on
plot(nCrossings, 'b');

figure
plot(thresholds, nCrossingsDiffs);

[~, thresholdIdx] = max(nCrossingsDiffs);
threshold = thresholds(thresholdIdx);
fprintf('Threshold: %d \n\n', threshold);

%% find onsets and offsets naively based on thextonizer

allowedGap = 120;
onsets = zeros(length(signalInt), 1);
offsets = zeros(length(signalInt), 1);
isSignal = signalInt >= threshold;

idx = 2;
while idx <= length(isSignal)
    if isSignal(idx - 1) == 1 && isSignal(idx) == 0
        gapClosed = false;
        for i = 1: allowedGap
            if isSignal(i + idx) == 1
                isSignal(idx+1: idx+i) = ones(i, 1);
                gapClosed = true;
                idx = idx + i + 1;
                break;
            end
        end
        if ~gapClosed
            idx = idx + allowedGap;
        end
    end
    idx = idx + 1;
end

figure; plot(isSignal);

end

