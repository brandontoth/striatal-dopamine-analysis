function [syncPhotoDFF, zSyncPhotoDFF] = syncPhotoToEEG(digitalSync, nidaqSync, elongatedSignal, baselineAdjustment)

% constant declaration
percentile = 10;

% sync photometry to nidaq
pySyncOnsets = find(diff(digitalSync) > 0.07)';

nidaqDigOnsets = find(diff(nidaqSync) > 3);
offset = nidaqDigOnsets(1) - pySyncOnsets(1);

% redefine FP array to account for recording offset
syncArray(1:offset) = elongatedSignal(100);
syncArray(offset + 1:length(nidaqSync)) = elongatedSignal(1:length(nidaqSync) - offset);

% process FP data
[photoDetrend, ~, ~] = CB_photodetrend(syncArray');
photoSmooth = smooth(photoDetrend, 120) - baselineAdjustment;

f0 = prctile(photoSmooth, percentile);
for k = 1:length(photoSmooth)
   photoDFF(k) = (photoSmooth(k) - f0) / f0;
end

zPhotoDFF = zscore(photoDFF); % zscore total trace

% save photo variables
syncPhotoDFF = photoDFF;
zSyncPhotoDFF = zPhotoDFF;

end