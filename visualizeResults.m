function [ ] = visualizeResults( wave, onsets, offsets, nSignalRegions, categories )
%VISUALIZERESULTS Summary of this function goes here
%   Detailed explanation goes here

figure
subplot(2, 1, 1);
hold on

if ~exist('categories', 'var')
    categories = zeros(nSignalRegions, 1);
end

handles = cell(1, 4);
for i = 1: nSignalRegions
    if i == 1
        handles{4} = plot(1: onsets(i) - 1, wave(1: onsets(i) - 1), 'b');
    else
        plot(offsets(i-1) + 1: onsets(i) - 1, wave(offsets(i-1) + 1: onsets(i) - 1), 'b');
    end
    
    if categories(i) == 0
        color = 'r';
    elseif categories(i) == 1
        color = 'm';
    else
        color = 'k';
    end
    handles{categories(i) + 1} = ...
        plot(onsets(i): offsets(i), wave(onsets(i): offsets(i)), color);
end
if offsets(nSignalRegions) < length(wave)
    tmpInds = (offsets(nSignalRegions) + 1): length(wave);
    plot(tmpInds, wave(tmpInds), 'b');
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

subplot(2, 1, 2);
plot(wave);

end

