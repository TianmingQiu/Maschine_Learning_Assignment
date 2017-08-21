close all; clear; clc;
s = 5;

% discount factor
gamma = 0.9;
% learning rate
alpha = 0.5;
% probability of exploration step
epsilon = 0.9;
% Initialize Q-function
Q = zeros(16, 4);
% number of iterations
T = 250;
% initial state
current_state = 3;

% Iteration until T steps
for i = 1 : T 
    if rand < epsilon
       action = ceil(rand * 4);
    else 
       [~, action] = max(Q(current_state, :));
    end
    
    % use the function 'SimulateRobot' to get next state and reward
    [new_state, r] = SimulateRobot(current_state, action);
    
    % update the Q-matrix 
    Q(current_state, action) = Q(current_state, action) + ...
        alpha * (r + gamma * max(Q(new_state, :))) - Q(current_state, action);
    
    % from the new state
    current_state = new_state;
    
end

% prediction:


% result
state = zeros(1, 16);
state(1) = s;
for i = 1 : 15
    [~, act] = max(Q(state(i), :));
    [state(i + 1), ~] = SimulateRobot(state(i), act);
end

walkshow(state);