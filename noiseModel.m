function [ p ] = noiseModel( wave1, extremaOnly )
%NOISEMODEL Noise model using bigrams
%   Detailed explanation goes here

%% Model params
%range = [6000, 15000];
%noise = wave1(range(1): range(2));
%noise = wave1;

% optional: simplify by removing consecutive 
if extremaOnly
    noiseAll = extractExtrema(noiseAll);
    [wave2, inds] = extractExtrema(wave1);
else
    wave2 = wave1;
    inds = 1: length(wave2);
end


%% Transition matrix
% need to scale noise and round it
diffNoise = diff(round(noiseAll));
diffOffset = min(diffNoise) - 1;
n = round(max(diffNoise - diffOffset));
TM = zeros(n, n);
for i = 1: length(noiseIntervals)
    noise = wave1(noiseIntervals(i, 1): noiseIntervals(i, 2));
    
    diffNoise = diff(round(noise)) - diffOffset;
    %plot(diffNoise);
    % transition

    % the coordinates of each point is the consecutive diffNoise values
    points = zeros(2, length(diffNoise) - 1);
    for j = 1: length(diffNoise) - 1
        curr = diffNoise(j);
        next = diffNoise(j + 1);
        points(:, j) = [curr; next];
        TM(round(curr), round(next)) = TM(curr, next) + 1;
    end
end
figure
surf(TM);
scatter(points(1, :), points(2, :), '.');
mu = mean(points, 2);
sigma = cov(points');

%% evaluate diff sequence

if ~exist('reRun', 'var')
    reRun = true;
end

diffWave = diff(wave2) - diffOffset;
if reRun
    TMall = java.util.HashMap;
    for i = 1: length(diffWave) - 1
        p = java.awt.Point(diffWave(i), diffWave(i+1));
        count = TMall.get(p);
        if isempty(count)
            TMall.put(p, 1);
        else
            TMall.put(p, count + 1);
        end
    end
    reRun = false;
else
    if extremaOnly
        load TMall1;
    else
        load TMall;
    end
end

disp('Computing probability for entire sequence ...');
p = zeros(length(diffWave), 1);
for i = 1: length(diffWave) - 1
    curr = diffWave(i);
    next = diffWave(i+1);
    pVal = TMall.get(java.awt.Point(curr, next));
    if isempty(pVal)
        pVal = 0;
    else
        pVal = pVal / (length(diffWave) - 1);
    end
    % probability of taking that value given in noise region
    if round(curr) < n && round(curr) > 0 && round(next) < n && round(next) > 0
        pVgN = TM(round(curr), round(next)) / (length(diffNoise) - 1);
    else % need smoothing
        pVgN = 0;
    end
    p(i) = pVgN / pVal;
end

figure

subplot(2, 1, 1);
plot(inds(1: end - 1), p); % last point not calculated
title('Raw unnormalized probability');
subplot(2, 1, 2);
plot(inds(1: end - 1), log(p + eps));

figure
plot(wave1)

%% Windowing
windowSize = 11;
f = ones(windowSize, 1);
f = f / sum(f);
pw = conv(p, f);

figure
plot(pw)
title('Posterior with window size 11');

end

