function results = subsample(labels, photoSignal, epochLength, Fs)

% Constants used in code, do not change unless necessary
NREM_LABEL = 3; % labels for Accusleep purposes
REM_LABEL = 1;
WAKE_LABEL = 2;
CAT_LABEL = 4;
results = struct; % structure to hold stuff

% if there are cataplexy episodes, locate them
if sum(ismember(labels, 4)) > 0
    catOnsets = epochLength * (find(labels(1:end - 1) ~= CAT_LABEL & labels(2:end) == CAT_LABEL));
    catOffsets = epochLength * (find(labels(1:end - 1) == CAT_LABEL & labels(2:end) ~= CAT_LABEL));

    catLOC = [catOnsets catOffsets];
    catLength = catLOC(:, 2) - catLOC(:, 1);

    catOnsets = catOnsets(catLength >= 10) * Fs;
    catOffsets = catOffsets(catLength >= 10) * Fs;
else
    catOnsets = [];
    catOffsets = [];
end

%% find REM locations
remOnsets = epochLength * (find(labels(1:end - 1) ~= REM_LABEL & labels(2:end) == REM_LABEL));
remOffsets = epochLength * (find(labels(1:end - 1) == REM_LABEL & labels(2:end) ~= REM_LABEL));

if labels(1) == REM_LABEL
    remOffsets = remOffsets(2:end);
end

if labels(end) == REM_LABEL
    remOnsets = remOnsets(1:end - 1);
end

remLOC = [remOnsets remOffsets];
remLength = remLOC(:, 2) - remLOC(:, 1);
remOnsets = remOnsets(remLength >= 30);
remOffsets = remOffsets(remLength >= 30);

%% find NREM locations
nremOnsets = epochLength * (find(labels(1:end - 1) ~= NREM_LABEL & labels(2:end) == NREM_LABEL));
nremOffsets = epochLength * (find(labels(1:end - 1) == NREM_LABEL & labels(2:end) ~= NREM_LABEL));

if labels(1) == NREM_LABEL
    beginning = 1;
    nremOnsets = [beginning; nremOnsets];
end

if labels(end) == NREM_LABEL
    nremOffsets = [nremOffsets; epochLength * length(labels)];
end
nremLOC = [nremOnsets nremOffsets];
nremLength = nremLOC(:, 2) - nremLOC(:, 1);
nremOnsets = nremOnsets(nremLength >= 30);
nremOffsets = nremOffsets(nremLength >= 30);

%% find WAKE locations
wakeOnsets = epochLength * (find(labels(1:end - 1) ~= WAKE_LABEL & labels(2:end) == WAKE_LABEL));
wakeOffsets = epochLength * (find(labels(1:end - 1) == WAKE_LABEL & labels(2:end) ~= WAKE_LABEL));

if labels(1) == WAKE_LABEL
    beginning = 1;
    wakeOnsets = [beginning; wakeOnsets];
end

if labels(end) == WAKE_LABEL
    wakeOffsets = [wakeOffsets; epochLength * length(labels)];
end

wakeLOC = [wakeOnsets wakeOffsets];
wakeLength = wakeLOC(:, 2) - wakeLOC(:, 1);

refWakeToNremOnsets = wakeOnsets(wakeLength >= 30);
refWakeToNremOffsets = wakeOffsets(wakeLength >= 30);

refWakeToRemOnsets = wakeOnsets(wakeLength >= 30);

%% get transitions
if ~isempty(remOnsets)
    nremToRemIdx = intersect(nremOffsets, remOnsets) * Fs;
    remToWakeIdx = intersect(remOffsets, refWakeToRemOnsets) * Fs;
    nremToRem = cutAroundEvent(nremToRemIdx, 30 * Fs, photoSignal);
    if ~isempty(remToWakeIdx)
        remToWake = cutAroundEvent(remToWakeIdx, 30 * Fs, photoSignal);
    else
        remToWake = [];
    end
end

wakeToNremIdx = intersect(refWakeToNremOffsets, nremOnsets) * Fs;
nremToWakeIdx = intersect(nremOffsets, refWakeToNremOnsets) * Fs;
wakeToNrem = cutAroundEvent(wakeToNremIdx, 30 * Fs, photoSignal);
nremToWake = cutAroundEvent(nremToWakeIdx, 30 * Fs, photoSignal);

if exist('catLOC', 'var')
    wakeToCat = cutAroundEvent(catOnsets, 30 * Fs, photoSignal);
    catToWake = cutAroundEvent(catOffsets, 30 * Fs, photoSignal);
end

%% save everything to the results structure for convenience

if exist('catLOC', 'var')
    results.wakeToCat = wakeToCat;
    results.catToWake = catToWake;

    results.avgWakeToCat = mean(wakeToCat);
    results.avgCatToWake = mean(catToWake);

    results.catLOC = [catOnsets, catOffsets];
end

if exist('nremToRem', 'var')
    results.nremToRem = nremToRem;
    results.remToWake = remToWake;
    if size(nremToRem, 1) > 1; results.avgNremToRem = mean(nremToRem); else, results.avgNremToRem = nremToRem; end
    if size(remToWake, 1) > 1; results.avgRemToWake = mean(remToWake); else, results.avgRemToWake = remToWake; end

    results.remLOC = [remOnsets, remOffsets];
else
    results.nremToRem = [];
    results.remToWake = [];
    results.avgNremToRem = [];
    results.avgRemToWake = [];
end

results.wakeToNrem = wakeToNrem;
results.nremToWake = nremToWake;
results.avgWakeToNrem = mean(wakeToNrem);
results.avgNremToWake = mean(nremToWake);

results.wakeLOC = [refWakeToNremOnsets, refWakeToNremOffsets];
results.nremLOC = [nremOnsets, nremOffsets];
end