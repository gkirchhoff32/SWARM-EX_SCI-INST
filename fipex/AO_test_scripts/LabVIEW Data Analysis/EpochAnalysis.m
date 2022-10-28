
% This script generates the superposed epoch analysis for the FIPEX test
% unit experiments. The process superposes each signal cycle and calculates
% order statistics. Development is ongoing.

% Grant Kirchhoff, grant.kirchhoff@colorado.edu
% University of Colorado Boulder
% Dep. of Aerospace Engineering Sciences
% SWARM-EX CubeSat Mission

%%
% % % % % % % % % % % % % % % % PARAMETERS % % % % % % % % % % % % % % % %

close all; clear all; clearvar; clc; format longEng;

baseDir = pwd;

% Input analysis settings (start & end times in minutes format MM.MM):
% fname = append(pwd, '/ExperimentData/ExperimentData.mat');
fname = append(pwd, '/ExperimentData/ExperimentData20220503.mat');

tStart = 42.00;     % Start timestamp for analysis
tEnd = 84.00;       % End timestamp for analysis
pulseRate = 2;      % Pulse rate [Hz]
spikeThresh = 2e3;  % Magnitude that defines a spike [nA]
sampLimit = 20;     % Limit on number of samples per cycle to ignore anomalies

load(fname)

%%
% Superposed epoch analysis

timeSec = (TimeLabView-TimeLabView(1))/1000; % Convert time to seconds

% Filtering out bad measurements (> 51000 nA and < 1000 nA)
for i=1:length(IS)          
    if 50500 <= IS(i) && IS(i) <= 51500 
        IS(i) = NaN;
    elseif IS(i) <= 1000
        IS(i) = NaN;
    end
end

start2Hz = converttimetoindex(tStart, TimeLabView);
end2Hz = converttimetoindex(tEnd, TimeLabView);
pulserate2Hz = pulseRate;
sampLimit2Hz = sampLimit;

% Choose segment of 2Hz pulses
t2Hz = timeSec(start2Hz:end2Hz);  
IS2Hz = IS(start2Hz:end2Hz);

% pulserate1Hz = 1;  % [Hz]
% pulserate2Hz = 2;  % [Hz]
% spikeThresh = 2e3;  % Magnitude that defines a spike [nA]
% sampLimit1Hz = 40;  % Limit on length of cycle (to ignore lengthy anomalies)
% sampLimit2Hz = 20;

[tPlot2Hz, ISPlot2Hz] = stackcycles(t2Hz, IS2Hz, pulserate2Hz, spikeThresh, sampLimit2Hz);
tPlot2Hz = round(tPlot2Hz, 2);  % Round to remove 5th decimal variability

% Set up order statistics
[tUnique2Hz, quartilesIS2Hz] = computequantiles(tPlot2Hz, ISPlot2Hz, 3);

% Plot 2Hz behavior
for i=1:length(tPlot2Hz(:,1))
    plot(tPlot2Hz(i,:), ISPlot2Hz(i,:), '.')
end
plot(tUnique2Hz, quartilesIS2Hz(:, 1))
plot(tUnique2Hz, quartilesIS2Hz(:, 2))
plot(tUnique2Hz, quartilesIS2Hz(:, 3))
xlabel('Time after epoch zero [s]')
ylabel('Current [nA]')
title('FIPEX SEA (stacked cycles) at 2Hz')

hold OFF


