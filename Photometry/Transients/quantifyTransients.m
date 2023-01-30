function results = quantifyTransients(labels, transients)

results = struct;
extend = extendLabels(labels, transients, 5, 60);

peaksW = transients(extend == 2);
peaksW(isnan(peaksW)) = [];

peaksN = transients(extend == 3);
peaksN(isnan(peaksN)) = [];

peaksR = transients(extend == 1);
peaksR(isnan(peaksR)) = [];

sleepStruct = parseStates(labels, 5, 60);

wakeLOC = sleepStruct.wakeLOC * 60;
[~, ~, common] = intersect(sleepStruct.briefArousalLOC, sleepStruct.wakeLOC, 'rows');
wakeLOC(common, :) = [];
for i = 1:length(wakeLOC)
    rng = wakeLOC(i, 1):wakeLOC(i, 2);

    curBout = transients(rng);
    curBout(isnan(curBout)) = [];

    rateW(i) = numel(curBout) / (numel(rng) / 60);
end

nremLOC = sleepStruct.nremLOC * 60;
for i = 1:length(nremLOC)
    rng = nremLOC(i, 1):nremLOC(i, 2);

    curBout = transients(rng);
    curBout(isnan(curBout)) = [];

    rateN(i) = numel(curBout) / (numel(rng) / 60);
end

if ~isempty(sleepStruct.remLOC)
    remLOC = sleepStruct.remLOC * 60;
    for i = 1:size(remLOC, 1)
        rng = remLOC(i, 1):remLOC(i, 2);
    
        curBout = transients(rng);
        curBout(isnan(curBout)) = [];
    
        rateR(i) = numel(curBout) / (numel(rng) / 60);
    end

    results.RemTransients = peaksR;
    results.RemTransientTotRate = rateR;
    results.RemTransientAvgRate = mean(rateR);
    results.RemTransientDFF = mean(peaksR);
    results.RemTransientSkewness = skewness(peaksR);
    results.RemTransientKurtosis = kurtosis(peaksR);
end

if ~isempty(sleepStruct.catLOC)
    catLOC = sleepStruct.catLOC * 60;
    for i = 1:size(catLOC, 1)
        rng = catLOC(i, 1):catLOC(i, 2);
    
        curBout = transients(rng);
        curBout(isnan(curBout)) = [];
    
        rateC(i) = numel(curBout) / (numel(rng) / 60);
    end

    peaksC = transients(extend == 4);
    peaksC(isnan(peaksC)) = [];

    results.CatTransients = peaksC;
    results.CatTransientTotRate = rateC;
    results.CatTransientAvgRate = mean(rateC);
    results.CatTransientDFF = mean(peaksC);
    results.CatTransientSkewness = skewness(peaksC);
    results.CatTransientKurtosis = kurtosis(peaksC);
end

results.WakeTransients = peaksW;
results.NremTransients = peaksN;

results.WakeTransientTotRate = rateW;
results.NremTransientTotRate = rateN;

results.WakeTransientAvgRate = mean(rateW);
results.NremTransientAvgRate = mean(rateN);

results.WakeTransientDFF = mean(peaksW);
results.NremTransientDFF = mean(peaksN);

results.WakeTransientSkewness = skewness(peaksW);
results.NremTransientSkewness = skewness(peaksN);

results.WakeTransientKurtosis = kurtosis(peaksW);
results.NremTransientKurtosis = kurtosis(peaksN);

end