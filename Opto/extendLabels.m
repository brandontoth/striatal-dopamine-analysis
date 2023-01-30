function fullStateNum = extendLabels(labels, array, epochLength, Fs)

% redefine input array
statenum = labels;

% extend labels file to match that of the opto data
fullStateNum = zeros(length(array), 1);
fullStateNum(1, 1) = statenum(1);
labelIdx = 1;

% iterate through labels array, extending by defined amount
for i = 1:length(statenum)
    % if extending the last epoch
    if labelIdx == length(fullStateNum) - Fs * epochLength + 1
        fullStateNum((length(fullStateNum) - Fs * epochLength + 1):end) = ...
            labels(statenum(end));
    % if extending every other epoch
    else
        fullStateNum(labelIdx + 1:labelIdx + Fs * epochLength) = ...
            fullStateNum(labelIdx + 1:labelIdx + Fs * epochLength) + statenum(i);
    end
    
    labelIdx = labelIdx + Fs * epochLength; % shift index by epoch length
end

end