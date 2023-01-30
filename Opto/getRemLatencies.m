function [latency, allTrialLatency, percent] = getRemLatencies(stimArray, window, Fs)

oneMinute = 60 * Fs;
remLabel = 1;

for i = 1:size(stimArray, 1)
    findREM = find(stimArray(i, :) == remLabel);
    findREM = findREM(findREM > oneMinute & findREM < oneMinute + (oneMinute * window));

    if isempty(findREM)
        allTrialLatency(i) = (oneMinute * window) / Fs;
        latency(i) = NaN;
        hadREM(i) = 0;
    else
        allTrialLatency(i) = (findREM(1) - oneMinute) / Fs;
        latency(i) = (findREM(1) - oneMinute) / Fs;
        hadREM(i) = 1;
    end
end

latency = rmmissing(latency);
percent = sum(hadREM) / length(hadREM);

end