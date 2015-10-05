close all

extremaOnly = false;

if extremaOnly
    [wave2, inds] = extractExtrema(wave1);
else
    wave2 = wave1;
    inds = 1: length(wave2);
end

%% Known regions of noise

% this applies to the data/GA7-15-98RPEARF.csv dataset.
% noiseIntervals = [8077, 9079; 12685, 16654; 19110, 21555; ...
%     23765, 25641; 27810, 29482; 31475, 34075; 39207, 43350; ...
%     46366, 50400; 53944, 57694; 60473, 63119; 65967, 67801; ...
%     68178, 70163; 72893, 73823; 76333, 78476; 80640, 82557; ...
%     86985, 89814];
% 
% figure
% title('Pre-identified noise intervals');
% hold on
% noiseAll = [];
% for i = 1: size(noiseIntervals, 1)
%     noise = wave1(noiseIntervals(i, 1): noiseIntervals(i, 2));
%     time = (noiseIntervals(i, 1): noiseIntervals(i, 2))';
%     plot(time, noise);
%     noiseAll = [noiseAll; noise];
% end
% hold off

% sigma = 100;
% noise1 = highPass(wave(noiseIntervals(7, 1): noiseIntervals(7, 2)), Fs, sigma);
% figure
% plot(noise1);
% title('noise extraction followed by high pass');

% figure
% plot(wave1(noiseIntervals(7, 1): noiseIntervals(7, 2)));
% title('high pass followed by noise extraction');

%% Approximate rough noise regions (conservative)

hwSize = 7;
approxNoiseIntervals = roughNoise(wave2, inds, hwSize);

figure
title(sprintf('Approximate noise intervals with window size %d', hwSize*2 + 1));
hold on
noiseAll = [];
for i = 1: size(approxNoiseIntervals, 1)
    noise = wave1(approxNoiseIntervals(i, 1): approxNoiseIntervals(i, 2));
    time = (approxNoiseIntervals(i, 1): approxNoiseIntervals(i, 2))';
    plot(time, noise);
    noiseAll = [noiseAll; noise];
end
hold off
noiseIntervals = approxNoiseIntervals;

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
surf(-20:20, -20:20, TM, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
%scatter(points(1, :), points(2, :), '.');

%% For continuous model (with normal distribution assumption):
points = zeros(2, length(wave2));
ind = 0;
for i = 1: length(noiseIntervals)
    noise = wave2(noiseIntervals(i, 1): noiseIntervals(i, 2));
    diffNoise = diff(round(noise));
    for j = 1: length(diffNoise) - 1
        curr = diffNoise(j);
        next = diffNoise(j + 1);
        ind = ind + 1;
        points(:, ind) = [curr; next];
    end
end
points = points(:, 1: ind);
muNoise = mean(points, 2);
sigmaNoise = cov(points');

diffWave = diff(wave2);
pointsAll = zeros(2, length(diffWave));
ind = 0;
for i = 1: length(noiseIntervals)
    curr = diffWave(i);
    next = diffWave(i + 1);
    ind = ind + 1;
    pointsAll(:, ind) = [curr; next];
end
pointsAll = pointsAll(:, 1: ind);
muAll = mean(pointsAll, 2);
sigmaAll = cov(pointsAll');

%% evaluate diff sequence

if ~exist('reRun', 'var')
    reRun = true;
end

% only for discrete case
diffWave = diff(wave2);
diffOffsetAll = min(diffWave) - 1;
diffWaveAll = diffWave - diffOffsetAll;

% visualization only
nAll = round(max(diffWaveAll));
TMallMat = zeros(nAll, nAll);

if reRun
    TMall = java.util.HashMap;
    for i = 1: length(diffWave) - 1
        pt = java.awt.Point(diffWave(i), diffWave(i+1));
        TMallMat(round(diffWaveAll(i)), round(diffWaveAll(i+1))) = TMallMat(round(diffWaveAll(i)), round(diffWaveAll(i+1))) + 1;
        count = TMall.get(pt);
        if isempty(count)
            TMall.put(pt, 1);
        else
            TMall.put(pt, count + 1);
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

surf(-200:139, -200:139, TMallMat, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');

%%

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
    else % need smoothing (outside of TM)
        pVgN = 0;
    end
    
    p(i) = pVgN / pVal;
    
    pValCont = mvnpdf([curr; next], muAll, sigmaAll) / (length(diffWave) - 1);
    pVgNCont = mvnpdf([curr; next], muNoise, sigmaNoise) /  (length(diffNoise) - 1);
    % use continuous model
    p(i) = pVgNCont / pValCont;
end



figure

subplot(3, 1, 1);
plot(inds(1: end - 1), p); % last point not calculated
title('Raw unnormalized probability');
subplot(3, 1, 2);
plot(inds(1: end - 1), log(p + eps));
ylabel('log scale');

subplot(3, 1, 3);
plot(wave1)
ylabel('original signal');

%% Windowing
windowSize = 11;
f = ones(windowSize, 1);
f = f / sum(f);
pw = conv(p, f);

figure
plot(pw)
title('Posterior with window size 11');
