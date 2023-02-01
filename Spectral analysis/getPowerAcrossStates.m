function [wakeSpects, nremSpects, remSpects, catSpects] = getPowerAcrossStates(sleepStruct, EEG, Fs)
% obtain power spectrum
wakeLOC = sleepStruct.wakeLOC * Fs;
nremLOC = sleepStruct.nremLOC * Fs;
remLOC = sleepStruct.remLOC * Fs; 

if isfield(sleepStruct, 'catLOC')
    catLOC = sleepStruct.catLOC;
else
    catLOC = [];
end

for i = 1:size(nremLOC, 1)
    curboutstarttime = nremLOC(i, 1);
    curboutendtime = nremLOC(i, 2);
    nremSpects(:, i) = calcPowerSpect(EEG(curboutstarttime:curboutendtime), Fs); %#ok<*FNDSB>
end

[~, out] = rmoutliers(mean(nremSpects));
out = find(out == 1);
nremSpects(:, out) = [];

for i = 1:size(wakeLOC, 1)
    curboutstarttime = wakeLOC(i, 1);
    curboutendtime = wakeLOC(i, 2);
    wakeSpects(:, i) = calcPowerSpect(EEG(curboutstarttime:curboutendtime), Fs);
end

[~, out] = rmoutliers(mean(wakeSpects));
out = find(out == 1);
wakeSpects(:, out) = [];

if isempty(remLOC) == 0
    for i = 1:size(remLOC, 1)
        curboutstarttime = remLOC(i, 1);
        curboutendtime = remLOC(i, 2);
        remSpects(:,i) = calcPowerSpect(EEG(curboutstarttime:curboutendtime), Fs);
    end
else
    remSpects = [];
end

[~, out] = rmoutliers(mean(remSpects));
out = find(out == 1);
remSpects(:, out) = [];

if ~isempty(catLOC)
    for i = 1:size(catLOC, 1)
        curboutstarttime = catLOC(i, 1);
        curboutendtime = catLOC(i, 2);
        catSpects(:, i) = calcPowerSpect(EEG(curboutstarttime:curboutendtime), Fs);
    end

    [~, out] = rmoutliers(mean(catSpects));
    out = find(out == 1);
    catSpects(:, out) = [];
end

% normalize power spectrum across states
% will use the form: norm = (x - min(x)) / (max(x) - min(x))
% reference: https://stats.stackexchange.com/questions/70801/how-to-normalize-data-to-0-1-range

nremSpects = (nremSpects - min(nremSpects)) / (max(nremSpects) - min(nremSpects));
wakeSpects = (wakeSpects - min(wakeSpects)) / (max(wakeSpects) - min(wakeSpects));
remSpects = (remSpects - min(remSpects)) / (max(remSpects) - min(remSpects));
if exist("catSpects", "var")
    catSpects = (catSpects - min(catSpects)) / (max(catSpects) - min(catSpects));
else
    catSpects = nan(length(remSpects), 1);
end

end