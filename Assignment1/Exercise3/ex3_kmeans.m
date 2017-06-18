close all; clear; clc;

load('gesture_dataset.mat');
Input = gesture_l;
x=Input(:,:,1),y=Input(:,:,2),z=Input(:,:,3)
plot3(x(:),y(:),z(:));
cluster_number = 7;
sample = size(Input, 1);


for i = 1 : sample
    for k = 1 : cluster_number
        
        
    end
    
end