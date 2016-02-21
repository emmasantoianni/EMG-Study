%% Set options for the EMG extractor
%
% Author: Rex
%

opt = struct;

% I/O
%filename = 'GA7-15-98RPEARF';
%filename = 'data/GA8-4-98LHPCF.csv'; % large noise
%filename = 'MK3-7-96LAF';
%filename = 'trial_701 Tupaia Doughboy 9-27-2001 cricket';
opt.inputFolderName = 'data';
opt.inputFileName = 'MK3-7-96LAF';

opt.winSize = 20;
opt.posteriorThreshold = 5;
opt.allowedGap = 120;
% optional, inferred by default
signalLenThresh = 1000;
intervalThresh = 200;


% for feedback
% the 100 points after offset is considered ambiguous and not included in noise
opt.ambiguousLen = 100;
