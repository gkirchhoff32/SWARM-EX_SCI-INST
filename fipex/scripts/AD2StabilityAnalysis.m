close all; clear all; clearvar; clc; format longEng;

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
loadLoc = append(P, 'AO_pulse.mat');
load(loadLoc)

%%
exclude_bnd = 2276;  % This index corresponds w/ the time preceding the ringing.

gain = 8e3;  % [Ohms] 
bias = mean(S(1).data(1:100, 2));  % Initial non-zero voltage preceding pulse
t = S(1).data(1:exclude_bnd, 1);
difft = diff(t);
dt = difft(1);
vThresh = 0.17;  % [V] Threshold voltage where lower voltages are zeroed
tThresh = 0.4e-3;  % [s] Threshold time where subsequent lower voltages are zeroed

I_s = zeros(length(S(1).data(1:exclude_bnd, 2)), numel(S));
riemann_sum = zeros(1, numel(S));
figure(1)
hold on
for j = 1:numel(S)
    voltage = S(j).data(1:exclude_bnd, 2);
    voltage = voltage - bias;  % Remove bias
    voltage(voltage<vThresh & t>tThresh) = 0;  % Zero any value below threshold to mitigate effect of ringing on integral
    current = voltage / gain;
    I_s(:, j) = current;
    riemann_sum(1, j) = sum(current) * dt;
    plot3(t*1e3, repmat(j, length(t), 1), current*1e9)
end
ylabel('Laser shot')
xlabel('Time [ms]')
zlabel('Current [nA]')
title('Superposed Pulses')

peakCurrent = zeros(numel(S), 1);
for j = 1:numel(S)
    peakCurrent(j) = max(S(j).data(1:exclude_bnd,2)) / gain;
end

hold off
figure(2)
plot(peakCurrent*1e9, riemann_sum*1e9, 'bo')
xlabel('Maximum Current [nA]')
ylabel('Time-integrated Current [nA*s]')
title('Time-integrated Current vs. Max Current')



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


