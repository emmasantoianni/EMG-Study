% half window size
hwSize = 10;
wSize = 2 * hwSize + 1;
waveRMS = zeros(length(wave2) - 2*hwSize, 1);
ws = wave2 .^ 2;
for i = hwSize + 1: length(wave2) - hwSize - 1
    waveRMS(i - hwSize) = sqrt(sum(ws(i - hwSize: i + hwSize)) / wSize);
end

figure
plot(inds(hwSize + 1: length(wave2) - hwSize), waveRMS);
%plot(waveRMS);
% hold on
% plot(365 * ones(length(waveRMS), 1), 'r');
% plot(380 * ones(length(waveRMS), 1), 'm');

roughNoise(abs(waveRMS));
