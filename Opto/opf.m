function optoStruct = opf(labels, optoTTL, session)

% get some info from the current folder
folder = dir;
[path, name, ~] = fileparts(folder(1).folder);
iden = name;

% constant declaration/initialization
optoStruct     = struct; % struct for data
Fs             = 1000;   % sampling rate
epochLength    = 5;      % epoch length (seconds)
beforeTime     = 1;      % time before stim (minutes)
afterTime      = 8;      % time after stim (minutes)
window         = 6;      % latency window (minutes)

% extend labels file to match that of the opto data
fullStateNum = extendLabels(labels, optoTTL, epochLength, Fs);

% find onsets of different opto parameters
[~, ~, allPulse] = getLaserOnsets(optoTTL);

if length(allPulse) > 100
    allPulse = allPulse(1:10:end);
end

% make arrays by cutting around opto onsets
optoArray = beforeAfterStim(allPulse, beforeTime, ...
    afterTime, fullStateNum, epochLength, Fs);

% get arrays with state probabilities
[wakeStruct, wakeStim] = getWakeProbabilities(optoArray);
[nremStruct, nremStim] = getNremProbabilities(optoArray);

% get latency to cataplexy
[catLatency, catLatencyAllTrials, catPercent] = ...
  getCatLatencies(wakeStim, window, Fs);

% get latency to REM
if ~isempty(nremStim)
    [remLatency, remLatencyAllTrials, remPercent] = ...
        getRemLatencies(nremStim, window, Fs);
    [wakeLatency, wakeLatencyAllTrials, wakePercent] = ...
        getWakeLatencies(nremStim, window, Fs);
else
    remLatency = [];
    remLatencyAllTrials = [];
    remPercent = [];

    wakeLatency = [];
    wakeLatencyAllTrials = [];
    wakePercent = [];
end
% put everything into a structure
optoStruct.wakeStim_wakeProb = wakeStruct.wake;
optoStruct.wakeStim_nremProb = wakeStruct.nrem;
optoStruct.wakeStim_remProb = wakeStruct.rem;
optoStruct.wakeStim_catProb = wakeStruct.cat;
optoStruct.wakeStim = wakeStim;
optoStruct.avgCatLatencyAllTrials = mean(catLatencyAllTrials);
optoStruct.avgCatLatency = mean(catLatency);
optoStruct.catLatencyAllTrials = catLatencyAllTrials;
optoStruct.catLatency = catLatency;
optoStruct.catPercent = catPercent;

if ~isempty(nremStim)
    optoStruct.nremStim_wakeProb = nremStruct.wake;
    optoStruct.nremStim_nremProb = nremStruct.nrem;
    optoStruct.nremStim_remProb = nremStruct.rem;
    optoStruct.nremStim_catProb = nremStruct.cat;
    optoStruct.nremStim = nremStim;
else
    optoStruct.nremStim_wakeProb = [];
    optoStruct.nremStim_nremProb = [];
    optoStruct.nremStim_remProb = [];
    optoStruct.nremStim_catProb = [];
    optoStruct.nremStim = [];
end
optoStruct.avgRemLatency = mean(remLatency);
optoStruct.avgRemLatencyAllTrials = mean(remLatencyAllTrials);
optoStruct.remLatencyAllTrials = remLatencyAllTrials;
optoStruct.remLatency = remLatency;
optoStruct.remPercent = remPercent;

optoStruct.avgWakeLatency = mean(wakeLatency);
optoStruct.avgWakeLatencyAllTrials = mean(wakeLatencyAllTrials);
optoStruct.wakeLatencyAllTrials = wakeLatencyAllTrials;
optoStruct.wakeLatency = wakeLatency;
optoStruct.wakePercent = wakePercent;

% save data
save(horzcat(path, '\', iden, '_optoStruct_', session), 'optoStruct')

end