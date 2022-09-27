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
%% Load data and save to mat file

dir = 'C:\Users\jason\OneDrive - UCB-O365\Grad Projects\FIPEX Tests\fipex\data\Igor Tests\';
filename = '220830_source-meter_no07_Uref-300mV_RH-311Ohms_fixed-10mA_oxygen_2Hz-Laser.csv';
S = importfile(append(dir, filename));


%%
