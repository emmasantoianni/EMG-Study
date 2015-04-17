%%% EMG Integration

% This is a script for filtering and integrating EMG files. Runs on .txt.
% Authors: M. O'Neill, C. Wall. began on 4.23.07

dir = ('C:\Documents and Settings\wall0012\Desktop\Chris Desktop Data\RMS EMG\');

%% load data
[filename,pathname] = uigetfile('*.*','Select an EMG file');
fullpath = [pathname,filename];
EMGraws = dlmread(fullpath,',',0,0); % data is tab-delimited, start at row 1, column 1

%EMGraw = EMGraws(15000:80000,1:11); % turn off to use entire file
% data is loaded with 8 EMG channels retained

%% now we are going to see about filtering
%-------------------------------------------
%%% Filter using Butterworth (Bandpass, 100-3000Hz)
%-------------------------------------------
Wn = [.01 .3];
[b,a]=butter(2,Wn,'bandpass');
EMGfilt=filtfilt(b,a,EMGraw);

% next we are going to experiment with rectifying in different ways
% let's see what it looks like to just take absolute values

EMGabs=abs(EMGfilt);

%%
%-------------------------------------------
%%% Compute Root Mean Square
%-------------------------------------------
% Time Constant
% You only need to change T to change the size of the window 
% over which you want to integrate siEMGs
T = 21; %Window size (must be an odd #)
        %data collected at 500Hz so each data point is over 2 msec
        %and T=21 provides a 42 msec window

W = (T-1)/2;
X = EMGfilt.^2;
RMS = abs(X);

for j = 1:size(X,2)
    for i = 1+W: length(X)-W
       Y1(i,j) = sqrt(sum(X(i-W:i+W,j))./T);
    end
end

RMS(W+1:end,:) = Y1;
clear i j X W T

%% plot
tmsec = ((1:length(EMGfilt)).*2)-2; % time column

plot(tmsec,EMGraw(:,8)+4,'b')
hold on
plot(tmsec,EMGfilt(:,8)+2.5,'r')
plot(tmsec,EMGabs(:,8)+1,'g')
plot(tmsec,RMS(:,8),'k')
legend('Raw EMG','Filtered EMG','Rectified EMG','RMS EMG','Location','Best');
pause
close

%% PLOTS
% this plots up to 11 channels

plot(tmsec,RMS(:,1))
hold on
plot(tmsec,RMS(:,2)+.5,'r')
plot(tmsec,RMS(:,3)+1,'g')
plot(tmsec,RMS(:,4)+1.5,'m')
plot(tmsec,RMS(:,5)+2,'b:')
plot(tmsec,RMS(:,6)+2.5,'r:')
plot(tmsec,RMS(:,7)+3,'g:')
plot(tmsec,RMS(:,8)+3.5,'m:')
plot(tmsec,RMS(:,9)+4.5,'k')
plot(tmsec,RMS(:,10)+5,'k:')
plot(tmsec,EMGraw(:,11)+5.5,'k')
pause
close

%% Save EMG data
     
M = length(RMS);
RMSout = zeros(M,24);

RMSout(:,1) = tmsec;
RMSout(:,2:12) = RMS;
RMSout(:,13) = EMGraw(:,11);
RMSout(:,14:24) = EMGabs;

% cd(dir)
% 
% [filename, pathname] = uiputfile('*.txt', 'Save File As');
% dlmwrite([dir filename],RMSout,'delimiter',','); 

