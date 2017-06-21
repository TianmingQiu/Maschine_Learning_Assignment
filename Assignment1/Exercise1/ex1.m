%-----------------------------------
% TU Munich 2017 SoSe
% Maschine Learning in Robtotics
% Author: Tianming Qiu
% Matrikel.Nr: 03686061
%-----------------------------------

clear; close all; clc;
load('Data.mat');

%% Generate k fold cross validtion subsamples
fold_number = 2; % here to change fold_number 
[p1_best, p2_best] = get_optimal_p(fold_number, Input, Output);

%% Save parameter
par = save_para(p1_best, p2_best, Input, Output);
save('params', 'par');
%% Plot
Simulate_robot(0, 0.05);
Simulate_robot(1, 0);
Simulate_robot(1, 0.05);
Simulate_robot(-1, -0.05);