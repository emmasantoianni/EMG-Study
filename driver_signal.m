close all
clear all

%% Load data

rawData = csvread('data/GA2-19-97LPCF.csv', 1, 0);

fid = fopen('data/GA2-19-97LAF.csv');
header = textscan(fid,'%s %s %s %s %s %s %s %s', 1, 'delimiter',',');
fclose(fid);

%% processing

wave1 = rawData(:, 2);
figure
plot(wave1);

Fs = 10000;
[f, fLMS, nfft] = fourier(wave1, Fs);

startFreq = round(50 / f(2));
plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));

%% noise
noiseSample = wave1(1000: 4500);
figure
plot(noiseSample);

[f, fLMS, nfft] = fourier(noiseSample, Fs);
startFreq = round(50 / f(2));
figure
plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));
title 'noise Fourier transform'

%% signal
emgSample = wave1(5000: 6800);
figure
plot(emgSample);

[f, fLMS, nfft] = fourier(emgSample, Fs);
startFreq = round(50 / f(2));
figure
plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));
title 'EMG signal Fourier transform'