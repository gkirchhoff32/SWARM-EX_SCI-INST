function startIdx = converttimetoindex(startTime, TimeLabView)
    % Function to convert from HrMinSec to LabView Time and return index.

    startTimeVal = round(startTime * 60 * 1000 + TimeLabView(1));
    [ ~, startIdx ] = min(abs(startTimeVal - TimeLabView));

end