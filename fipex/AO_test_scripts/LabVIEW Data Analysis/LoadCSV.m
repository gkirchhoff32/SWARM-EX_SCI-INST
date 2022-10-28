close all; clear all; clearvar; clc;

baseDir = pwd;  % Current working directory

addpath('..\data\2022_06_23_Chamber_TIA_Test')
T=readtable('20220623_AD2_Data_onboard_TIA_500kHz_20sec.csv');
t = T{:,1};
V = T{:,2};

save('ExperimentData/20220623_AD2_Data_onboard_TIA_500kHz_20sec.mat', 't', 'V');



% US = T{:,2};
% URef = T{:,3};
% IS = T{:,4};
% UH = T{:,5};
% IH = T{:,6};
% RH = T{:,7};
% TimeLabView = T{:,8};
% 
% save('ExperimentData/AD2TestTIAData.mat','US','URef','IS','UH','IH','RH','TimeLabView');








