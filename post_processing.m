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
threshold = 1.5;

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
csvwrite('data/GA7-15-98RPEARF-posterior.csv', posterior);

%% Isolate signal regions

% posterior threshold
postThresh = 3;

% we allow this amount of zero entries within the signal. If the gap is
% larger than that, we split the signal into two.
allowedGap = wSize * 2;

% sign does not matter here
posterior = abs(posterior);

nSignalRegions = 0;
onsets = zeros(length(posterior), 1);
offsets = zeros(length(posterior), 1);
inSignal = false;
for i = 1: length(posterior) - allowedGap
    seg = posterior(i: i + allowedGap - 1);
    % transfer into signal region
    if ~inSignal && seg(1) >= postThresh
        inSignal = true;
        nSignalRegions = nSignalRegions + 1;
        onsets(nSignalRegions) = i;
    % transfer out of signal region:
    % When the values are less than 4 in allowed gap, followed by a
    % sequence of zeros
    elseif inSignal && ~any(seg >= postThresh) && ~any(posterior(i + allowedGap: i + 2*allowedGap))
        inSignal = false;
        
        % if the length of this detected signal is too insignificant,
        % discard
        if i - onsets(nSignalRegions) <= wSize
            onsets(nSignalRegions) = 0;
            nSignalRegions = nSignalRegions - 1;
        else
            offsets(nSignalRegions) = i;
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

ind = 2;
while ind <= length(onsets)
    if signalLengths(ind-1) < signalLenThresh && signalLengths(ind) > signalLenThresh && ...
            onsets(ind) - offsets(ind-1) < intervalThresh
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

hist(signalLengths);
%%
mu = mean(signalLengths);
sigma = std(signalLengths);

% mean amplitude
meanAmp = zeros(size(signalLengths));
for i = 1: length(signalLengths)
    meanAmp(i) = mean(abs(wave2(onsets(i): offsets(i))));
end
muMeanAmp = mean(meanAmp);
threshAmp = muMeanAmp - std(meanAmp);

signalRegionCategories = zeros(size(signalLengths));
for i = 1: length(signalLengths)
    if meanAmp(i) < threshAmp
        signalRegionCategories(i) = 2;
    elseif signalLengths(i) < mu - sigma / 2
        signalRegionCategories(i) = 1;
    end
end

signalLengths = offsets - onsets;

visualizeResults( wave2, onsets, offsets, nSignalRegions, signalRegionCategories );