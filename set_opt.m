%% Set options for the EMG extractor
%
% Author: Rex
%

opt = struct;

% I/O
opt.inputFolderName = 'data';
%opt.inputFileName = 'MK3-7-96LAF';
%opt.inputFileName = 'trial_701 Tupaia Doughboy 9-27-2001 cricket';
opt.inputFileName = 'GA7-15-98RPEARF';

opt.winSize = 20;
opt.posteriorThreshold = 5;

% we allow this amount of zero entries within the signal. If the gap is
% larger than that, we split the signal into two.
opt.allowedGap = 120;

% optional, inferred by default
signalLenThresh = 1000;
intervalThresh = 200;


% for feedback
% the 100 points after offset is considered ambiguous and not included in noise
opt.ambiguousLen = 100;
