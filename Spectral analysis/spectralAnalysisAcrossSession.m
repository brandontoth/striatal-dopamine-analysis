function [exp, bl] = spectralAnalysisAcrossSession(fileDir, pattern)

% Coder: Brandon Toth

% Date: November 2022

% INPUTS: 
%   - fileDir: path to directory where all subdirectories of sleep data is being stored
%   - labels: scored AccuSleep labels file
%   - pattern: string used to distinguish exp group from bl group. Should
%              reflect the file name for exp groups
%
% OUTPUTS:
%   - exp: structure for experimental group mice
%   - bl: structure for baseline group mice
%
% PURPOSE:
%   Script designed to pull sleep data from subdirectories, perform
%   spectral analysis across WAKE, NREM, pREM, and REM states, then
%   concatenate data across mice and across sessions. Returns two
%   structures for the exp and bl conditions as well as plots for all
%   states
tic

cd(fileDir)

D = dir;
D = D(~ismember({D.name}, {'.', '..'}));
for k = 1:numel(D)
    currD = D(k).name; % get the current subdirectory name
    cd(currD)          % change the directory
    
    fprintf(1, 'Now reading %s\n', currD);
    
    tf = contains(currD, pattern); % bool to sort out exp and bl groups
    
    files = dir('*.mat');          % load all .mat files in dir
    for i = 1:length(files)
        if contains(files(i).name, "EEG") || contains(files(i).name, "labels", "IgnoreCase", true)
            load(files(i).name)
        end
    end

    if exist("adjustedLabels", "var")
        labels = adjustedLabels;
    end

    % filter EEG to clean up the signals a bit
    highPass = designfilt('highpassiir', 'FilterOrder', 2, ...
                'PassbandFrequency', 1, 'SampleRate', 200);

    downEEG = resample(EEG, 200, 1000);

    filtEEG = filtfilt(highPass, downEEG);
    
    % get state locations
    states = subsample(labels, downEEG, 5, 200);
    
    % get power spectrum per state and sort into relevant group based on
    % file name
    if tf == 1
        [exp.wakeSpects(:, k), exp.nremSpects(:, k), exp.remSpects(:, k), exp.catSpects(:, k)] ...
            = getPowerAcrossStates(states, filtEEG, 200);
    else
        [bl.wakeSpects(:, k), bl.nremSpects(:, k), bl.remSpects(:, k), bl.catSpects(:, k)] ...
            = getPowerAcrossStates(states, filtEEG, 200);
    end

    cd('..') % return to the parent directory
end

%% Clean up
% remove zeros from all arrays
exp.wakeSpects(:, ~any(exp.wakeSpects, 1)) = [];
bl.wakeSpects(:, ~any(bl.wakeSpects, 1)) = [];

exp.nremSpects(:, ~any(exp.nremSpects, 1)) = [];
bl.nremSpects(:, ~any(bl.nremSpects, 1)) = [];

exp.remSpects(:, ~any(exp.remSpects, 1)) = [];
bl.remSpects(:, ~any(bl.remSpects, 1)) = [];

exp.catSpects(:, ~any(exp.catSpects, 1)) = [];
bl.catSpects(:, ~any(bl.catSpects, 1)) = [];

% calc SEM
exp.wake_sem = std(exp.wakeSpects, 0, 2) ./ sqrt(size(exp.wakeSpects, 2));
exp.nrem_sem = std(exp.nremSpects, 0, 2) ./ sqrt(size(exp.nremSpects, 2));
exp.rem_sem = std(exp.remSpects, 0, 2) ./ sqrt(size(exp.remSpects, 2));
exp.cat_sem = std(exp.catSpects, 0, 2) ./ sqrt(size(exp.catSpects, 2));

bl.wake_sem = std(bl.wakeSpects, 0, 2) ./ sqrt(size(bl.wakeSpects, 2));
bl.nrem_sem = std(bl.nremSpects, 0, 2) ./ sqrt(size(bl.nremSpects, 2));
bl.rem_sem = std(bl.remSpects, 0, 2) ./ sqrt(size(bl.remSpects, 2));
bl.cat_sem = std(bl.catSpects, 0, 2) ./ sqrt(size(bl.catSpects, 2));

