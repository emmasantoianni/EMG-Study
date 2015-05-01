function [ waveRMS ] = integrateEMG( wave, hwSize )
% Integration of EMG signal by calculating windowed root mean square
% wave: vector representing signal values
% hwSize: scalar value of half window size
%

wSize = 2 * hwSize + 1;
waveRMS = zeros(length(wave) - 2*hwSize, 1);
ws = wave .^ 2;
for i = hwSize + 1: length(wave) - hwSize - 1
    waveRMS(i - hwSize) = sqrt(sum(ws(i - hwSize: i + hwSize)) / wSize);
end

%plot(waveRMS);
% hold on
% plot(365 * ones(length(waveRMS), 1), 'r');
% plot(380 * ones(length(waveRMS), 1), 'm');

