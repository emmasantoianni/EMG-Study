close all
clear all

%% Load data

rawData = csvread('data/GA7-15-98RPEARF.csv', 1, 0);

fid = fopen('data/GA7-15-98RPEARF.csv');
header = textscan(fid,'%s %s %s %s %s %s %s %s', 1, 'delimiter',',');
fclose(fid);

%% processing

wave = rawData(:, 1);
figure
plot(wave);

Fs = 10000;
[f, fLMS, nfft] = fourier(wave, Fs);

startFreq = round(50 / f(2)); % disregard low frequency region
plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));

%% High pass
sigma = 100;
wave1 = highPass(wave, Fs, sigma);
plot(wave1);

%% noise
noiseSample = wave(1000: 4500);
figure
plot(noiseSample);

[f, fLMS, nfft] = fourier(noiseSample, Fs);
startFreq = round(50 / f(2));
figure
plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));
title 'noise Fourier transform'

%% signal
emgSample = wave(5000: 6800);
figure
plot(emgSample);

[f, fLMS, nfft] = fourier(emgSample, Fs);
startFreq = round(50 / f(2));
figure
plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));
title 'EMG signal Fourier transform'