% calc AUC
exp.wake_delta = trapz(exp.wakeSpects(1:8, :), 1);
exp.wake_theta = trapz(exp.wakeSpects(10:18, :), 1);
exp.wake_alpha = trapz(exp.wakeSpects(20:30, :), 1);
exp.nrem_delta = trapz(exp.nremSpects(1:8, :), 1);
exp.nrem_theta = trapz(exp.nremSpects(10:18, :), 1);
exp.nrem_alpha = trapz(exp.nremSpects(20:30, :), 1);
exp.rem_delta = trapz(exp.remSpects(1:8, :), 1);
exp.rem_theta = trapz(exp.remSpects(10:18, :), 1);
exp.rem_alpha = trapz(exp.remSpects(20:30, :), 1);
exp.cat_delta = trapz(exp.catSpects(1:8, :), 1);
exp.cat_theta = trapz(exp.catSpects(10:18, :), 1);
exp.cat_alpha = trapz(exp.catSpects(20:30, :), 1);

bl.wake_delta = trapz(bl.wakeSpects(1:8, :), 1);
bl.wake_theta = trapz(bl.wakeSpects(10:18, :), 1);
bl.wake_alpha = trapz(bl.wakeSpects(20:30, :), 1);
bl.nrem_delta = trapz(bl.nremSpects(1:8, :), 1);
bl.nrem_theta = trapz(bl.nremSpects(10:18, :), 1);
bl.nrem_alpha = trapz(bl.nremSpects(20:30, :), 1);
bl.rem_delta = trapz(bl.remSpects(1:8, :), 1);
bl.rem_theta = trapz(bl.remSpects(10:18, :), 1);
bl.rem_alpha = trapz(bl.remSpects(20:30, :), 1);
bl.cat_delta = trapz(bl.catSpects(1:8, :), 1);
bl.cat_theta = trapz(bl.catSpects(10:18, :), 1);
bl.cat_alpha = trapz(bl.catSpects(20:30, :), 1);

%% plotting
bins = 0:.5:20;
XX = ([bins, flip(bins)]);
labels = {'Delta'; 'Theta'; 'Alpha'};

figure;
subplot(1, 2, 1)
plot(bins, mean(exp.wakeSpects, 2), 'color', 'g', 'LineWidth', 2)
ylabel('Relative Wake Power')
xlabel('Frequency (Hz)')
title('Wake summary')
hold on
plot(bins, mean(bl.wakeSpects, 2), 'color', 'b', 'LineWidth', 2)
ylim([0 1])
%wake
YY = [(mean(exp.wakeSpects, 2) + exp.wake_sem), flip(mean(exp.wakeSpects, 2) - exp.wake_sem)];
YY = reshape(YY, [1, (length(exp.wakeSpects)) * 2]);
shade = fill(XX, YY, 'g');
set(shade, 'facealpha', .15, 'edgecolor', 'none')
YY = [(mean(bl.wakeSpects, 2) + bl.wake_sem), flip(mean(bl.wakeSpects, 2) - bl.wake_sem)];
YY = reshape(YY, [1, (length(bl.wakeSpects)) * 2]);
shade = fill(XX, YY, 'b');
set(shade, 'facealpha', .15, 'edgecolor', 'none')
legend('OX KO', 'WT')

subplot(1,2,2)
wake_bar = [mean(bl.wake_delta), mean(exp.wake_delta); mean(bl.wake_theta), ... 
    mean(exp.wake_theta); mean(bl.wake_alpha), mean(exp.wake_alpha)];
b = bar(wake_bar, 1);
b(1).FaceColor = 'b';
b(2).FaceColor = 'g';
set(gca, 'xticklabel', labels)
ylabel('Wake AUC')

