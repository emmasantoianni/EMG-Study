function [ wave ] = importSignal( filename, plotWave )
%% Import signal from csv file
%
% Input:
%   plot: if true, plot the signals before and after high-pass filter
%       By default, it is set to false.
%
% Author: Rex
%

if ~exist('plotWave', 'var')
    plotWave = false;
end

%rawData = csvread(, 1, 0);
rawData = csvread(['data/', filename, '.csv'], 1, 0);

fid = fopen(['data/', filename, '.csv']);
header = textscan(fid,'%s %s %s %s %s %s %s %s', 1, 'delimiter',',');
fclose(fid);

%% processing

wave = rawData(:, 1);
if plotWave
    figure
    plot(wave);
    title 'original wave'
end

Fs = 10000;
%[f, fLMS, nfft] = fourier(wave, Fs);

%startFreq = round(50 / f(2)); % disregard low frequency region
%figure
%plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));
%title 'Fourier transform of original wave'

%% High pass
sigma = 100;
% The higher scaling const is, the more precise will the later stage be
% since the transition matrix is based on rounded integer signal strength
wave = highPass(wave, Fs, sigma) * 1e5;

if plotWave
    figure
    plot(wave);
    title 'after high pass'
end

%% noise
% noiseSample = wave(1000: 4500);
% figure
% plot(noiseSample);
% title 'EMG noise plot'
% 
% [f, fLMS, nfft] = fourier(noiseSample, Fs);
% startFreq = round(50 / f(2));
% figure
% plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));
% title 'noise Fourier transform'

%% signal
% emgSample = wave(5000: 6800);
% figure
% plot(emgSample);
% title 'EMG signal plot'
% 
% [f, fLMS, nfft] = fourier(emgSample, Fs);
% startFreq = round(50 / f(2));
% figure
% plot(f(startFreq: end), 2*abs(fLMS(startFreq: nfft/2+1)));
% title 'EMG signal Fourier transform'




