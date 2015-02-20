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
noise = round(noise * 1e5);
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
figure
%surf(TM, 'LineWidth',0);
surf(TM);

% x = diffNoise < 322 & diffNoise > 288;
% plot(x)

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