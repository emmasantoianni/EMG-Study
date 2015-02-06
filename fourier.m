function [ f, femg, nfft ] = fourier( signal, Fs )
%FOURIER Summary of this function goes here
%   Detailed explanation goes here

len = length(signal);

nfft = 2^nextpow2(len); % Next power of 2 from length of y
femg = fft(signal, nfft)/len;
%fLMS = fftshift(fft(fftshift(LMS)));

f = Fs/2*linspace(0,1, nfft/2+1);

end

