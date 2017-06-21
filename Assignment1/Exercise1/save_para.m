function par = save_para(p1_best, p2_best, Input, Output)
par = cell(1, 3);
A1 = zeros(1 + 3 * p1_best, 1);
A2 = A1;

X_Train = ones(size(Input, 2), 1);
for p1 = 1 : p1_best
    % generate Normal Equation model for polynomial curve fitting
    X_Train = [X_Train, Input(1,:)' .^ p1 Input(2,:)' .^ p1, ...
        (Input(1,:)' .* Input(2,:)') .^ p1];    
end

A1 = inv(X_Train' * X_Train) * X_Train' * Output(1, :)';
A2 = inv(X_Train' * X_Train) * X_Train' * Output(2, :)';

X_Train = ones(size(Input, 2), 1);
for p2 = 1 : p2_best
    % generate Normal Equation model for polynomial curve fitting
    X_Train = [X_Train, Input(1,:)' .^ p2 Input(2,:)' .^ p2, ...
        (Input(1,:)' .* Input(2,:)') .^ p2];    
end

A3 = inv(X_Train' * X_Train) * X_Train' * Output(3, :)';
par = {A1, A2, A3};
end