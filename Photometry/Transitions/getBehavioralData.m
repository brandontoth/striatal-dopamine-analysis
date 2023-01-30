function results = getBehavioralData(photoSignal, Food, RW, Lick)

before_after_time = 5000;

%feeding
pelletTimes = find(diff(Food) > 0.8)';

if ~isempty(pelletTimes)
    results.pellet = cutAroundEvent(pelletTimes, before_after_time, photoSignal);
else
    results.pellet = [];
end

%licking
lick_total = find(diff(Lick) == 1);
lick_onsets = lick_total;
for i = 2:length(lick_total)
    if lick_onsets(i) < lick_total(i - 1) + 10000
        lick_onsets(i) = NaN;
    else
        lick_onsets(i) = lick_total(i);
    end
end
lick_onsets(isnan(lick_onsets)) = [];

lick_offsets = lick_total;
for i = 1:length(lick_total) - 1
    if lick_offsets(i) + 10000 < lick_total(i + 1)
        lick_offsets(i) = lick_total(i);       
    else
        lick_offsets(i) = NaN;
    end
end
lick_offsets(isnan(lick_offsets)) = [];

if ~isempty(lick_total)
    results.lickOnsetDFF = cutAroundEvent(lick_onsets, before_after_time, photoSignal);
    results.lickOffsetDFF = cutAroundEvent(lick_offsets, before_after_time, photoSignal);
else
    results.lickOnsetDFF = [];
    results.lickOffsetDFF = [];
end

% RW
rw_total = find(diff(RW > 1));
rw_onsets = rw_total;

RW_diff = abs(diff(RW));

for i = 2:length(rw_total)
    if rw_onsets(i) < rw_total(i - 1) + 10000
        rw_onsets(i) = NaN;
    else
        rw_onsets(i) = rw_total(i);
    end
end
rw_onsets(isnan(rw_onsets)) = [];

rw_offsets = rw_total;
for i = 1:length(rw_total) - 1
    if rw_offsets(i) + 10000 < rw_total(i + 1)
        rw_offsets(i) = rw_total(i);       
    else
        rw_offsets(i) = NaN;
    end
end
rw_offsets(isnan(rw_offsets)) = [];

if ~isempty(rw_total)
    results.rwOnsetDFF = cutAroundEvent(rw_onsets, before_after_time, photoSignal);
    results.rwOffsetDFF = cutAroundEvent(rw_offsets, before_after_time, photoSignal);
else
    results.rwOnsetDFF = [];
    results.rwOffsetDFF = [];
end

results.avgPellet = mean(results.pellet);
results.avgLickOnset = mean(results.lickOnsetDFF);
results.avgLickOffset = mean(results.lickOffsetDFF);
results.avgRwOnset = mean(results.rwOnsetDFF);
results.avgRwOffset = mean(results.rwOffsetDFF);
