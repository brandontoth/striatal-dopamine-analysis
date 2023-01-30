function normal = normalization(array, factor)

normal = zeros(size(array, 1), size(array, 2));

for i = 1:size(array, 1)
    smoothed = smooth(array(i, :), factor);

    normal(i, :) = (smoothed - min(smoothed)) ...
        / (max(smoothed) - min(smoothed));
end

end