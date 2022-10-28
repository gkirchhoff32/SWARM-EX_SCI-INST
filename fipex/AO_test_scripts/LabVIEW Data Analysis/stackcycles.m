function [tPlot, ISPlot] = stackcycles(t, IS, pulseRate, spikeThresh, sampLim)
    % Function to stack periods for superposed epoch analysis in FIPEX
    % experiments.
    
    
    figure()
    hold ON
    pulsePeriod = 1/pulseRate;  % [s]

    % Use discrete time derivative to find indices of spikes
    dIS = diff(IS);
    idxPos = find(dIS > spikeThresh);
    idxPos = idxPos(diff(idxPos)~=1);

    % Stack cycles
    long = (diff(idxPos)>=sampLim);  % Identify where pulse lengths are too long
    
    % Instantiate t and IS matrices
    tPlot = NaN(length(idxPos)-1, sampLim);
    ISPlot = NaN(length(idxPos)-1, sampLim);
    for i = 1:length(idxPos)-1
        ISSeg = IS(idxPos(i):idxPos(i+1));
        tSeg = t(idxPos(i):idxPos(i+1)) - t(idxPos(i));
        
        % Throw away elements that occur after length of pulse cycle
        valid = tSeg<=pulsePeriod;
        tSeg = tSeg(valid);
        ISSeg = ISSeg(valid);
        
        tPlot(i, 1:length(tSeg)) = tSeg;
        ISPlot(i, 1:length(ISSeg)) = ISSeg;
    end
end