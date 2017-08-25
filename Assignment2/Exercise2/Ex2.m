close all; clear; clc;
load 'A.txt'; load 'B.txt'; load 'pi.txt'; load 'Test.txt';
B = B';
[T Samples] = size(Test);   % T: time step = 60 Samples: 10

[N M] = size(B);    % M: obzavation = 8  N: State = 12

%% Forward procedure
alpha = zeros(T, N, Samples);
for s = 1 : Samples
    % Initialize
    alpha(1, :, s) = pi' .* B(:, Test(1, s));
    
    % Induction
    for t = 1 : T - 1
        for j = 1 : N
            alphasum = sum(alpha(t, :, s) .* A(:, j)');
            alpha(t + 1, j, s) = alphasum * B(j, Test(t + 1, s));
        end
    end
    
    % Termination
    p(s) = sum(alpha(T, :, s));
end
log_likelihood = log(p);

result = 2 - (log_likelihood > -120);