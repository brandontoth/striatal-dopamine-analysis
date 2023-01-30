function [wakeProb, wakeStim] = getWakeProbabilities(optoArray)

wakeProb = struct;

for i = 1:size(optoArray, 1)
    if optoArray(i, 60000) == 2
        wakeStim(i, :) = optoArray(i, :);
    else
        wakeStim(i, :) = nan(1, length(optoArray));
    end
end
wakeStim = rmmissing(wakeStim);

wakeStim = checkOptoArray(wakeStim, 2, 1000);
for i = 1:length(wakeStim)
    wakeProb.wake(i) = sum((wakeStim(:, i) == 2)) / size(wakeStim, 1);
    wakeProb.nrem(i) = sum((wakeStim(:, i) == 3)) / size(wakeStim, 1);
    wakeProb.rem(i) = sum((wakeStim(:, i) == 1)) / size(wakeStim, 1);
    wakeProb.cat(i) = sum((wakeStim(:, i) == 4)) / size(wakeStim, 1);
end

end