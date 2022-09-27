function [f, P1] = computespectrum(y, Fs)

    % INPUTS
    % start  : start index
    % finish : end index
    % Fs     : sampling frequency
    % y      : data
    % OUTPUTS
    % P1     : Amplitude spectrum

    T = 1/Fs;             % Sampling period       
    L = length(y);        % Length of signal
    t = (0:L-1)*T;        % Time vector
    
    Y = fft(detrend(y));
    
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    
end
    
    