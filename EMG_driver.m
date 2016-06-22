
%% Script to classify noise from EMG signals
%
% Author: Rex Ying
%

% Change the name of the input csv file
% The first column of the file 
set_opt;
filename = opt.inputFileName;

wave = importSignal(filename);
p = noiseModel(wave, false,  true);

wave2 = wave;
inds = 1: length(wave2);
post_processing

%% Feedback
noiseAll = [];
% the 100 points after offset is considered ambiguous and not included in noise
ambiguousLen = 100;
for i = 1: length(offsets) - 1
    if (onsets(i+1) - offsets(i) < 2 * ambiguousLen)
        continue;
    end
    noiseAll = [noiseAll; wave1(offsets(i) + ambiguousLen: onsets(i + 1) - ambiguousLen)];
end

% noise intervals
noiseIntervals = [offsets(1: length(offsets) - 1) + ambiguousLen, onsets(2: length(onsets)) - ambiguousLen];

p = noiseModel(wave1, false, false, noiseAll, noiseIntervals);
post_processing
