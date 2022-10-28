%%
close all; clear all; clearvar; clc; format longEng;
% 
%% Load data

dir = 'C:\Users\Grant\OneDrive - UCB-O365\Grad Projects\FIPEX Tests\fipex\data\Igor Tests\';
filename = '220830_source-meter_no07_Uref-300mV_RH-311Ohms_fixed-10mA_oxygen_2Hz-Laser.csv';
SFull = importfile(append(dir, filename));
filename = '220831_source-meter_no15_NO_SENSOR_300mV-4-wire_fixed-10mA_O2_Laser_2Hz-Laser.csv';
SEMI = importfile(append(dir, filename));

%%

t = SFull.CH1Time;
t = t - t(1);
t = t / 1e5;
IFull = SFull.CH1Current;
IEMI = SEMI.CH1Current;
f = 1/(t(2)-t(1));

%%
tSeg = t(find(t==1.0):find(t==1.5));
IFullSeg = IFull(find(t==1.0):find(t==1.5));
IEMISeg = IEMI(find(t==1.0):find(t==1.5));
[argvalueIFull, argmaxIFull] = max(IFullSeg);
[argvalueIEMI, argmaxIEMI] = max(IEMISeg);
shift = argmaxIFull - argmaxIEMI;

IEMISegShift = IEMISeg(1:end-shift);
IFullSegShift = IFullSeg(shift+1:end);
tSegShift = tSeg(shift+1:end);

ISubtract = IFullSegShift - IEMISegShift;

%%
close all
figure
plot(tSegShift, ISubtract, '.')
xlabel('time [s]')
ylabel('current [nA]')
title('Sourcemeter Data - Sensor REMOVED')
subtitle('EMI Subtracted')
legend('URef=300mV, RH=31.1Ohms')

%%
% close all
figure
plot(tSegShift, IFullSegShift, '.')
hold on
plot(tSegShift, IEMISegShift, '.')
% plot(linspace(0, 2, length(I)), I)
xlabel('time [s]')
ylabel('current [nA]')
title('Sourcemeter Data - Sensor REMOVED')
subtitle('Argon Beam')
legend('URef=300mV, RH=NONE')





