function [nremProb, nremStim] = getNremProbabilities(optoArray)

nremProb = struct;

for i = 1:size(optoArray, 1)
    if optoArray(i, 60000) == 3
        nremStim(i, :) = optoArray(i, :);
    else
        nremStim(i, :) = nan(1, length(optoArray));
    end
end
nremStim = rmmissing(nremStim);

nremStim = checkOptoArray(nremStim, 3, 1000);
for i = 1:length(nremStim)
    nremProb.wake(i) = sum((nremStim(:, i) == 2)) / size(nremStim, 1);
    nremProb.nrem(i) = sum((nremStim(:, i) == 3)) / size(nremStim, 1);
    nremProb.rem(i) = sum((nremStim(:, i) == 1)) / size(nremStim, 1);
    nremProb.cat(i) = sum((nremStim(:, i) == 4)) / size(nremStim, 1);
end

end