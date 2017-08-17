function par = Exercise1(k)
    load('Data.mat');
    fold_number = k;
    % define p1, p2 upper limit
    P_1 = 6;
    P_2 = 6;

    % initialize
    Cross_Validation_Subsamples = cell(fold_number, 2);
    subsample_length = size(Input,2) / fold_number;
    PosError = zeros(subsample_length, fold_number);
    Posistion_Error = zeros(P_1, 1);
    OrienError = zeros(subsample_length, fold_number);
    Orientation_Error = zeros(P_2, 1);

    %% divide Input into k small groups
    for k = 1 : fold_number
        Input_Subsample = Input(:, (k -1) * subsample_length + 1 : k * subsample_length);
        Output_Subsample = Output(:, (k -1) * subsample_length + 1 : k * subsample_length);
        Cross_Validation_Subsamples{k, 1} = Input_Subsample;
        Cross_Validation_Subsamples{k, 2} = Output_Subsample;
    end

    %% Find the optimal p1, p2
    % Initialize the training input-output sample matrices
    Input_V_Train = zeros(subsample_length * (fold_number - 1), 1);
    Input_W_Train = Input_V_Train;
    Output_X_Train = Input_V_Train;
    Output_Y_Train = Input_V_Train;
    Output_Theta_Train = Input_V_Train;

    Input_V_Test = zeros(subsample_length, 1);
    Input_W_Test = Input_V_Test;
    Output_X_Test = Input_V_Test;
    Output_Y_Test = Input_V_Test;
    Output_Theta_Test = Input_V_Test;

    for k = 1 : fold_number % k_th cross validation
        cross_train_index = zeros(1, fold_number - 1);
        cross_test_index = k;
        index = 1;

        %% generate cross_train_index
        % for each time, generate a index without 'k'
        for bias = 1 : fold_number
            temp = mod((k + bias), (fold_number + 1));
            if  temp ~= 0
                cross_train_index(index) = temp;
                index = index + 1;
            end
        end

        %% assign input-output sample matrices for k_th validation
        for index = 1 : fold_number - 1
            % assign data for train
            Input_V_Train((index - 1) * subsample_length + 1 : index * subsample_length) = ...
                Cross_Validation_Subsamples{cross_train_index(index), 1}(1, :);
            Input_W_Train((index - 1) * subsample_length + 1 : index * subsample_length) = ...
                Cross_Validation_Subsamples{cross_train_index(index), 1}(2, :);
            Output_X_Train((index - 1) * subsample_length + 1 : index * subsample_length) = ...
                Cross_Validation_Subsamples{cross_train_index(index), 2}(1, :);
            Output_Y_Train((index - 1) * subsample_length + 1 : index * subsample_length) = ...
                Cross_Validation_Subsamples{cross_train_index(index), 2}(2, :);
            Output_Theta_Train((index - 1) * subsample_length + 1 : index * subsample_length) = ...
                Cross_Validation_Subsamples{cross_train_index(index), 2}(3, :);

            % assign data for test
            Input_V_Test = Cross_Validation_Subsamples{k, 1}(1, :)';
            Input_W_Test = Cross_Validation_Subsamples{k, 1}(2, :)';
            Output_X_Test = Cross_Validation_Subsamples{k, 2}(1, :)';
            Output_Y_Test = Cross_Validation_Subsamples{k, 2}(2, :)';
            Output_Theta_Test = Cross_Validation_Subsamples{k, 2}(3, :)';
        end

        %% find optimal p1, p2 from 1 to their uppper limits
        X_Train = ones(subsample_length * (fold_number - 1), 1);
        X_Test = ones(subsample_length, 1);

        for p1 = 1 : P_1
            % generate Normal Equation model for polynomial curve fitting
            A1 = zeros(1 + 3 * p1, 1);
            A2 = A1;
            X_Train = [X_Train, Input_V_Train .^ p1 Input_W_Train .^ p1, ...
                (Input_V_Train .* Input_W_Train) .^ p1];
            A1 = inv(X_Train' * X_Train) * X_Train' * Output_X_Train;
            A2 = inv(X_Train' * X_Train) * X_Train' * Output_Y_Train;

            % calculate position error
            X_Test = [X_Test, Input_V_Test .^ p1 Input_W_Test .^ p1, ...
                (Input_V_Test .* Input_W_Test) .^ p1];

            Output_X_pred = X_Test * A1;
            Output_Y_pred = X_Test * A2;
            PosError(:, k) = sqrt((Output_X_pred - Output_X_Test) .^ 2 + ...
                (Output_Y_pred - Output_Y_Test) .^ 2) ;
            Posistion_Error(p1) = Posistion_Error(p1) + mean(PosError(:, k));
        end

        % clear the X matrix for p2
        X_Train = ones(subsample_length * (fold_number - 1), 1);
        X_Test = ones(subsample_length, 1);
        for p2 = 1 : P_2
            % generate Normal Equation model for polynomial curve fitting
            A3 = zeros(1 + 3 * p2, 1);
            X_Train = [X_Train, Input_V_Train .^ p2 Input_W_Train .^ p2, ...
                (Input_V_Train .* Input_W_Train) .^ p2];
            A3 = inv(X_Train' * X_Train) * X_Train' * Output_Theta_Train;
            % calculate position error
            X_Test = [X_Test, Input_V_Test .^ p2 Input_W_Test .^ p2, ...
                (Input_V_Test .* Input_W_Test) .^p2];
            Output_Theta_pred = X_Test * A3;
            OrienError(:, k) = sqrt((Output_Theta_pred - Output_Theta_Test) .^ 2) ;
            Orientation_Error(p2) = Orientation_Error(p2) + mean(OrienError(:, k));
        end
end

%% the minimal error represents the best 'p'
[~, p1_best] = min(Posistion_Error);
[~, p2_best] = min(Orientation_Error);

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