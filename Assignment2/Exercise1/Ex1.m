close all; clear; clc;
load('dataGMM.mat');

%% initialize by kmeans
Data = Data';
[sample_number, dim] = size(Data);
% number of clusters
k = 4;
[idx, mean]=kmeans(Data, k);

%% get initial parameter
pi = zeros(1, 4);

for j = 1 : k
    class_label = (idx == j);
    pi(j) = sum(class_label) / sample_number;
    sigma(:,:,j) = cov(Data(class_label,:));
end


function pdf = gaussian_pdf()