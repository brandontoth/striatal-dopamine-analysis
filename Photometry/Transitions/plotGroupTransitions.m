function [] = plotGroupTransitions(transitions, ratios, cutTime, color)

% plot all relevant transitions as well as heatmaps and bar graphs for mean
% DFF per state, then save everything to a structure for later use
yAxisLabelLeft = '\DeltaF/F (z-score)';
yAxisLabelRight = {'\theta power'};
smoothingFactor = 100;

nremToRemTransition = transitions.nremToRem;
remToWakeTransition = transitions.remToWake;
wakeToNremTransition = transitions.wakeToNrem;
nremToWakeTransition = transitions.nremToWake;
if isfield(transitions, 'wakeToCat')
    wakeToCatTransition = transitions.wakeToCat;
    catToWakeTransition = transitions.catToWake;
    
    normWtC = normalization(sortTimecourseArray(wakeToCatTransition), 800);
    normCtW = normalization(sortTimecourseArray(catToWakeTransition), 800);
end

normNtR = normalization(sortTimecourseArray(nremToRemTransition), 800);
normRtW = normalization(sortTimecourseArray(remToWakeTransition), 800);
normWtN = normalization(sortTimecourseArray(wakeToNremTransition), 800);
normNtW = normalization(sortTimecourseArray(nremToWakeTransition), 800);

avgNremToRemTransition = transitions.avgNremToRem;
avgRemToWakeTransition = transitions.avgRemToWake;
avgWakeToNremTransition = transitions.avgWakeToNrem;
avgNremToWakeTransition = transitions.avgNremToWake;
if isfield(transitions, 'wakeToCat')
    avgWakeToCatTransition = transitions.avgWakeToCat;
    avgCatToWakeTransition = transitions.avgCatToWake;
end

nremToRemRatio = ratios.nremToRem;
remToWakeRatio = ratios.remToWake;
wakeToNremRatio = ratios.wakeToNrem;
nremToWakeRatio = ratios.nremToWake;
if isfield(ratios, 'wakeToCat')
    wakeToCatRatio = ratios.wakeToCat;
    catToWakeRatio = ratios.catToWake;
end

avgNremToRemRatio = ratios.avgNremToRem;
avgRemToWakeRatio = ratios.avgRemToWake;
avgWakeToNremRatio = ratios.avgWakeToNrem;
avgNremToWakeRatio = ratios.avgNremToWake;
if isfield(ratios, 'wakeToCat')
    avgWakeToCatRatio = ratios.avgWakeToCat;
    avgCatToWakeRatio = ratios.avgCatToWake;
end

% % NREM to REM
transitionErr = smooth(std(nremToRemTransition, 0, 1) ./ sqrt(size(nremToRemTransition, 1)), smoothingFactor);

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
subplot(3, 1, 1)
imagesc(normNtR)
colormap(hot); caxis([.2 1])
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(nremToRemTransition)])
xlabel('Time (s)')
title('NREM to REM transition')
set(gca, 'Ticklength', [0 0]); box off

subplot(3, 1, 2)
yyaxis left
ax = gca;
ax.YColor = 'k';
shadedErrorBar(1:length(nremToRemTransition), smooth(mean(nremToRemTransition), smoothingFactor), ...
    transitionErr, 'lineprops', color, 'LineWidth', 3)
% ylim([-.5 .5])
ylabel(yAxisLabelLeft)
yyaxis right
ax = gca;
ax.YColor = 'k';
plot(smooth(mean(nremToRemRatio), smoothingFactor), '--r')
ylabel(yAxisLabelRight)
hold on
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(nremToRemTransition)])
xlabel('Time (s)')
title('All transitions')
set(gca, 'Ticklength', [0 0]); box off

transitionErr = smooth(std(avgNremToRemTransition, 0, 1) ./ sqrt(size(avgNremToRemTransition, 1)), smoothingFactor);

subplot(3, 1, 3)
yyaxis left
ax = gca;
ax.YColor = 'k';
shadedErrorBar(1:length(nremToRemTransition), smooth(mean(avgNremToRemTransition), smoothingFactor), ...
    transitionErr, 'lineprops', color)
% ylim([-.5 .5])
ylabel(yAxisLabelLeft)
yyaxis right
ax = gca;
ax.YColor = 'k';
plot(smooth(mean(avgNremToRemRatio), smoothingFactor), '--r')
ylabel(yAxisLabelRight)
hold on
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(avgNremToRemTransition)])
xlabel('Time (s)')
title('Per animal transitions')
set(gcf,'renderer','Painters')
set(gca, 'Ticklength', [0 0]); box off
print('NtoR', '-dpdf')

clear transitionErr

% REM to wake
transitionErr = smooth(std(remToWakeTransition, 0, 1) ./ sqrt(size(remToWakeTransition, 1)), smoothingFactor);

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
subplot(3, 1, 1)
imagesc(normRtW)
colormap(hot); caxis([.2 1])
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(remToWakeTransition)])
xlabel('Time (s)')
title('REM to wake transition')
set(gca, 'Ticklength', [0 0]); box off