figure;
subplot(1, 2, 1)
plot(bins, mean(exp.nremSpects, 2), 'color', 'g', 'LineWidth', 2)
ylabel('Relative NREM Power')
xlabel('Frequency (Hz)')
title('NREM summary')
hold on
plot(bins,mean(bl.nremSpects, 2), 'color', 'b', 'LineWidth', 2)
ylim([0 1])
%nrem
YY = [(mean(exp.nremSpects, 2) + exp.nrem_sem), flip(mean(exp.nremSpects, 2) - exp.nrem_sem)];
YY = reshape(YY, [1, (length(exp.nremSpects')) * 2]);
shade = fill(XX, YY, 'g');
set(shade, 'facealpha', .15, 'edgecolor', 'none')
YY = [(mean(bl.nremSpects, 2) + bl.nrem_sem), flip(mean(bl.nremSpects, 2) - bl.nrem_sem)];
YY = reshape(YY, [1, (length(bl.nremSpects)) * 2]);
shade = fill(XX, YY, 'b');
set(shade, 'facealpha', .15, 'edgecolor', 'none')
legend('OX KO', 'WT')

subplot(1, 2, 2)
nrem_bar = [mean(bl.nrem_delta), mean(exp.nrem_delta); mean(bl.nrem_theta), ... 
    mean(exp.nrem_theta); mean(bl.nrem_alpha), mean(exp.nrem_alpha)];
b = bar(nrem_bar, 1);
b(1).FaceColor = 'b';
b(2).FaceColor = 'g';
set(gca, 'xticklabel', labels)
ylabel('NREM AUC')

figure;
subplot(1, 2, 1)
plot(bins, mean(exp.remSpects, 2), 'color', 'g', 'LineWidth', 2)
ylabel('Relative REM Power')
xlabel('Frequency (Hz)')
title('REM summary')
hold on
plot(bins, mean(bl.remSpects, 2), 'color', 'b', 'LineWidth', 2)
ylim([0 1])
%rem
YY = [(mean(exp.remSpects, 2) + exp.rem_sem), flip(mean(exp.remSpects, 2) - exp.rem_sem)];
YY = reshape(YY, [1, (length(exp.remSpects)) * 2]);
shade = fill(XX, YY, 'g');
set(shade, 'facealpha', .15, 'edgecolor', 'none')
YY = [(mean(bl.remSpects, 2) + bl.rem_sem), flip(mean(bl.remSpects, 2) - bl.rem_sem)];
YY = reshape(YY, [1, (length(bl.remSpects)) * 2]);
shade = fill(XX, YY, 'b');
set(shade, 'facealpha', .15, 'edgecolor', 'none')
legend('OX KO', 'WT')

subplot(1, 2, 2)
rem_bar = [mean(bl.rem_delta), mean(exp.rem_delta); mean(bl.rem_theta), ... 
    mean(exp.rem_theta); mean(bl.rem_alpha), mean(exp.rem_alpha)];
b = bar(rem_bar, 1);
b(1).FaceColor = 'b';
b(2).FaceColor = 'g';
set(gca, 'xticklabel', labels)
ylabel('REM AUC')

figure;
subplot(1, 2, 1)
plot(bins, mean(exp.catSpects, 2), 'color', 'g', 'LineWidth', 2)
ylabel('Relative CAT Power')
xlabel('Frequency (Hz)')
title('CAT summary')
hold on
plot(bins, mean(exp.remSpects, 2), 'color', 'r', 'LineWidth', 2)
ylim([0 1])
%prem
YY = [(mean(exp.catSpects, 2) + exp.cat_sem), flip(mean(exp.catSpects, 2) - exp.cat_sem)];
YY = reshape(YY, [1, (length(exp.catSpects)) * 2]);
shade = fill(XX, YY, 'g');
set(shade, 'facealpha', .15, 'edgecolor', 'none')
YY = [(mean(exp.remSpects, 2) + exp.rem_sem), flip(mean(exp.remSpects, 2) - exp.rem_sem)];
YY = reshape(YY, [1, (length(exp.remSpects)) * 2]);
shade = fill(XX, YY, 'r');
set(shade, 'facealpha', .15, 'edgecolor', 'none')
legend('Cataplexy', 'REM')

subplot(1, 2, 2)
cat_bar = [mean(exp.rem_delta), mean(exp.cat_delta); mean(exp.rem_theta), ... 
    mean(exp.cat_theta); mean(exp.rem_alpha), mean(exp.cat_alpha)];
b = bar(cat_bar, 1);
b(1).FaceColor = 'r';
b(2).FaceColor = 'g';
set(gca, 'xticklabel', labels)

toc

end