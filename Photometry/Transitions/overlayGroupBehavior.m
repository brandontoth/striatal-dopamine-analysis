function [] = overlayGroupBehavior(koBehavior, wtBehavior, cutTime, Fs)

% plot all relevant transitions as well as heatmaps and bar graphs for mean
% DFF per state, then save everything to a structure for later use
yAxisLabel = '\DeltaF/F (z-score)';

% KO stuff
pelletKO = koBehavior.pellet;
lickOnsetKO = koBehavior.lickOnsetDFF;
lickOffsetKO = koBehavior.lickOffsetDFF;
rwOnsetKO = koBehavior.rwOnsetDFF;
rwOffsetKO = koBehavior.rwOffsetDFF;

normPelletKO = normalization(pelletKO, 2000);
normLickOnsetKO = normalization(lickOnsetKO, 2000);
normLickOffsetKO = normalization(lickOffsetKO, 2000);
normRwOnsetKO = normalization(rwOnsetKO, 2000);
normRwOffsetKO = normalization(rwOffsetKO, 2000);

avgPelletKO = koBehavior.avgPellet;
avgLickOnsetKO = koBehavior.avgLickOnset;
avgLickOffsetKO = koBehavior.avgLickOffset;
avgRwOnsetKO = koBehavior.avgRwOnset;
avgRwOffsetKO = koBehavior.avgRwOffset;

% WT stuff
pelletWT = wtBehavior.pellet;
lickOnsetWT = wtBehavior.lickOnsetDFF;
lickOffsetWT = wtBehavior.lickOffsetDFF;
rwOnsetWT = wtBehavior.rwOnsetDFF;
rwOffsetWT = wtBehavior.rwOffsetDFF;

normPelletWT = normalization(pelletWT, 2000);
normLickOnsetWT = normalization(lickOnsetWT, 2000);
normLickOffsetWT = normalization(lickOffsetWT, 2000);
normRwOnsetWT = normalization(rwOnsetWT, 2000);
normRwOffsetWT = normalization(rwOffsetWT, 2000);

avgPelletWT = wtBehavior.avgPellet;
avgLickOnsetWT = wtBehavior.avgLickOnset;
avgLickOffsetWT = wtBehavior.avgLickOffset;
avgRwOnsetWT = wtBehavior.avgRwOnset;
avgRwOffsetWT = wtBehavior.avgRwOffset;

%% Feeding
errKO = smooth(std(pelletKO, 0, 1) ./ sqrt(size(pelletKO, 1)), 200);
errWT = smooth(std(pelletWT, 0, 1) ./ sqrt(size(pelletWT, 1)), 200);

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
subplot(3, 2, 1)
imagesc(normPelletKO)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(pelletKO)])
xlabel('Time (s)')
title('KO pellet')

subplot(3, 2, 2)
imagesc(normPelletWT)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(pelletWT)])
xlabel('Time (s)')
title('WT pellet')

