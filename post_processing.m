% post-process the posterior (unnormalized) p, together with high passed
% signal wave1.
%
% Run driver_signal, noise_model first
%
% author: Rex
%

% left and right window size
lwSize = 20;
rwSize = 20;
wSize = lwSize + rwSize + 1;
%threshold = 1.5;
% for continuous
threshold = 4;

lscore = zeros(size(p));
rscore = zeros(size(p));
% onset: p has high value in left window, low value in right window
for i = lwSize + 1: length(p) - rwSize
    l = p(i - lwSize: i);
    r = p(i: i + rwSize);
    lscore(i) = sum(l <= threshold);
    rscore(i) = sum(r <= threshold);
end

figure
subplot(2, 1, 1);
plot(inds(1: end - 1), lscore);
subplot(2, 1, 2);
posterior = lscore - rscore;
plot(inds(1: end - 1), lscore - rscore);
csvwrite(['data/', filename, '-posterior.csv'], posterior);

%% Isolate signal regions

% posterior threshold
postThresh = 5;

% we allow this amount of zero entries within the signal. If the gap is
% larger than that, we split the signal into two.
%allowedGap = uint32(wSize );
allowedGap = 60;

% sign does not matter here
posterior = abs(posterior);

nSignalRegions = 0;
onsets = zeros(length(posterior), 1);
offsets = zeros(length(posterior), 1);
inSignal = false;
for i = 1: length(posterior) - allowedGap
    if ~inSignal && posterior(i) > 0
        onsetStart = i;
    end
    seg = posterior(i: i + allowedGap - 1);
    % transfer into signal region
    if ~inSignal && seg(1) >= postThresh
        inSignal = true;
        nSignalRegions = nSignalRegions + 1;
        
        onsetStart = findGap(posterior, i, allowedGap + 1, 'before');
        onsets(nSignalRegions) = onsetStart;
    % transfer out of signal region:
    % When the values are less than 4 in allowed gap, followed by a
    % sequence of zeros
    elseif inSignal && ~any(seg >= postThresh) && ~any(posterior(i + allowedGap: i + allowedGap))
        inSignal = false;
        
        % if the length of this detected signal is too insignificant,
        % discard
        if i - onsets(nSignalRegions) <= wSize
            onsets(nSignalRegions) = 0;
            nSignalRegions = nSignalRegions - 1;
        else
            offsetEnd = findGap(posterior, i, allowedGap + 1, 'after');
            offsets(nSignalRegions) = offsetEnd;
        end
    end
end
if inSignal
    offsets(nSignalRegions) = length(posterior);
end
onsets = onsets(1: nSignalRegions);
offsets = offsets(1: nSignalRegions);

%% visualize
visualizeResults( wave2, onsets, offsets, nSignalRegions );


%% Merge chewing cycles / remove outliers
signalLengths = offsets - onsets;

signalLenThresh = 1000;
intervalThresh = mean(signalLengths) - 0.5 * std(signalLengths);
intervalThresh = 200;

ind = 2;
while ind <= length(onsets)
%     if signalLengths(ind-1) < signalLenThresh && signalLengths(ind) > signalLenThresh && ...
%             onsets(ind) - offsets(ind-1) < intervalThresh
    if signalLengths(ind-1) < signalLenThresh && onsets(ind) - offsets(ind-1) < intervalThresh
        offsets(ind-1) = offsets(ind);
        signalLengths(ind-1) = offsets(ind-1) - onsets(ind-1);
        
        signalLengths(ind) = [];
        onsets(ind) = [];
        offsets(ind) = [];
    else
        ind = ind + 1;
    end
end

% update based on onsets/offsets
nSignalRegions = ind - 1;

figure
hist(signalLengths);
title('Histogram of signal lengths');

%% categorize signals
mu = mean(signalLengths);
sigma = std(signalLengths);

% max amplitude
maxAmp = zeros(size(signalLengths));
for i = 1: length(signalLengths)
    maxAmp(i) = max(abs(wave2(onsets(i): offsets(i))));
end
muMaxAmp = mean(maxAmp);
threshAmp = muMaxAmp - std(maxAmp) * 2;

signalRegionCategories = zeros(size(signalLengths));
for i = 1: length(signalLengths)
    if maxAmp(i) < threshAmp
        signalRegionCategories(i) = 2;
    elseif signalLengths(i) < mu - sigma * 2
        signalRegionCategories(i) = 1;
    end
end

signalLengths = offsets - onsets;

visualizeResults( wave2, onsets, offsets, nSignalRegions, signalRegionCategories );

%% Obtain noise region for the estimation (can be used for feedback)

