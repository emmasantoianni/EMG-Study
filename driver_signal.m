close all
clear all

%% Load data

rawData = csvread('data/GA2-19-97LAF.csv', 1, 0);

fid = fopen('data/GA2-19-97LAF.csv');
header = textscan(fid,'%s %s %s %s %s %s %s %s', 1, 'delimiter',',');
fclose(fid);

%% processing

MUS = rawData(:, 8);
figure
plot(MUS);

Fs = 10000;
[f, fLMS, nfft] = fourier(MUS, Fs);

startFreq = round(50 / f(2));
plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));

%% noise
noiseSample = MUS(1000: 4500);
figure
plot(noiseSample);

[f, fLMS, nfft] = fourier(noiseSample, Fs);
startFreq = round(50 / f(2));
figure
plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));
title 'noise Fourier transform'

%% signal
emgSample = MUS(5000: 6800);
figure
plot(emgSample);

[f, fLMS, nfft] = fourier(emgSample, Fs);
startFreq = round(50 / f(2));
figure
plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));
title 'EMG signal Fourier transform'