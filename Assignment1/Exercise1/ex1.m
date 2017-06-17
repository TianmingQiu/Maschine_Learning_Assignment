%-----------------------------------
% TU Munich 2017 SoSe
% Maschine Learning in Robtotics
% Author: Tianming Qiu
% Matrikel.Nr: 30686061
%-----------------------------------

clear; close all; clc;
load('Data.mat');
tic
%% Generate k fold cross validtion subsamples
fold_number = 5;
P_1 = 6;
P_2 = 6;
Cross_Validation_Subsamples = cell(fold_number, 2);
subsample_length = size(Input,2) / fold_number;
PosError = zeros(subsample_length, fold_number);
Posistion_Error = zeros(P_1, 1);
OrienError = zeros(subsample_length, fold_number);
Orientation_Error = zeros(P_2, 1);
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
    
    % generate cross_train_index
    for bias = 1 : fold_number
        temp = mod((k + bias), (fold_number + 1));
        if  temp ~= 0
            cross_train_index(index) = temp;
            index = index + 1;
        end
    end
    
    %% assign input-output sample matrices for k_th validation
    for index = 1 : fold_number - 1
        %% assign data for train
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
        
        %% assign data for test
        Input_V_Test = Cross_Validation_Subsamples{k, 1}(1, :)';
        Input_W_Test = Cross_Validation_Subsamples{k, 1}(2, :)';
        Output_X_Test = Cross_Validation_Subsamples{k, 2}(1, :)';
        Output_Y_Test = Cross_Validation_Subsamples{k, 2}(2, :)';
        Output_Theta_Test = Cross_Validation_Subsamples{k, 2}(3, :)';
    end
    
    %%
    X_Train = ones(subsample_length * (fold_number - 1), 1);
    X_Test = ones(subsample_length, 1);
    
    
    for p1 = 1 : P_1
        %% generate Normal Equation model for polynomial curve fitting
        A1 = zeros(1 + 3 * p1, 1);
        A2 = A1;
        X_Train = [X_Train, Input_V_Train .^ p1 Input_W_Train .^ p1, ...
            (Input_V_Train .* Input_W_Train) .^ p1];
        A1 = inv(X_Train' * X_Train) * X_Train' * Output_X_Train;
        A2 = inv(X_Train' * X_Train) * X_Train' * Output_Y_Train;
        
        %% calculate position error
        X_Test = [X_Test, Input_V_Test .^ p1 Input_W_Test .^ p1, ...
            (Input_V_Test .* Input_W_Test) .^ p1];
        
        Output_X_pred = X_Test * A1;
        Output_Y_pred = X_Test * A2;
        PosError(:, k) = sqrt((Output_X_pred - Output_X_Test) .^ 2 + ...
            (Output_Y_pred - Output_Y_Test) .^ 2) ;
        Posistion_Error(p1) = Posistion_Error(p1) + mean(PosError(:, k));        
    end
    
    X_Train = ones(subsample_length * (fold_number - 1), 1);
    X_Test = ones(subsample_length, 1);
    
    
    for p2 = 1 : P_2
        % generate Normal Equation model for polynomial curve fitting
        A3 = zeros(1 + 3 * p2, 1);
        X_Train = [X_Train, Input_V_Train .^ p2 Input_W_Train .^ p2, ...
            (Input_V_Train .* Input_W_Train) .^ p2];
        A3 = inv(X_Train' * X_Train) * X_Train' * Output_Theta_Train;
        %% calculate position error
        X_Test = [X_Test, Input_V_Test .^ p1 Input_W_Test .^ p1, ...
            (Input_V_Test .* Input_W_Test) .^p1];
        Output_Theta_pred = X_Test * A3;
        OrienError(:, k) = sqrt((Output_Theta_pred - Output_Theta_Test) .^ 2) ;
        Orientation_Error(p2) = Orientation_Error(p2) + mean(OrienError(:, k));
        
    end
end


toc
%%

