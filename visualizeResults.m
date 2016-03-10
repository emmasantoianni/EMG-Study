function [ ] = visualizeResults( wave, onsets, offsets, nSignalRegions, categories )
%VISUALIZERESULTS Summary of this function goes here
%   Detailed explanation goes here

noiseColor = [0.8 0.8 0.8];
signalColor = [0.1 0.1 0.1];

figure
%subplot(2, 1, 2);
hold on

if ~exist('categories', 'var')
    categories = zeros(nSignalRegions, 1);
end

handles = cell(1, 4);
for i = 1: nSignalRegions
    if i == 1
        handles{4} = plot(1: onsets(i) - 1, wave(1: onsets(i) - 1), 'Color', noiseColor);
    else
        plot(offsets(i-1) + 1: onsets(i) - 1, wave(offsets(i-1) + 1: onsets(i) - 1), 'Color', noiseColor);
    end
    
    if categories(i) == 0
        color = signalColor;
    elseif categories(i) == 1
        color = signalColor;
    else
        color = signalColor;
    end
    handles{categories(i) + 1} = ...
        plot(onsets(i): offsets(i), wave(onsets(i): offsets(i)), 'Color', color);
end
if offsets(nSignalRegions) < length(wave)
    tmpInds = (offsets(nSignalRegions) + 1): length(wave);
    plot(tmpInds, wave(tmpInds), 'Color', noiseColor);
end

legendStr = {'signal', 'insignificant signal', 'boundary case', 'noise'};

i = 1;
while i <= length(handles)
    if isempty(handles{i})
        handles(i) = [];
        legendStr(i) = [];
    else
        i = i + 1;
    end
end

legendHandles = [];
for i = 1: length(handles)
    legendHandles = [legendHandles, handles{i}];
end
legend(legendHandles, legendStr);

hold off
title('singals classified');

figure
%subplot(2, 1, 1);
plot(wave, 'Color', signalColor);

end

