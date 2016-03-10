% Post-process the posterior (unnormalized) p, together with high passed
% signal wave1.
%
% Pre-requisite: EMG_driver.m
%
% Author: Rex
%

% windowSize = 11;
% f = ones(windowSize, 1);
% f = f / sum(f);
% pw = conv(p, f);
% 
% figure
% plot(pw)

% left and right window size
lwSize = 40;
rwSize = 40;
wSize = lwSize + rwSize + 1;

threshold = -10;

lscore = zeros(size(p));
rscore = zeros(size(p));
% onset: p has high value in left window, low value in right window
for i = lwSize + 1: length(p) - rwSize
    l = p(i - lwSize: i);
    r = p(i: i + rwSize);
    lscore(i) = sum(log(l) <= threshold);
    rscore(i) = sum(log(r) <= threshold);
end

figure
subplot(2, 1, 1);
plot(inds(1: end - 1), lscore);
subplot(2, 1, 2);
posterior = lscore - rscore;
% sign does not matter here
posterior = abs(posterior);
%posterior(posterior == 1) = 0;
plot(inds(1: end - 1), posterior);
csvwrite(['data/', filename, '-posterior.csv'], posterior);

%% Isolate signal regions

% posterior threshold
postThresh = 5;

% we allow this amount of zero entries within the signal. If the gap is
% larger than that, we split the signal into two.
%allowedGap = uint32(wSize );
allowedGap = 60;


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

%% Alternative (exp)
% posterior = log(p);
% allowedGap = 120;
% threshold = 1.5;
% isSignal = posterior <= 0;
% 
% idx = 2;
% nSignalRegions = 0;
% onsets = zeros(length(posterior), 1);
% offsets = zeros(length(posterior), 1);
% inSig = false;
% isMajor = false;
% while idx <= length(isSignal)
%     if isSignal(idx - 1) == 0 && isSignal(idx) == 1
%         nSignalRegions = nSignalRegions + 1;
%         inSig = true;
%         isMajor = false;
%         onsets(nSignalRegions) = idx;
%     end
%     if isSignal(idx - 1) == 1 && isSignal(idx) == 0 && nSignalRegions > 0 
%         if (isMajor)
%             % attempt to fill in gaps
%             filled = false;
%             for j = idx + allowedGap : -1: 1
%                 if (isSignal(j))
%                     isSignal(idx: j) = 1;
%                     filled = true;
%                     break;
%                 end
%             end
%             if ~filled
%                 offsets(nSignalRegions) = idx;
%             end
%         else
%             onsets(nSignalRegions) = [];
%             nSignalRegions = nSignalRegions - 1;
%         end
%         isMajor = false;
%         isSig = false;
%     end
%     if (posterior(idx) < -5)
%         isMajor = true;
%     end
%     idx = idx + 1;
% end
% onsets = onsets(1: nSignalRegions);
% offsets = offsets(1: nSignalRegions);

%% visualize
%visualizeResults( wave2, onsets, offsets, nSignalRegions );


%% Merge chewing cycles / remove outliers
signalLengths = offsets - onsets;

%signalLenThresh = 1000;
signalLenThresh = mean(signalLengths) - 0.5 * std(signalLengths);
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
    if signalLengths(i) < mu - sigma * 2
        signalRegionCategories(i) = 0;
    end
end

signalLengths = offsets - onsets;

visualizeResults( wave2, onsets, offsets, nSignalRegions, signalRegionCategories );

%% save onsets/offsets
csvwrite(['data/', filename, '_result.csv'], [onsets, offsets]);
