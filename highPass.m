function [ signal ] = highPass( signal, Fs, sigma )
%HIGHPASS Summary of this function goes here
%   sigma: standard deviation of gaussian high pass filter

l = length(signal);
[f, femg, nfft] = fourier(signal, Fs);
%plot(f(:), abs(femg(1:nfft/2+1)));

% Gaussian filter in Fourier domain
% standard deviation of gaussian filter: 100
g = normpdf(1: nfft, 0, sigma)';
g = 1 - g / g(1);

femg = femg .* g;
signal = real(ifft(femg, nfft));
signal = real(signal(1: l));

end

