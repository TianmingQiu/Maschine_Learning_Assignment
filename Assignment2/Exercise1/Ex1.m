%-----------------------------------
% TU Munich 2017 SoSe
% Maschine Learning in Robtotics
% Author: Tianming Qiu
% Matrikel.Nr: 03686061
%-----------------------------------

close all; clear; clc;
load('dataGMM.mat');

%% initialize by kmeans
Data = Data';
[sample_number, dim] = size(Data);
% number of clusters
K = 4;
[idx, mean] = kmeans(Data, K);

%% get initial parameter
pi = zeros(1, K);
sigma = zeros(dim, dim, K);
for k = 1 : K
    class_label = (idx == k);
    pi(k) = sum(class_label) / sample_number;
    sigma(:,:,k) = cov(Data(class_label,:));
end

%% EM iteration
iteration_flag = 1;
pi_est = zeros(1, K);
resp = zeros(sample_number, K);
mean_est = zeros(K, dim);
sigma_est = zeros(dim, dim, K);
log_likelihood = 0;
log_likelihood_est = 0;
t = 0;
while iteration_flag ~= 0
    t = t + 1;
    for k = 1 : K
        % E-Step
        resp(:, k) = response(Data, pi, k, mean, sigma);
        % M-Step
        n(k) = sum(resp(:, k));
        mean_est(k, :) = sum(resp(:, k) .* Data) / n(k);
        for i = 1 : sample_number
            sigma_est(:,:,k) = sigma_est(:,:,k) + (Data(i, :) - ...
                mean_est(k, :))' * (Data(i, :) - mean_est(k, :)) .* resp(i, k);
        end
        sigma_est(:,:,k) = sigma_est(:,:,k) ./ n(k);
        pi_est(k) = n(k) / sample_number;
    end
    
    % update
    mean = mean_est;
    pi = pi_est;
    sigma = sigma_est;
    % check for convergence through log-likelihood
    for k = 1 : K
        log_likelihood_est = log_likelihood_est + pi(k) * ...
            mvnpdf(Data, mean(k, :), sigma(:, :, k));
    end
    log_likelihood_est = sum(log(log_likelihood_est));
    if log_likelihood_est == log_likelihood
        iteration_flag = 0;
    else
        log_likelihood = log_likelihood_est;
    end
end


%% Calculation for responsibility and multivariable Gaussian PDF
function resp = response(x, pi, k, mean, sigma)
numerator = pi(k) * mvnpdf(x, mean(k, :), sigma(:,:,k));
denominator = 0;
for j = 1 : 4
    denominator = denominator + pi(j) * mvnpdf(x, mean(j, :), sigma(:,:,j));
end
resp = numerator ./ denominator;
end

% function pdf = gaussian_pdf(x, sigma, mean)
% k = size(x, 1);
% pdf = 1 / sqrt((2 * pi) ^ k * det(sigma)) ...
%     * exp(-1 / 2 * ((x - mean) * inv(sigma) * (x - mean)'));
% pdf = diag(pdf);
% end