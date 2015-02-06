tic
range = [6000, 15000];
noise = wave1(range(1): range(2));
diffNoise = diff(noise);
diffNoise = diffNoise - min(diffNoise) + 1;
plot(noise);
% transition
n = max(diffNoise);
TM = zeros(n, n);
for i = 1: length(diffNoise) - 1
    curr = diffNoise(i);
    next = diffNoise(i + 1);
    TM(curr, next) = TM(curr, next) + 1;
end
toc

% numNoiseRegions = 0;
% noiseRegions = zeros(100, 2);
% threshold = 50;
% avg = mean(wave1);
% isNoise = false;
% for i = 1: length(wave1)
%     % is in noise threshold reagion
%     if wave1(i) >= avg - threshold && wave1(i) <= avg + threshold
%         if ~isNoise
%             