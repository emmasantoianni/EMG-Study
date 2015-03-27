function [ signal ] = highPass( signal, Fs, sigma )
%HIGHPASS Summary of this function goes here
%   sigma: standard deviation of gaussian high pass filter

% l = length(signal);
% [f, femg, nfft] = fourier(signal, Fs);
% %plot(f(:), abs(femg(1:nfft/2+1)));
% 
% % Gaussian filter in Fourier domain
% % standard deviation of gaussian filter: 100
% g = normpdf(1: nfft, 0, sigma)';
% g = 1 - g / g(1);
% 
% femg = femg .* g;
% signal = abs(ifft(femg, nfft));
% signal = abs(signal(1: l));

cutoff = 50;
scale = 1e5;

[b, a] = butter(3, cutoff /Fs * 2, 'high');
% filtfilt: zero-phase filtering
signal = filtfilt(b, a, signal) / scale;

end

