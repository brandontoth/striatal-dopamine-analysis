function ratio = thetaDeltaRatio(labels, EEG, epochLength, Fs)

allPowerFilt = designfilt('bandpassfir', 'FilterOrder', 300, ...
    'CutoffFrequency1', 1, 'CutoffFrequency2', 30, ...
    'SampleRate', Fs);

eegFilteredAllPower = filtfilt(allPowerFilt, EEG);
eegFilteredEnvAllPower = abs(hilbert(eegFilteredAllPower));

thetaFilt = designfilt('bandpassfir', 'FilterOrder', 300, ...
    'CutoffFrequency1', 6, 'CutoffFrequency2', 10, ...
    'SampleRate', Fs);

eegFilteredTheta = filtfilt(thetaFilt, EEG);
eegFilteredEnvTheta = abs(hilbert(eegFilteredTheta));

getRatio = eegFilteredEnvTheta ./ eegFilteredEnvAllPower;
smoothRatio = smooth(getRatio, 1000);

ratio = subsample(labels, smoothRatio, epochLength, Fs);

end