subplot(3, 1, 2)
yyaxis left
ax = gca;
ax.YColor = 'k';
shadedErrorBar([], smooth(mean(remToWakeTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
% ylim([-1 .5])
ylabel(yAxisLabelLeft)
yyaxis right
ax = gca;
ax.YColor = 'k';
plot(smooth(mean(remToWakeRatio), smoothingFactor), '--r')
ylabel(yAxisLabelRight)
hold on
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(remToWakeTransition)])
xlabel('Time (s)')
title('All transitions')
set(gca, 'Ticklength', [0 0]); box off

transitionErr = smooth(std(avgRemToWakeTransition, 0, 1) ./ sqrt(size(avgRemToWakeTransition, 1)), smoothingFactor);

subplot(3, 1, 3)
yyaxis left
ax = gca;
ax.YColor = 'k';
shadedErrorBar([], smooth(mean(avgRemToWakeTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
% ylim([-1 .5])
ylabel(yAxisLabelLeft)
yyaxis right
ax = gca;
ax.YColor = 'k';
plot(smooth(mean(avgRemToWakeRatio), smoothingFactor), '--r')
ylabel(yAxisLabelRight)
hold on
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(avgRemToWakeTransition)])
xlabel('Time (s)')
title('Per animal transitions')
set(gcf,'renderer','Painters')
set(gca, 'Ticklength', [0 0]); box off
print('RtoW', '-dpdf')

clear transitionErr

% Wake to NREM
transitionErr = smooth(std(wakeToNremTransition, 0, 1) ./ sqrt(size(wakeToNremTransition, 1)), smoothingFactor);

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
subplot(3, 1, 1)
imagesc(normWtN)
colormap(hot); caxis([.2 1])
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(wakeToNremTransition)])
xlabel('Time (s)')
title('Wake to NREM transition')
set(gca, 'Ticklength', [0 0]); box off

subplot(3, 1, 2)
yyaxis left
ax = gca;
ax.YColor = 'k';
shadedErrorBar([], smooth(mean(wakeToNremTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
% ylim([-.3 .3])
ylabel(yAxisLabelLeft)
yyaxis right
ax = gca;
ax.YColor = 'k';
plot(smooth(mean(wakeToNremRatio), smoothingFactor), '--r')
ylabel(yAxisLabelRight)
hold on
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(wakeToNremTransition)])
xlabel('Time (s)')
title('All transitions')
set(gca, 'Ticklength', [0 0]); box off

transitionErr = smooth(std(avgWakeToNremTransition, 0, 1) ./ sqrt(size(avgWakeToNremTransition, 1)), smoothingFactor);

subplot(3, 1, 3)
yyaxis left
ax = gca;
ax.YColor = 'k';
shadedErrorBar([], smooth(mean(avgWakeToNremTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
% ylim([-.3 .3])
ylabel(yAxisLabelLeft)
yyaxis right
ax = gca;
ax.YColor = 'k';
plot(smooth(mean(avgWakeToNremRatio), smoothingFactor), '--r')
ylabel(yAxisLabelRight)
hold on
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(avgWakeToNremTransition)])
xlabel('Time (s)')
title('Per animal transitions')
set(gcf,'renderer','Painters')
set(gca, 'Ticklength', [0 0]); box off
print('WtoN', '-dpdf')

clear transitionErr

% NREM to wake
transitionErr = smooth(std(nremToWakeTransition, 0, 1) ./ sqrt(size(nremToWakeTransition, 1)), smoothingFactor);

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
subplot(3, 1, 1)
imagesc(normNtW)
colormap(hot); caxis([.2 1])
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(nremToWakeTransition)])
xlabel('Time (s)')
title('NREM to wake transition')
set(gca, 'Ticklength', [0 0]); box off

