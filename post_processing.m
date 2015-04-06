% post-process the posterior (unnormalized) p, together with high passed
% signal wave1.
%
% Run driver_signal, noise_model first
%
% author: Rex
%

% left and right window size
lwSize = 40;
rwSize = 40;
threshold = 2;

lscore = zeros(size(p));
rscore = zeros(size(p));
% onset: p has high value in left window, low value in right window
for i = lwSize + 1: length(p) - rwSize
    l = p(i - lwSize: i);
    r = p(i: i + rwSize);
    lscore(i) = sum(l <= threshold);
    rscore(i) = sum(r <= threshold);
end
plot(1: length(p), lscore);