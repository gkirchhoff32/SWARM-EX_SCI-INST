%% AD2PulseAnalysis.m
% Pulse analysis for FIPEX MBEAM Lab AO Chamber measurements during IRS
% Igor Hoerner's visit 08-30-2022 - 09-02-2022. These measurements were
% taken with a much higher sample rate sourcemeter with the ability to
% control the device settings directly.

% Grant Kirchhoff
% Last updated: 09/26/2022

%%
close all; clear all; clearvar; clc; format longEng;
% 
%% Load data

dir = 'C:\Users\jason\OneDrive - UCB-O365\Grad Projects\FIPEX Tests\fipex\data\Igor Tests\';
filename = '220831_source-meter_no13_NO_SENSOR_300mV-2-wire_fixed-10mA_O2_Laser_2Hz-Laser.csv';
S = importfile(append(dir, filename));


%%

t = S.CH1Time;
t = t - t(1);
t = t / 1e5;
I = S.CH1Current;
f = 1/(t(2)-t(1));

%%
close all
plot(t, I)
xlabel('time [s]')
ylabel('current [nA]')
title('Sourcemeter Output - Sensor Removed')
% subtitle('Sensor Behind Window')
legend('URef=300mV, RH=31.1Ohms')

