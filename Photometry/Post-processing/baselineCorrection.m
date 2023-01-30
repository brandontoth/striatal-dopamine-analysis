function res = baselineCorrection(photoSignal)

% Load data and add noise.
y = resample(photoSignal', 10, 1000);

N = length(y);

% Filter parameters
fc = 0.00035;     % fc : cut-off frequency (cycles/sample)
d = 2;          % d : filter order parameter (d = 1 or 2)

% Positivity bias (peaks are positive)
r = 5;          % r : asymmetry parameter

% Regularization parameters
amp = 0.8;
lam0 = 0.5*amp;
lam1 = 5*amp;
lam2 = 4*amp;

tic
[~, f1, ~] = beads(y, d, fc, r, lam0, lam1, lam2);
toc

% Display output
% ylim1 = [-10 15];
% xlim1 = [0 length(y)];
% 
% figure
% ax1 = subplot(3, 1, 1);
% plot(y)
% title('Raw signal')
% xlim(xlim1)
% ylim(ylim1)
% set(gca,'ytick', ylim1)
% set(gca, 'xtick', []); box off
% ylabel('\DeltaF/F (z-score)')
% 
% ax2 = subplot(3, 1, 2);
% plot(y,'color', [1 1 1]*0.7)
% line(1:N, f1, 'LineWidth', 1)
% legend('Data', 'Baseline')
% legend boxoff
% title(['Baseline, as estimated by BEADS', ' (r = ', num2str(r), ', fc = ', num2str(fc), ', d = ', num2str(d),')'])
% xlim(xlim1)
% ylim(ylim1)
% set(gca,'ytick', ylim1)
% set(gca, 'xtick', []); box off
% ylabel('\DeltaF/F (z-score)')
% 
% ax3 = subplot(3, 1, 3);
% plot(y - f1)
% title('Baseline corrected signal')
% xlim(xlim1)
% ylim(ylim1)
% set(gca,'ytick', ylim1)
% set(gca, 'Ticklength', [0 0]); box off
% xticks([0:36000:length(y)])
% xticklabels({'0','1','2','3','4','5','6','7','8','9','10','11','12'})
% xlabel('Time (h)')
% ylabel('\DeltaF/F (z-score)')
% 
% linkaxes([ax1 ax2 ax3], 'xy')

res = y - f1;
res = resample(res', 1000, 10);

end