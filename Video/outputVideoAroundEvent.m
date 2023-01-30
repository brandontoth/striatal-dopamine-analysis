function [] = outputVideoAroundEvent(vidObj, sleepStruct, transitionFrames, camFs, identifier, saveLocation)

% MATLAB doesn't allow inputs to be actual frame numbers, so find the
% duration per frame to allow us to scale frame numbers accordingly
vidStepPerFrame = vidObj.Duration / vidObj.NumFrames;

% we want to look 40 s before and after the CLE
beforeAfterTime = 40 * floor(camFs) * 2;

if ~exist(saveLocation, 'dir')
    mkdir(saveLocation)
end

%% W-CAT transitions
% find the duration of all CLE and set to camera frame rate
catLengthInFrames = floor(camFs) * (sleepStruct.catLOC(:, 2) - sleepStruct.catLOC(:, 1));

% iterate through all CLE and save video per episode
for i = 1:length(transitionFrames.wakeToCatTransition)

    % initialize video object
    writeVid = VideoWriter(horzcat(saveLocation, '\', identifier, ... 
        '_WtoCAT_frame_', num2str(transitionFrames.wakeToCatTransition(i))));
    writeVid.FrameRate = floor(camFs); % set frame rate

    % start video object
    open(writeVid)

    % grab frame 40 s prior to the onset of CLE
    vidStart = vidStepPerFrame * (transitionFrames.wakeToCatTransition(i) - floor(camFs * 40));

    vidObj.CurrentTime = vidStart; % move video to that point in time

    curFrameNum = 1; % counter for while loop

    % read through desired frames and write to video
    while curFrameNum <= beforeAfterTime + catLengthInFrames(i)
        curFrame = readFrame(vidObj);

        writeVideo(writeVid, curFrame) % write frame to video

        curFrameNum = curFrameNum + 1;
    end

    % destroy current video object
    close(writeVid)
end

%% W-NR transition
nremLengthInFrames = zeros(5, 1);
% find the duration of all REM and set to camera frame rate
for i = 1:5
   nremLengthInFrames(i) = floor(camFs) * (sleepStruct.nremLOC(transitionFrames.wakeToNremIdx(i), 2) ... 
       - sleepStruct.nremLOC(transitionFrames.wakeToNremIdx(i), 1));
end

% iterate through all REM and save video per episode
for i = 1:length(transitionFrames.wakeToNremTransition)

    % initialize video object
    writeVid = VideoWriter(horzcat(saveLocation, '\', identifier, ... 
        '_WtoNR_frame_', num2str(transitionFrames.wakeToNremTransition(i))));
    writeVid.FrameRate = floor(camFs); % set frame rate

    % start video object
    open(writeVid)

    % grab frame 40 s prior to the onset
    vidStart = vidStepPerFrame * (transitionFrames.wakeToNremTransition(i) - floor(camFs * 40));

    vidObj.CurrentTime = vidStart; % move video to that point in time

    curFrameNum = 1; % counter for while loop

    % read through desired frames and write to video
    while curFrameNum <= beforeAfterTime + nremLengthInFrames(i)
        curFrame = readFrame(vidObj);

        writeVideo(writeVid, curFrame) % write frame to video

        curFrameNum = curFrameNum + 1;
    end

    % destroy current video object
    close(writeVid)

end

end
