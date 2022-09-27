%% AD2PulseAnalysis.m
% Pulse analysis for FIPEX MBEAM Lab AO Chamber measurements. Loads in data
% from the Digilent Analog Discovery 2 Oscilloscope. Pulses are superposed
% and - if ringing is present - the ringing can be zeroed.

% Grant Kirchhoff
% Last updated: 09/20/2022

%%
close all; clear all; clearvar; clc; format longEng;
% 
%% Load data and save to mat file

load_data = 0;
P = 'C:\Users\Grant\OneDrive - UCB-O365\Grad Projects\FIPEX Tests\fipex\data\2022_08_23_00deg_Incident\30min_stabilization\';
if load_data
    filetype = '*.csv';
    S = dir(fullfile(P, filetype));
    for j = 1:numel(S)
        S(j).data = readmatrix(append(P, S(j).name));
    end
    saveLoc = append(P, 'AO_pulse.mat');
    save(saveLoc, 'S')
end

%%
label = '00-degree Incident - 30 minute';
loadLoc = append(P, 'AO_pulse.mat');
load(loadLoc)

%%
close all
exclude = 0;
disable_thresholding = 0;

t_exclude = 10e-3;  % [s] Timestamp from which future points are excluded
t_tot = S(1).data(:, 1);

if exclude
    [M , exclude_bnd] = min(abs(t_tot - t_exclude));  % This index corresponds w/ the time preceding the ringing.
else
    exclude_bnd = length(S(1).data(:, 1));
end

gain = 8e3;  % [Ohms] 
bias = mean(S(1).data(1:100, 2));  % Initial non-zero voltage preceding pulse
t = S(1).data(1:exclude_bnd, 1);
difft = diff(t); 
dt = difft(1);

vThresh = 0.17;  % [V] Threshold voltage where lower voltages are zeroed
tThresh = 0.4e-3;  % [s] Threshold time where subsequent lower voltages are zeroed
threshSkip = 0.4e-2;  % [s] Time after which zeroing is desired

I_s = zeros(numel(S), length(S(1).data(1:exclude_bnd, 2)));
riemann_sum = zeros(1, numel(S));
figure()
hold on
for j = 1:numel(S)
    voltage = S(j).data(1:exclude_bnd,2);
    voltage = voltage - bias;  % Remove bias
    if ~disable_thresholding
        % If the spike occurs before t=0 (probably a mis-trigger) then skip.
        if any(voltage(find(t<-4e-3))>threshSkip)
            continue
        else
            voltage(voltage<vThresh & t>tThresh) = 0;  % Zero any value below threshold to mitigate effect of ringing on integral
            current = voltage / gain;
            riemann_sum(1, j) = sum(current) * dt;
            plot(t*1e3, current*1e9, '-')
        end
    else
        current = voltage / gain;
        riemann_sum(1, j) = sum(current) * dt;
        plot(t*1e3, current*1e9, '-')
    end
end
ylabel('Current [nA]')
xlabel('Time [ms]')
title(append(label, ': Measured Current'))

peakCurrent = zeros(numel(S), 1);
for j = 1:numel(S)
    peakCurrent(j) = max(S(j).data(1:exclude_bnd,2)) / gain;
end

sprintf('Mean peak current: %0.5f nA', mean(peakCurrent)*1e9)
sprintf('Standard deviation peak current: %0.5f nA', std(peakCurrent)*1e9)

hold off
figure()
plot(peakCurrent*1e9, riemann_sum*1e9, 'bo')
xlabel('Maximum Current [nA]')
ylabel('Time-integrated Current [nA*s]')
title(append(label, ': Time-integrated Current vs. Max Current'))


%%

[coeffs, gof] = fit(peakCurrent, riemann_sum', 'poly1');

peakFine = linspace(min(peakCurrent), max(peakCurrent), 1000);
A = coeffs.p1;
B = coeffs.p2;
forward = A*peakFine + B;


figure(3)
fitPlot = plot(peakFine*1e9, forward*1e9, 'r--'); fitLabel = sprintf('A=%0.2e s\nB=%0.2f nA*s', A, B*1e9);
hold on
plot(peakCurrent*1e9, riemann_sum*1e9, 'bo')
xlabel('Maximum Current [nA]')
ylabel('Time-integrated Current [nA*s]')
title(append(label, ': Time-integrated Current vs Max Current'))
legend([fitPlot], [fitLabel])


%%

% Convert from voltage to flux (assuming calibration curve extends to flux
% regime we operated in).
% Constants
gain = 8e3;  % [Ohm] Amplifier gain
M = 15.9994/1000;  % [g/mol] Molar mass
m = M / 6.022e23;  % convert to kg
T = 293.15;  % [K]
v = 6272e2;  % [cm/s]

iPeak = peakCurrent;  % [nA]
flux = currenttoflux(iPeak, m, T, v);
meanFlux = currenttoflux(mean(iPeak), m, T, v);

%%
figure(1)
plot(iPeak, '.', color='blue')
title('Peak Current')
xlabel('Shot')
ylabel('Peak Current [nA]')
yline(mean(iPeak), '-.r', sprintf('mean = %0.2f nA', mean(iPeak)))
hold off

figure(2)
for j = 1:numel(S)
    iVals = S(j).data(1:exclude_bnd,2) / gain * 1e9;
    plot(S(j).data(1:exclude_bnd,1)*1e3, iVals);
    hold on
end
title('Stacked Signal Output')
xlabel('Time [ms]')
ylabel('Current [nA]')

figure(3)
histogram(iPeak, 20)
title('Peak Current')
xlabel('Peak Current [nA]')

figure(4)
loglog(iPeak, flux, 'or')
title('Estimated Flux vs Measured Peak Currents')
subtitle('(Assuming Calibration Curve Extends)')
xlabel('Current [nA]')
ylabel('Estimated Flux [1/s/cm^2]')




%%
function flux = currenttoflux(current, m, T, v)
    % Inputs:
    % current [vector]: Current [A]
    % M: Molar mass [g/mol]
    % T: Temperature [K]
    % v: Beam velocity [cm/s]
    % Returns:
    % flux: Estimated flux from cal curve [1/s/cm^2]

    kB = 1.38e-23;  % [m^2*kg/s^2/K]
    current = current * 1e9;  % Convert to nA
    
    numDensity = 0.00072685 * current.^3.5259;  % [1/cm^3] From Stuttgart cal curve
    u = sqrt(8*kB*T/pi/m);
    flux = numDensity * (u/4 + v);
end


