close all; clear; clc;

load('gesture_dataset.mat');
Input = gesture_l;
center = init_cluster_l;
% x=Input(:,:,1),y=Input(:,:,2),z=Input(:,:,3)
% plot3(x(:),y(:),z(:));
cluster_number = 7;
threshold = 1e-6;
sample_idx = 0;

for i = 1 : size(Input, 1)
    for j = 1 : size(Input, 2)
        sample_idx = sample_idx + 1;
        for k = 1 : size(Input, 3)
            
            Data(sample_idx, k) = Input(i, j, k);
        end
        
    end
    
end
delta = 1;
while (delta > threshold)
    %% calculate all distances
    for i = 1 : size(Input, 1) * size(Input, 2)
        for j = 1 : cluster_number
            d(i, j) = sqrt(sum((Data(i, :) - center(j, :)) .^ 2));
            
        end
    end
    [~, idx] = min(d, [], 2);
    Data_Clustered = cell(cluster_number,1);
    %% calculate new center
    for i = 1 : cluster_number
        Data_Clustered{i} = Data(idx == i, :);
        new_center(i, :) = mean(Data_Clustered{i});
    end
    delta = abs(sum(sum(new_center - center)));
end


% figure()
% hold on;
% plot3(new_cluster{1,i}(:,1),new_cluster{1,i}(:,2),new_cluster{1,i}(:,3),'b*')
% plot3(new_mean{1,i}(:,1),new_mean{1,i}(:,2),new_mean{1,i}(:,3),'b+','MarkerSize',20);
% plot3(new_cluster{2,i}(:,1),new_cluster{2,i}(:,2),new_cluster{2,i}(:,3),'k*')
% plot3(new_mean{2,i}(:,1),new_mean{2,i}(:,2),new_mean{2,1}(:,i),'k+','MarkerSize',20);
% plot3(new_cluster{3,i}(:,1),new_cluster{3,i}(:,2),new_cluster{3,i}(:,3),'r*')
% plot3(new_mean{3,i}(:,1),new_mean{3,i}(:,2),new_mean{3,i}(:,3),'r+','MarkerSize',20);
% plot3(new_cluster{4,i}(:,1),new_cluster{4,i}(:,2),new_cluster{4,i}(:,3),'g*')
% plot3(new_mean{4,i}(:,1),new_mean{4,i}(:,2),new_mean{4,i}(:,3),'g+','MarkerSize',20);
% plot3(new_cluster{5,i}(:,1),new_cluster{5,i}(:,2),new_cluster{5,i}(:,3),'m*')
% plot3(new_mean{5,i}(:,1),new_mean{5,i}(:,2),new_mean{5,i}(:,3),'m+','MarkerSize',20)
% plot3(new_cluster{6,i}(:,1),new_cluster{6,i}(:,2),new_cluster{6,i}(:,3),'y*')
% plot3(new_mean{6,i}(:,1),new_mean{6,i}(:,2),new_mean{6,i}(:,3),'y+','MarkerSize',20);
% plot3(new_cluster{7,i}(:,1),new_cluster{7,i}(:,2),new_cluster{7,i}(:,3),'c*')
% plot3(new_mean{7,i}(:,1),new_mean{7,i}(:,2),new_mean{7,i}(:,3),'c+','MarkerSize',20);