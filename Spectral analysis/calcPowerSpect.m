function powerSpec = calcPowerSpect(EEG, Fs)

window = hann(Fs); % hamming window of size equivalent to the sampling frequency
noverlap = Fs * 0.5;  % have 50% overlap between windows   
f = 0:.5:15;          % bin at .5 Hz resolution

% pwelch power estimate
[pxx, ~]= pwelch(EEG, window, noverlap, f, Fs);

% save PSD estimate
powerSpec = pxx.^2;

end
