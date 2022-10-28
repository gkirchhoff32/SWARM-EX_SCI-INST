close all; clear all; clearvar; clc; format longEng;

fnameAD2 = append(pwd, '/ExperimentData/20220620AD2ScopeTIAData.mat');
fnameData = append(pwd, '/ExperimentData/20220620AD2TestTIAData.mat');

load(fnameAD2);
load(fnameData);

time=(TimeLabView-TimeLabView(1))/1000/60;  % Converting time to minutes

ISSegment = IS(length(IS)-length(AD2Voltage)+1:length(IS)) * 1e-9;
gain = AD2Voltage ./ ISSegment;

plot(AD2Voltage);