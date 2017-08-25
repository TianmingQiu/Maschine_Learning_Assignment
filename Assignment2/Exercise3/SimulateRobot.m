function [newstate, reward]=SimulateRobot(state, action)
%-----------------------------------
% TU Munich 2017 SoSe
% Maschine Learning in Robtotics
% Author: Tianming Qiu
% Matrikel.Nr: 03686061
%-----------------------------------
rew = [-1, +1, -1, +1;% state 1
    -1, +1, -1, -1; % state 2
    +1, -1, -1, -1; % state 3
    -1, -1, +1, -1; % state 4
    -1, -1, -1, +1; % state 5
    +1, -1, +1, -1; % state 6
    +1, -1, -1, -1; % state 7
    -1, +1, -1, -1; % state 8
    -1, -1, +1, -1; % state 9
    -1, -1, +1, -1; % state 10
    +1, -1, +1, -1; % state 11
    -1, +1, -1, -1; % state 12
    +1, -1, -1, -1; % state 13
    -1, -1, -1, +1; % state 14
    -1, -1, -1, +1; % state 15
    -1, +1, -1, +1;];% state 16

delta=[2 4 5 13; % state 1
    1 3 6 14; % state 2
    4 2 7 15; % state 3
    3 1 8 16; % state 4
    6 8 1 9;  % state 5
    5 7 2 10; % state 6
    8 6 3 11; % state 7
    7 5 4 12; % state 8
    10 12 13 5; % state 9
    9 11 14 6;  % state 10
    12 10 15 7; % state 11
    11 9 16 8;  % state 12
    14 16 9 1;  % state 13
    13 15 10 2; % state 14
    16 14 11 3; % state 15
    15 13 12 4]; % state 16

% Return next state and reward

newstate = delta(state, action);
reward=rew(state, action);

end
