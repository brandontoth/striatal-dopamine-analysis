function optoArray = beforeAfterStim(onsets, beforeTime, afterTime, fullStateNum, epochLength, Fs)

for i = 1:length(onsets)
    if onsets(i) + (epochLength * Fs) * 12 * afterTime < numel(fullStateNum) ...
            && onsets(i) - (epochLength * Fs) * 12 > 0
        optoArray(i, :) = fullStateNum(floor((onsets(i) - (epochLength * Fs) ...
            * 12 * beforeTime:onsets(i) + (epochLength * Fs) * 12 * afterTime)));
    end
end

end