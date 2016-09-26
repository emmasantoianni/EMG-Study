%% Set options for the EMG extractor
%
% Author: Rex
%

opt = struct;

% I/O
opt.inputFolderName = 'data/';
% enter file name for analysis here,then specify the colmn number (channel)
% for analysis at opt.channel
opt.inputFileName = 'M fuscata 853 9-3-98 LA LMS';
opt.channel = 1;
% set to true if we want to generate intermediate figures at each step
opt.debug = true;

% winSize is the number of points we use to average for postprocessing
% posterior threshold value, when greater than 5, will yield a less
% conservative estimate of EMG signal
opt.winSize = 20;
opt.posteriorThreshold = 5;

% we allow this amount of zero entries within the signal for including a 
% silent period. If the gap is
% larger than that, we split the signal into two.
opt.allowedGap = 400;

% optional, inferred by default
% signalLenThresh is sensitive to sampling frequency.  A signalLenThresh
% of 1000 will delete all EMG signal that is less than 1000 data points.
% This gets rid of short duration orphan spikes.  A lower signalLenThresh
% is recommended for sampling rates less than 10 Khz.
opt.signalLenThresh = 1000;


% the 100 points after offset is considered ambiguous and not included in
% noise during feedback steps
opt.ambiguousLen = 100;
