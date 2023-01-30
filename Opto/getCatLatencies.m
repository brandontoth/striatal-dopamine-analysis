function [latency, allTrialLatency, percent] = getCatLatencies(stimArray, window, Fs)

oneMinute = 60 * Fs;
catLabel = 4;

for i = 1:size(stimArray, 1)
    findCat = find(stimArray(i, :) == catLabel);
    findCat = findCat(findCat > oneMinute & findCat < oneMinute + (oneMinute * window));

    if isempty(findCat)
        allTrialLatency(i) = (oneMinute * window) / Fs;
        latency(i) = NaN;
        hadCat(i) = 0;
    else
        allTrialLatency(i) = (findCat(1) - oneMinute) / Fs;
        latency(i) = (findCat(1) - oneMinute) / Fs;
        hadCat(i) = 1;
    end
end

latency = rmmissing(latency);
percent = sum(hadCat) / length(hadCat);

end