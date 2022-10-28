
% This script visualizes the data from the FIPEX test unit experiments. The 
% viewer will be able to view telemetry including: Sensor Voltage (Us),
% Reference Voltage (Uref), Sensor Current (Is & dIs), Heater Voltage (UH),
% Heater Current (IH), and Heater Resistance (RH). The user will also have
% the option to view the amplitude spectrum of the sensor current.

% IMPORTANT: Set analysis parameters in "Parameters" section.

% Grant Kirchhoff, grant.kirchhoff@colorado.edu
% University of Colorado Boulder
% Dep. of Aerospace Engineering Sciences
% SWARM-EX CubeSat Mission

%%
% % % % % % % % % % % % % % % % PARAMETERS % % % % % % % % % % % % % % % %

close all; clear all; clearvar; clc;

baseDir = pwd;  % Current working directory

% Input analysis settings (start & end times in minutes)
% fname = append(pwd, '/ExperimentData/ExperimentData.mat');
fname = append(pwd, '/ExperimentData/20220503ExperimentData.mat');
tStart = 42.00;     % Start timestamp for analysis
tEnd = 84.00;       % End timestamp for analysis
pulseRate = 2;      % Pulse rate [Hz]

load(fname)

ComputeFFT = 1;  % Set true for fft computation

%%
% FFT computation and visualization

time=(TimeLabView-TimeLabView(1))/1000/60;  % Converting time to minutes

if ComputeFFT
    % fft of the 2 Hz segments
    start2Hz = converttimetoindex(tStart, TimeLabView);
    end2Hz = converttimetoindex(tEnd, TimeLabView);
    IS2Hz = IS(start2Hz:end2Hz);
    Fs=length(time)/(time(end)*60);     % Avg. sampling frequency 

    [f2Hz, P12Hz] = computespectrum(IS2Hz, Fs);

    figure()
    plot(f2Hz,P12Hz) 
    title(sprintf('Single-Sided Amplitude Spectrum of Sensor Current (%d Hz Pulse)', pulseRate))
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    grid on
    
%     % Save start and end indices for 2Hz for "EpochAnalysis.m" script
%     save('startendindices.mat', 'start2Hz', 'end2Hz')
        
end

%%
% Data visualization

%%%% Filtering out the huge signals
for i=1:length(IS)          
    if 50500 <= IS(i) && IS(i) <= 51500 
        IS(i)=NaN;
    end
end


%%%% Displaying the full data
figure()
for i=1
subplot(4,2,1)
plot(time,US)
hold on
plot(time,ones(length(RH),1).*100,'r')
hold on
plot(time,ones(length(RH),1).*1500,'r')
ylabel('Voltage [mV]')
xlabel('Time [s]')
title('Sensor Voltage, Us')
legend('Data','Limits')
grid on

subplot(4,2,3)
plot(time,Uref)
hold on
plot(time,ones(length(RH),1).*100,'r')
hold on
plot(time,ones(length(RH),1).*585,'r')
xlabel('Time [s]')
ylabel('Voltage [mV]')
title('Reference Voltage, Uref')
legend('Data','Limits')
grid on

subplot(4,2,5)
plot(time,IS)
xlabel('Time [s]')
ylabel('Current [nA]')
title('Sensor Current, Is')
grid on

subplot(4,2,7)
plot(time,range_is_change)
title('Sensor Current Change')
xlabel('Time [s]')
grid on

subplot(4,2,2)
plot(time,UH)
xlabel('Time [s]')
ylabel('Voltage [mV]')
title('Heater Voltage, UH')
grid on


subplot(4,2,4)
plot(time,IH)
xlabel('Time [s]')
ylabel('Current [mA]')
title('Heater Current, IH')
grid on

subplot(4,2,6)
plot(time,RH)
hold on
plot(time,ones(length(RH),1).*27,'r')
hold on
plot(time,ones(length(RH),1).*32,'r')
xlabel('Time [s]')
ylabel('Resistance [Ohm]')
title('Heater Resistance, RH')
grid on
legend('Data','Limits')

subplot(4,2,8)
plot(time,heatup)
title('Heatup')
xlabel('Time [s]')
grid on

end


%%%%% Just looking at the current
figure()
plot(time,IS, 'b')
xlabel('Time [min]')
ylabel('Current [nA]')
title('Sensor Current, Is')
grid on















