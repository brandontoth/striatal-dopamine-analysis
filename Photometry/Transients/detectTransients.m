function peakArray = detectTransients(photoSignal, Fs)

downFs    = 60;
downPhoto = resample(photoSignal, downFs, Fs);

filtFP1 = designfilt('lowpassiir', 'FilterOrder', 2, ...
                'PassbandFrequency', 4, 'SampleRate', downFs);
filtSig1 = filtfilt(filtFP1, downPhoto);

filtFP2 = designfilt('lowpassiir', 'FilterOrder', 2, ...
                'PassbandFrequency', 40, 'SampleRate', downFs);
filtSig2 = filtfilt(filtFP2, downPhoto);

diffSig = filtSig1 - filtSig2;
diffSigSq = diffSig .^ 2;
dxSig = diff(diffSigSq);

threshCandidate = mean(dxSig) + std(dxSig) * 2;

% figure;
% plot(dxSig)
% yline(threshCandidate)

[pks, locs] = findpeaks(diffSigSq, downFs, 'MinPeakHeight', threshCandidate);

locArray = nan(1, length(downPhoto));
for i = 1:length(locs)
    cur = floor(locs(i) * downFs);
    locArray(cur) = pks(i);
end

threshPeaks = mean(downPhoto) + std(downPhoto) * 2;

peakArray = nan(1, length(downPhoto));
for i = 1:length(locArray)
    if ~isnan(locArray(i)) && downPhoto(i) > threshPeaks
        peakArray(i) = downPhoto(i);
    end
end

% figure;
% plot(downPhoto)
% hold on
% plot(peakArray,'o')

end
