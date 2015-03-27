close all

%% Known regions of noise
noiseIntervals = [8077, 9079; 12685, 16654; 19110, 21555; ...
    23765, 25641; 27810, 29482; 31475, 34075; 39207, 43350; ...
    46366, 50442; 53944, 57694; 60473, 63119; 65967, 67801; ...
    68178, 70163; 72893, 73823; 76333, 78476; 80640, 82557; ...
    86985, 89814];

noise = [];
time = [];
for i = 1: size(noiseIntervals, 1)
    noise = [noise; wave1(noiseIntervals(i, 1): noiseIntervals(i, 2))];
    time = [time; (noiseIntervals(i, 1): noiseIntervals(i, 2))'];
end
figure
plot(noise);

% sigma = 100;
% noise1 = highPass(wave(noiseIntervals(7, 1): noiseIntervals(7, 2)), Fs, sigma);
% figure
% plot(noise1);
% title('noise extraction followed by high pass');

% figure
% plot(wave1(noiseIntervals(7, 1): noiseIntervals(7, 2)));
% title('high pass followed by noise extraction');

%% Model
%range = [6000, 15000];
%noise = wave1(range(1): range(2));
%noise = wave1;

% need to scale noise and round it
%noise = round(noise);
% diffNoise = diff(noise);
% d = diff(sort(unique(diffNoise)));
% r = d(1); % discrete step
% wave1 = wave1 / r;
diffNoise = diff(round(noise));
diffOffset = min(diffNoise) - 1;
diffNoise = diffNoise - diffOffset; % to make index positive
%plot(diffNoise);
% transition
n = round(max(diffNoise));
TM = zeros(n, n);
% the coordinates of each point is the consecutive diffNoise values
points = zeros(2, length(diffNoise) - 1);
for i = 1: length(diffNoise) - 1
    curr = diffNoise(i);
    next = diffNoise(i + 1);
    points(:, i) = [curr; next];
    TM(round(curr), round(next)) = TM(curr, next) + 1;
end
figure
surf(TM);
figure
scatter(points(1, :), points(2, :), '.');
mu = mean(points, 2);
sigma = cov(points');

%% evaluate diff sequence

if ~exist('reRun', 'var')
    reRun = true;
end

diffWave = diff(wave1) - diffOffset;
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
    load TMall;
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
plot(p)
figure
plot(wave1)

% numNoiseRegions = 0;
% noiseRegions = zeros(100, 2);clo
% threshold = 50;
% avg = mean(wave1);
% isNoise = false;
% for i = 1: length(wave1)
%     % is in noise threshold reagion
%     if wave1(i) >= avg - threshold && wave1(i) <= avg + threshold
%         if ~isNoise
%             