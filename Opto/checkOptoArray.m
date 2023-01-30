function new = checkOptoArray(array, state, Fs)

new    = nan(size(array, 1), size(array, 2)); % preallocate array
stable = 30 * Fs + 1;        % require 30 s of a given state to be included in analysis
target = stable * state;     % target score to verify stable prior state

% iterate through array, removing stims that do not meet criteria
for i = 1:size(array, 1)
    if sum(array(i, 30000:60000)) == target
        new(i, :) = array(i, :);
    end
end

% remove nans
new = rmmissing(new);

end