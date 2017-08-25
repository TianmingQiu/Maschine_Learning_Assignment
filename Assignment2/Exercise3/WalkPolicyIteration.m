function WalkPolicyIteration(s)
%% Task 1:
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

%% Task 2: Policy Iteration
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

% initialize a random policy
pi = ceil(rand(16, 1) * 4);


% iteration
gamma = 0.8;
iter_flag = 1;
t = 0;
while iter_flag
    % step(a)
    A = eye(16);
    B = zeros(16, 1);
    for i = 1 : 16
        A(i, delta(i, pi(i))) = -gamma;
        B(i, 1) = rew(i,pi(i));
    end
    
    V = A\B;
    
    % step(b)
    pi_new = ones(16, 1);
    for i = 1 : 16
        [~, pi_new(i)] = max(rew(i, :)' + gamma * V(delta(i, :)));
    end
    
    if pi_new == pi
        iter_flag = 0;
    else
        pi = pi_new;
    end
    t = t + 1;
end

%% result
states = zeros(1, 16);
states(1) = s;
for i = 1 : 15
    states(i + 1) = delta(states(i), pi(states(i)));
end
walkshow(states);

%% Test
% subplot(411)
% walkshow([1:16])
%
% conseqeunce = zeros(1, 16);
% for i = 1 : 16
%     conseqeunce(i) = delta(i, pi(i));
% end
% subplot(412)
% walkshow(conseqeunce);
%
% subplot(413)
% groundtruth = [13, 3, 4, 8, 9, 5, 8, 5, 13, 14, 12, 9, 14, 2, 3, 4];
% walkshow(groundtruth);
%
% subplot(414)
% walkshow(states);
% conseqeunce == groundtruth

end