subplot(3, 2, [3, 4])
shadedErrorBar([], smooth(mean(pelletKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(pelletWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(pelletKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('All trials')
set(gcf,'renderer','Painters')

errKO = smooth(std(avgPelletKO, 0, 1) ./ sqrt(size(avgPelletKO, 1)), 200);
errWT = smooth(std(avgPelletWT, 0, 1) ./ sqrt(size(avgPelletWT, 1)), 200);

subplot(3, 2, [5, 6])
shadedErrorBar([], smooth(mean(avgPelletKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(avgPelletWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(avgPelletKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('Per animal')
set(gcf,'renderer','Painters')
print('Feeding', '-dpng')

clear errKO
clear errWT

%% Licking
errKO = smooth(std(lickOnsetKO, 0, 1) ./ sqrt(size(lickOnsetKO, 1)), 200);
errWT = smooth(std(lickOnsetWT, 0, 1) ./ sqrt(size(lickOnsetWT, 1)), 200);

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
subplot(3, 2, 1)
imagesc(normLickOnsetKO)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(lickOnsetKO)])
xlabel('Time (s)')
title('KO lick onset')

subplot(3, 2, 2)
imagesc(normLickOnsetWT)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(lickOnsetWT)])
xlabel('Time (s)')
title('WT lick onset')

subplot(3, 2, [3, 4])
shadedErrorBar([], smooth(mean(lickOnsetKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(lickOnsetWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(lickOnsetKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('All trials')
set(gcf,'renderer','Painters')

errKO = smooth(std(avgLickOnsetKO, 0, 1) ./ sqrt(size(avgLickOnsetKO, 1)), 200);
errWT = smooth(std(avgLickOnsetWT, 0, 1) ./ sqrt(size(avgLickOnsetWT, 1)), 200);

subplot(3, 2, [5, 6])
shadedErrorBar([], smooth(mean(avgLickOnsetKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(avgLickOnsetWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(avgLickOnsetKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('Per animal')
set(gcf,'renderer','Painters')
print('Lick onset', '-dpng')

clear errKO
clear errWT

errKO = smooth(std(lickOffsetKO, 0, 1) ./ sqrt(size(lickOffsetKO, 1)), 200);
errWT = smooth(std(lickOffsetWT, 0, 1) ./ sqrt(size(lickOffsetWT, 1)), 200);

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
subplot(3, 2, 1)
imagesc(normLickOffsetKO)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(lickOffsetKO)])
xlabel('Time (s)')
title('KO lick offset')

subplot(3, 2, 2)
imagesc(normLickOffsetWT)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(lickOffsetWT)])
xlabel('Time (s)')
title('WT lick offset')

subplot(3, 2, [3, 4])
shadedErrorBar([], smooth(mean(lickOffsetKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(lickOffsetWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(lickOffsetKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('All trials')
set(gcf,'renderer','Painters')

errKO = smooth(std(avgLickOffsetKO, 0, 1) ./ sqrt(size(avgLickOffsetKO, 1)), 200);
errWT = smooth(std(avgLickOffsetWT, 0, 1) ./ sqrt(size(avgLickOffsetWT, 1)), 200);

subplot(3, 2, [5, 6])
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
shadedErrorBar([], smooth(mean(avgLickOffsetKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(avgLickOffsetWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(avgLickOffsetKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('Per animal')
set(gcf,'renderer','Painters')
print('Lick offset', '-dpng')

clear errKO
clear errWT

%% RW
errKO = smooth(std(rwOnsetKO, 0, 1) ./ sqrt(size(rwOnsetKO, 1)), 200);
errWT = smooth(std(rwOnsetWT, 0, 1) ./ sqrt(size(rwOnsetWT, 1)), 200);

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
subplot(3, 2, 1)
imagesc(normRwOnsetKO)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(rwOnsetKO)])
xlabel('Time (s)')
title('KO RW onset')

subplot(3, 2, 2)
imagesc(normRwOnsetWT)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(rwOnsetWT)])
xlabel('Time (s)')
title('WT RW onset')

subplot(3, 2, [3, 4])
shadedErrorBar([], smooth(mean(rwOnsetKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(rwOnsetWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(rwOnsetKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('All trials')
set(gcf,'renderer','Painters')

errKO = smooth(std(avgRwOnsetKO, 0, 1) ./ sqrt(size(avgRwOnsetKO, 1)), 200);
errWT = smooth(std(avgRwOnsetWT, 0, 1) ./ sqrt(size(avgRwOnsetWT, 1)), 200);

subplot(3, 2, [5, 6])
shadedErrorBar([], smooth(mean(avgRwOnsetKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(avgRwOnsetWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(avgRwOnsetKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('Per animal')
set(gcf,'renderer','Painters')
print('RW onset', '-dpng')

clear errKO
clear errWT

errKO = smooth(std(rwOffsetKO, 0, 1) ./ sqrt(size(rwOffsetKO, 1)), 200);
errWT = smooth(std(rwOffsetWT, 0, 1) ./ sqrt(size(rwOffsetWT, 1)), 200);

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
subplot(3, 2, 1)
imagesc(normRwOffsetKO)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(rwOffsetKO)])
xlabel('Time (s)')
title('KO RW offset')

subplot(3, 2, 2)
imagesc(normRwOffsetWT)
colormap(hot); caxis([0.5 1])
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(rwOffsetWT)])
xlabel('Time (s)')
title('WT RW offset')

subplot(3, 2, [3, 4])
shadedErrorBar([], smooth(mean(rwOffsetKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(rwOffsetWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(rwOffsetKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('All trials')
set(gcf,'renderer','Painters')

errKO = smooth(std(avgRwOffsetKO, 0, 1) ./ sqrt(size(avgRwOffsetKO, 1)), 200);
errWT = smooth(std(avgRwOffsetWT, 0, 1) ./ sqrt(size(avgRwOffsetWT, 1)), 200);

subplot(3, 2, [5, 6])
shadedErrorBar([], smooth(mean(avgRwOffsetKO), 200), errKO, 'lineProps', 'g')
ylabel(yAxisLabel)
hold on
shadedErrorBar([], smooth(mean(avgRwOffsetWT), 200), errWT, 'lineProps', 'b')
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xt = get(gca, 'xtick');
set(gca, 'XTick', xt, 'xticklabel', (xt - cutTime) / Fs)
xlim([0 length(avgRwOffsetKO)])
ylim([-.5 1.2])
xlabel('Time (s)')
title('Per animal')
set(gcf,'renderer','Painters')
print('RW offset', '-dpng')

end