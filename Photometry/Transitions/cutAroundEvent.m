function curEvent = cutAroundEvent(eventTime, cutTime, signal)

for i = 1:length(eventTime)
    if eventTime(i) + cutTime < numel(signal) && ...
            eventTime(i) - cutTime > 0
        curEvent(i, :) = signal(floor((eventTime(i) ...
        - cutTime:eventTime(i) + cutTime)));
    end
end

end