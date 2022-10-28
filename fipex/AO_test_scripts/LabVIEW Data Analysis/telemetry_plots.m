clear;

% Variables
data = readmatrix('../data/data5.dat');

sensorNr = data(:,1);
US = data(:,2);
Uref = data(:,3);
IS = data(:,4);
UH = data(:,5);
IH = data(:,6);
RH = data(:,7);
time = data(:,8) - data(1,8);  % Time [ms]
% TODO: Need to check if time units are correct

% Comment = data(:,9);
% MeasurementRange = data(:,10);
% range_is_change = data(:,11);
% temp_reg_on = data(:,12);
% heatup = data(:,13);
% uref_reg_on = data(:,14);

time = time / 1000;  % Convert to seconds

tiledlayout(3,2)

ax1 = nexttile;
plot(ax1,time,US)
title(ax1,'Sensor Voltage')
ylabel(ax1,'voltage [mV]')

ax4 = nexttile;
plot(ax4,time,UH,'r')
title(ax4,'Heater Voltage')
ylabel(ax4,'voltage [mV]')

ax2 = nexttile;
plot(ax2,time,Uref)
title(ax2,'Reference Voltage')
ylabel(ax2,'voltage [mV]')

ax5 = nexttile;
plot(ax5,time,IH,'r')
title(ax5,'Heater Current')
ylabel(ax5,'current [mA]')

ax3 = nexttile;
plot(ax3,time,IS)
title(ax3,'Sensor Current')
ylabel(ax3,'current [nA]')
xlabel(ax3, 'time [s]')

ax6 = nexttile;
plot(ax6,time,RH,'r')
title(ax6,'Heater Resistance')
ylabel(ax6,'resistance [Ohm]')
xlabel(ax6, 'time [s]')



