function [twentyHzPulse, fortyHzPulse, allPulse] = getLaserOnsets(optoTTL)

% find onsets of different opto parameters
laserDiff = diff([0; optoTTL]);
laserStarts = find(laserDiff > 5);
laserStarts = [0; laserStarts];

for i = 1:length(laserStarts) - 1
    offtime(i) = laserStarts(i + 1) - laserStarts(i);
end

for i = 2:length(laserStarts)
    if laserStarts(i - 1) + 2000 < laserStarts(i)
        laserTrueStarts(i) = laserStarts(i);
    else
        laserTrueStarts(i) = NaN;
    end
end

for i = 2:length(laserTrueStarts)
    if isnan(laserTrueStarts(i))
        fortyHzPulse(i) = NaN;
        twentyHzPulse(i) = NaN;
    elseif offtime(i + 1) == 50
        twentyHzPulse(i) = laserTrueStarts(i);
        fortyHzPulse(i) = NaN;
    elseif offtime(i + 1) == 25
        fortyHzPulse(i) = laserTrueStarts(i);
        twentyHzPulse(i) = NaN;
    else
        fortyHzPulse(i) = NaN;
        twentyHzPulse(i) = NaN;
    end
end

twentyHzPulse = rmmissing(twentyHzPulse(2:end))';
fortyHzPulse = rmmissing(fortyHzPulse(2:end))';
allPulse = rmmissing(laserTrueStarts(2:end))';

end