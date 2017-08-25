function WalkQLearning(s)

% discount factor
gamma = 0.6;
% learning rate
alpha = 0.8;
% probability of exploration step
epsilon = 0.5;
% Initialize Q-function
Q = zeros(16, 4);
% number of iterations
T = 130;
% initial state
current_state = 1;

%% Iteration until T steps
for i = 1 : T
    % dynamic epsilon from 1 at the beginning to 0 at the end
    % epsilon = cos((pi / 2) * (i / T)) * epsilon;
    
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

%% result
state = zeros(1, 16);
state(1) = s;
for i = 1 : 15
    [~, act] = max(Q(state(i), :));
    [state(i + 1), ~] = SimulateRobot(state(i), act);
end

walkshow(state);


%% test
% subplot(411)
% walkshow([1:16])
% conseqeunce = zeros(1, 16);
% for i = 1 : 16
%     [~, act] = max(Q(i, :));
%     [conseqeunce(i), ~] = SimulateRobot(i, act);
% end
% 
% subplot(412)
% walkshow(conseqeunce);
% 
% subplot(413)
% groundtruth = [13, 3, 4, 8, 9, 5, 8, 5, 13, 14, 12, 9, 14, 2, 3, 4];
% walkshow(groundtruth);
% 
% subplot(414)
% walkshow(state);
% 
% conseqeunce == groundtruth
end