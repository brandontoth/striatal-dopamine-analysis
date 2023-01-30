function frames = getTransitionFrames(sleepStruct, vidFramesInNIDAQ)

frames = struct;

wakeToNremTransitions = randperm(length(sleepStruct.wakeToNrem), 5);
wakeToNremTransitions = sort(wakeToNremTransitions, 'ascend');

wakeToNremFrame = zeros(length(wakeToNremTransitions), 1);
for i = 1:length(wakeToNremFrame)
    [~, idx] = min(abs(vidFramesInNIDAQ - sleepStruct.wakeToNrem(wakeToNremTransitions(i))));
    wakeToNremFrame(i) = idx;
end

wakeToCatFrame = zeros(length(sleepStruct.wakeToCat), 1);
for i = 1:length(sleepStruct.wakeToCat)
    [~, idx] = min(abs(vidFramesInNIDAQ - sleepStruct.wakeToCat(i)));
    wakeToCatFrame(i) = idx;
end

frames.wakeToNremTransition = wakeToNremFrame;
frames.wakeToCatTransition = wakeToCatFrame;
frames.wakeToNremIdx = wakeToNremTransitions';

end