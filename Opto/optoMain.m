function [shuffle, stim, stats] = optoMain()

% clean workspace and dir
clear; clc;

% select opto dir
selpath = uigetdir('C:\Users\Brandon Toth\Dropbox\BurgessLab_data\Brandon\0 Sleep recordings\0 analysis\');
cd(selpath);

% iterate through folders in dir
filedir = dir;
filedir = filedir(~ismember({filedir.name}, {'.', '..'}));
for i = 1:numel(filedir)
    
    currD = filedir(i).name; 
    cd(currD)          
    
    % print current dir
    fprintf(1, 'Now reading %s\n', currD);
    
    % loads files in dir and rename
    files = dir('*.mat'); 
    for j = 1:length(files)
        if contains(files(j).name, 'optoLabel', 'IgnoreCase', true)
            stimLabels = load(files(j).name);
            stimLabels = stimLabels.(string(fieldnames(stimLabels)));
        elseif contains(files(j).name, 'dark')
            shuffleLabels = load(files(j).name);
            shuffleLabels = shuffleLabels.(string(fieldnames(shuffleLabels)));
        else
            load(files(j).name);
        end
    end
    
    if exist('Opto', 'var')
        optoTTL = Opto;
    end

    % run the probability function for both stim and shuffled labels
    opf(stimLabels, optoTTL, 'stim');
    opf(shuffleLabels, optoTTL, 'shuffle');
    
    % clear variables that will get reused
    clear stimLabels shuffleLabels optoTTL
    
    cd('..') % go back to parent dir
end

% create structures for stim and shuffled data
filedir = dir('*.mat');
for i = 1:numel(filedir)
    load(filedir(i).name)

    if contains(filedir(i).name, 'stim')
        storeStim(i) = optoStruct;
    else
        storeShuffle(i) = optoStruct;
    end
end

% concatenate across shuffled data
fields = string(fieldnames(storeShuffle));
for i = 1:length(fields)
    getField = fields(i);
    
    if contains(getField, 'wakeStim') || contains(getField, 'nremStim') 
        shuffle.(getField) = rmmissing(vertcat(storeShuffle.(getField)));
    else
        shuffle.(getField) = rmmissing(horzcat(storeShuffle.(getField)));
    end
end

% concatenate across stim data
fields = string(fieldnames(storeStim));
for i = 1:length(fields)
    getField = fields(i);
    
    if contains(getField, 'wakeStim') || contains(getField, 'nremStim') 
        stim.(getField) = rmmissing(vertcat(storeStim.(getField)));
    else
        stim.(getField) = rmmissing(horzcat(storeStim.(getField)));
    end
end

%% stats and some analysis 
% AUC for shuffled data, wake stim
shuffleWakeAUC_wakeStim = trapz(shuffle.wakeStim_wakeProb(:, 60000:90000), 2);
shuffleNremAUC_wakeStim = trapz(shuffle.wakeStim_nremProb(:, 60000:90000), 2);
shuffleRemAUC_wakeStim = trapz(shuffle.wakeStim_remProb(:, 60000:90000), 2);
shuffleCatAUC_wakeStim = trapz(shuffle.wakeStim_catProb(:, 60000:90000), 2);
stats.wakeStim.shuffle = [shuffleWakeAUC_wakeStim, shuffleNremAUC_wakeStim, ...
    shuffleRemAUC_wakeStim, shuffleCatAUC_wakeStim];

% AUC for stim data, wake stim
stimWakeAUC_wakeStim = trapz(stim.wakeStim_wakeProb(:, 60000:90000), 2);
stimNremAUC_wakeStim = trapz(stim.wakeStim_nremProb(:, 60000:90000), 2);
stimRemAUC_wakeStim = trapz(stim.wakeStim_remProb(:, 60000:90000), 2);
stimCatAUC_wakeStim = trapz(stim.wakeStim_catProb(:, 60000:90000), 2);
stats.wakeStim.stim = [stimWakeAUC_wakeStim, stimNremAUC_wakeStim, ...
    stimRemAUC_wakeStim, stimCatAUC_wakeStim];

% ttests for wake
[stats.wakeStim.h_wake, stats.wakeStim.p_wake] = ...
    ttest(shuffleWakeAUC_wakeStim, stimWakeAUC_wakeStim);
[stats.wakeStim.h_nrem, stats.wakeStim.p_nrem] = ...
    ttest(shuffleNremAUC_wakeStim, stimNremAUC_wakeStim);
[stats.wakeStim.h_rem, stats.wakeStim.p_rem] = ...
    ttest(shuffleRemAUC_wakeStim, stimRemAUC_wakeStim);
[stats.wakeStim.h_cat, stats.wakeStim.p_cat] = ...
    ttest(shuffleCatAUC_wakeStim, stimCatAUC_wakeStim);

% AUC for shuffled data, nrem stim
shuffleWakeAUC_nremStim = trapz(shuffle.nremStim_wakeProb(:, 60000:90000), 2);
shuffleNremAUC_nremStim = trapz(shuffle.nremStim_nremProb(:, 60000:90000), 2);
shuffleRemAUC_nremStim = trapz(shuffle.nremStim_remProb(:, 60000:90000), 2);
shuffleCatAUC_nremStim = trapz(shuffle.nremStim_catProb(:, 60000:90000), 2);
stats.nremStim.shuffle = [shuffleWakeAUC_nremStim, shuffleNremAUC_nremStim, ...
    shuffleRemAUC_nremStim, shuffleCatAUC_nremStim];

% AUC for stim data, nrem stim
stimWakeAUC_nremStim = trapz(stim.nremStim_wakeProb(:, 60000:90000), 2);
stimNremAUC_nremStim = trapz(stim.nremStim_nremProb(:, 60000:90000), 2);
stimRemAUC_nremStim = trapz(stim.nremStim_remProb(:, 60000:90000), 2);
stimCatAUC_nremStim = trapz(stim.nremStim_catProb(:, 60000:90000), 2);
stats.nremStim.stim = [stimWakeAUC_nremStim, stimNremAUC_nremStim, ...
    stimRemAUC_nremStim, stimCatAUC_nremStim];

% ttests for nrem
[stats.nremStim.h_wake, stats.nremStim.p_wake] = ...
    ttest(shuffleWakeAUC_nremStim, stimWakeAUC_nremStim);
[stats.nremStim.h_nrem, stats.nremStim.p_nrem] = ...
    ttest(shuffleNremAUC_nremStim, stimNremAUC_nremStim);
[stats.nremStim.h_rem, stats.nremStim.p_rem] = ...
    ttest(shuffleRemAUC_nremStim, stimRemAUC_nremStim);
[stats.nremStim.h_cat, stats.nremStim.p_cat] = ...
    ttest(shuffleCatAUC_nremStim, stimCatAUC_nremStim);

%% save everything to current dir
% save data to current dir
save(horzcat(selpath, '\', 'stim'), 'stim');
save(horzcat(selpath, '\', 'shuffle'), 'shuffle');
save(horzcat(selpath, '\', 'stats'), 'stats');

clc, fprintf('Done running analysis. \n'), clc;
end