subplot(3, 1, 2)
yyaxis left
ax = gca;
ax.YColor = 'k';
shadedErrorBar([], smooth(mean(nremToWakeTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
% ylim([-.4 .6])
ylabel(yAxisLabelLeft)
yyaxis right
ax = gca;
ax.YColor = 'k';
plot(smooth(mean(nremToWakeRatio), smoothingFactor), '--r')
ylabel(yAxisLabelRight)
hold on
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(nremToWakeTransition)])
xlabel('Time (s)')
title('All transitions')
set(gca, 'Ticklength', [0 0]); box off

transitionErr = smooth(std(avgNremToWakeTransition, 0, 1) ./ sqrt(size(avgNremToWakeTransition, 1)), smoothingFactor);

subplot(3, 1, 3)
yyaxis left
ax = gca;
ax.YColor = 'k';
shadedErrorBar([], smooth(mean(avgNremToWakeTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
% ylim([-.4 .6])
ylabel(yAxisLabelLeft)
yyaxis right
ax = gca;
ax.YColor = 'k';
plot(smooth(mean(avgNremToWakeRatio), smoothingFactor), '--r')
ylabel(yAxisLabelRight)
hold on
xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
xticks([0 3001 6001 9001 12001])
xticklabels({'-30','-15','0','15','30'})
xlim([0 length(avgNremToWakeTransition)])
xlabel('Time (s)')
title('Per animal transitions')
set(gcf,'renderer','Painters')
set(gca, 'Ticklength', [0 0]); box off
print('NtoW', '-dpdf')

clear transitionErr

% if we have cataplexy, make some extra figs
if isfield(transitions, 'wakeToCat')
    % Wake to CAT

    transitionErr = smooth(std(wakeToCatTransition, 0, 1) ./ sqrt(size(wakeToCatTransition, 1)), smoothingFactor);

    figure
    set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
    subplot(3, 1, 1)
    imagesc(normWtC)
    colormap(hot); caxis([.2 1]);
    xticks([0 3001 6001 9001 12001])
    xticklabels({'-30','-15','0','15','30'})
    xlim([0 length(wakeToCatTransition)])
    xlabel('Time (s)')
    title('Wake to CAT transition')
    set(gca, 'Ticklength', [0 0]); box off

    subplot(3, 1, 2)
    yyaxis left
    ax = gca;
    ax.YColor = 'k';
    shadedErrorBar([], smooth(mean(wakeToCatTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
%     ylim([-.5 1])
    ylabel(yAxisLabelLeft)
    yyaxis right
    ax = gca;
    ax.YColor = 'k';
    plot(smooth(mean(wakeToCatRatio), smoothingFactor), '--r')
    ylabel(yAxisLabelRight)
    hold on
    xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
    xticks([0 3001 6001 9001 12001])
    xticklabels({'-30','-15','0','15','30'})
    xlim([0 length(wakeToCatTransition)])
    xlabel('Time (s)')
    title('All transitions')
    set(gca, 'Ticklength', [0 0]); box off

    transitionErr = smooth(std(avgWakeToCatTransition, 0, 1) ./ sqrt(size(avgWakeToCatTransition, 1)), smoothingFactor);

    subplot(3, 1, 3)
    yyaxis left
    ax = gca;
    ax.YColor = 'k';
    shadedErrorBar([], smooth(mean(avgWakeToCatTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
%     ylim([-.5 1])
    ylabel(yAxisLabelLeft)
    yyaxis right
    ax = gca;
    ax.YColor = 'k';
    plot(smooth(mean(avgWakeToCatRatio), smoothingFactor), '--r')
    ylabel(yAxisLabelRight)
    hold on
    xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
    xticks([0 3001 6001 9001 12001])
    xticklabels({'-30','-15','0','15','30'})
    xlim([0 length(avgWakeToCatTransition)])
    xlabel('Time (s)')
    title('Per animal transitions')
    set(gcf,'renderer','Painters')
    set(gca, 'Ticklength', [0 0]); box off
    print('WtoC', '-dpdf')

    clear transitionErr
    
    % CAT to wake

    transitionErr = smooth(std(catToWakeTransition, 0, 1) ./ sqrt(size(catToWakeTransition, 1)), smoothingFactor);
    
    figure
    set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 .3 .8])
    subplot(3, 1, 1)
    imagesc(normCtW)
    colormap(hot); caxis([.2 1])
    xticks([0 3001 6001 9001 12001])
    xticklabels({'-30','-15','0','15','30'})
    xlim([0 length(catToWakeTransition)])
    xlabel('Time (s)')
    title('CAT to wake transition')
    set(gca, 'Ticklength', [0 0]); box off
    
    subplot(3, 1, 2)
    yyaxis left
    ax = gca;
    ax.YColor = 'k';
    shadedErrorBar([], smooth(mean(catToWakeTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
%     ylim([-.8 .8])
    ylabel(yAxisLabelLeft)
    yyaxis right
    ax = gca;
    ax.YColor = 'k';
    plot(smooth(mean(catToWakeRatio), smoothingFactor), '--r')
    ylabel(yAxisLabelRight)
    hold on
    xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
    xticks([0 3001 6001 9001 12001])
    xticklabels({'-30','-15','0','15','30'})
    xlim([0 length(catToWakeTransition)])
    xlabel('Time (s)')
    title('All transitions')
    set(gca, 'Ticklength', [0 0]); box off

    transitionErr = smooth(std(avgCatToWakeTransition, 0, 1) ./ sqrt(size(avgCatToWakeTransition, 1)), smoothingFactor);

    subplot(3, 1, 3)
    yyaxis left
    ax = gca;
    ax.YColor = 'k';
    shadedErrorBar([], smooth(mean(avgCatToWakeTransition), smoothingFactor), transitionErr, 'transparent', 0, 'lineprops', color)
%     ylim([-.8 .8])
    ylabel(yAxisLabelLeft)
    yyaxis right
    ax = gca;
    ax.YColor = 'k';
    plot(smooth(mean(avgCatToWakeRatio), smoothingFactor), '--r')
    ylabel(yAxisLabelRight)
    hold on
    xline(cutTime, 'Color','red','LineStyle','--', 'LineWidth', 2);
    xticks([0 3001 6001 9001 12001])
    xticklabels({'-30','-15','0','15','30'})
    xlim([0 length(avgCatToWakeTransition)])
    xlabel('Time (s)')
    title('Per animal transitions')
    set(gcf,'renderer','Painters')
    set(gca, 'Ticklength', [0 0]); box off
    print('CtoW', '-dpdf')

    clear transitionErr
end

end