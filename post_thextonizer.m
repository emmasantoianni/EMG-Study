function [ onsets, offsets ] = post_thextonizer( isSignal )
%POST_THEXTONIZER Summary of this function goes here
%   Detailed explanation goes here

nSignals = 0;
i = 1;
while i <= length(isSignal)
    if isSignal(i) == 1
        nSignals = nSignals + 1;
        onsets(nSignals) = i;
        while isSignal(i) == 1
            i = i + 1;
        end
        offsets(nSignals) = i - 1;
    end
    i = i + 1;
end

end

