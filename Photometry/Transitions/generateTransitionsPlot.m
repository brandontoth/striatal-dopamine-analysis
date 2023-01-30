%% some constants
clear; close all; clc

epochLength = 5;
Fs = 1000;
downFs = 200;
cutTime = 30 * downFs;
pattern = 'KO';

%% navigate to desired dir
selpath = uigetdir('C:\Users\Brandon Toth\Dropbox\BurgessLab_data');
filedir = selpath;
cd(filedir);

D = dir;
D = D(~ismember({D.name}, {'.', '..'}));

%% load necessary data
j = 1;
for k = 1:numel(D)
    currD = D(k).name; % get the current subdirectory name
    cd(currD)          % change the directory
    
    fprintf(1, 'Now reading %s\n', currD);
     
    tf = contains(currD, pattern); % bool to sort out exp and bl groups
    
    files = dir('*.mat');          % load all .mat files in dir
    for i = 1:length(files)
        load(files(i).name);
    end

    if exist('zPhotoSyncRight', 'var')
        photoSignal = zPhotoSyncRight;
    elseif exist('zPhotoSyncLeft', 'var')
        photoSignal = zPhotoSyncLeft;
    elseif exist('photoSyncLeft', 'var')
        photoSignal = photoSyncLeft;
    elseif exist('photoSyncRight', 'var')
        photoSignal = photoSyncRight;
    end

    photoSignal = baselineCorrection(photoSignal);

    downEEG = resample(EEG, downFs, Fs);
    downFP = resample(photoSignal, downFs, Fs);

    %get relevant physiological data
    behavioralData = getBehavioralData(downFP, Food, RW, Lick);
    
    % subsample all transitions
    if tf == 1
        ratio = thetaDeltaRatio(adjustedLabels, downEEG, epochLength, downFs);
        transitions = subsample(adjustedLabels, downFP, epochLength, downFs);
    else
        ratio = thetaDeltaRatio(labels, downEEG, epochLength, downFs);
        transitions = subsample(labels, downFP, epochLength, downFs);
    end
   
    % sort into relevant groups
    if tf == 1
        ratioKO(k) = ratio;
        storeKO(k) = transitions;
        behaviorKO(k) = behavioralData;
    else
        ratioWT(k) = ratio;
        storeWT(k) = transitions;
        behaviorWT(k) = behavioralData;
    end

    clear photoSignal zPhotoSyncRight zPhotoSyncLeft photoSyncLeft photoSyncRight filtSig labels adjustedLabels EEG

    cd('..') % return to the parent directory
end

%% clean up structures
    
transitionFields = string(fieldnames(storeKO));
ratioFields = string(fieldnames(ratioKO));
behavioralFields = string(fieldnames(behaviorKO));

for i = 1:length(behavioralFields)
    getBehaviorField = behavioralFields(i);
    koBehavior.(getBehaviorField) = vertcat(behaviorKO.(behavioralFields(i)));
    wtBehavior.(getBehaviorField) = vertcat(behaviorWT.(behavioralFields(i)));
end

for i = 1:length(transitionFields)
    getFieldTransition = transitionFields(i);
    koTransitions.(getFieldTransition) = vertcat(storeKO.(transitionFields(i)));
end

for i = 1:length(ratioFields)
    getFieldRatio = ratioFields(i);
    koRatios.(getFieldRatio) = vertcat(ratioKO.(ratioFields(i)));
end

transitionFields = string(fieldnames(storeWT));
ratioFields = string(fieldnames(ratioWT));

for i = 1:length(transitionFields)
    getFieldTransition = transitionFields(i);
    wtTransitions.(getFieldTransition) = vertcat(storeWT.(transitionFields(i)));
end

for i = 1:length(ratioFields)
    getFieldRatio = ratioFields(i);
    wtRatios.(getFieldRatio) = vertcat(ratioWT.(ratioFields(i)));
end

%% plot everything

plotGroupTransitions(koTransitions, koRatios, cutTime, downFs, 'g')
overlayGroupBehavior(koBehavior, wtBehavior, 5000, 1000)
