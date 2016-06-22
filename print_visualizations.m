%% C: low amplitude rythmic behavior
wave = importSignal('trial_701 Tupaia Doughboy 9-27-2001 cricket');
figure
plot(wave(6900:10900), 'k');
set(gcf, 'Position', [100, 100, 1063, 797]);

imagewd = getframe(gcf); 
imwrite(imagewd.cdata, 'figs/3C.tif', 'Resolution', 300);

%% B: orphan spikes
wave = importSignal('GA7-15-98RPEARF');
figure
plot(wave(4320:8500), 'k');
set(gcf, 'Position', [100, 100, 1063, 797]);

imagewd = getframe(gcf); 
imwrite(imagewd.cdata, 'figs/3B.tif', 'Resolution', 300);


%% A: silent periods
figure
wave = importSignal('trial_701 Tupaia Doughboy 9-27-2001 cricket');
plot(wave(24500:28500), 'k');
set(gcf, 'Position', [100, 100, 1063, 797]);

imagewd = getframe(gcf); 
imwrite(imagewd.cdata, 'figs/3A.tif', 'Resolution', 300);


%% figure 2
%2A
close all
open('figs/transition_hist_noise.fig');
ax = gca; 
set(ax,'XTickMode','manual');
set(ax,'YTickMode','manual');
set(ax,'ZTickMode','manual');
set(ax,'XLimMode','manual');
set(ax,'YLimMode','manual');
set(ax,'ZLimMode','manual');
set(gca,'FontSize',6);

colormap gray
set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0, 0, 8.8, 6.6])
print('figs/2A.tif', '-dtiff', ['-r', '300']);

% 2B
open('figs/transition_hist_signal.fig');
ax = gca; 
set(ax,'XTickMode','manual');
set(ax,'YTickMode','manual');
set(ax,'ZTickMode','manual');
set(ax,'XLimMode','manual');
set(ax,'YLimMode','manual');
set(ax,'ZLimMode','manual');
set(gca,'FontSize',6);

colormap gray
set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0, 0, 8.8, 6.6])
print('figs/2B.tif', '-dtiff', ['-r', '300']);

% 2C
open('figs/transition_bw_signal.fig');
ax = gca; 
set(ax,'XTickMode','manual');
set(ax,'YTickMode','manual');
set(ax,'ZTickMode','manual');
set(ax,'XLimMode','manual');
set(ax,'YLimMode','manual');
set(ax,'ZLimMode','manual');
set(gca,'FontSize',6);

colormap gray
set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0, 0, 8.8, 8.8])
print('figs/2C.tif', '-dtiff', ['-r', '300']);

%% figure 1
close all
% 1A
open('figs/1A.fig');
set(gcf, 'Position', [0, 0, 2200, 550]);
set(gcf,'Units','normalized')
set(gca,'Position',[.05 .05 .9 .9])
set(gcf,'Units','pixels')
imagewd = getframe(gcf); 
imwrite(imagewd.cdata, 'figs/1A.tif', 'Resolution', 300);

% 1B
open('figs/1B.fig');
set(gcf, 'Position', [0, 0, 2200, 550]);
set(gcf,'Units','normalized')
set(gca,'Position',[.05 .05 .9 .9])
set(gcf,'Units','pixels')
imagewd = getframe(gcf); 
imwrite(imagewd.cdata, 'figs/1B.tif', 'Resolution', 300);

% 1C
open('figs/1C.fig');
set(gcf, 'Position', [0, 0, 2200, 550]);
set(gcf,'Units','normalized')
set(gca,'Position',[.05 .05 .9 .9])
set(gcf,'Units','pixels')
imagewd = getframe(gcf); 
imwrite(imagewd.cdata, 'figs/1C.tif', 'Resolution', 300);

