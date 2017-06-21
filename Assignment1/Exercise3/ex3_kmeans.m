close all; clear; clc;
%% Intialize
load('gesture_dataset.mat');
Input = gesture_x;
center = init_cluster_x;

cluster_number = 7;
threshold = 1e-6;
sample_idx = 0;
J = 1;

% reorder the original 3D data to 2D:
for i = 1 : size(Input, 1)
    for j = 1 : size(Input, 2)
        sample_idx = sample_idx + 1;
        for k = 1 : size(Input, 3)        
          Data(sample_idx, k) = Input(i, j, k);
        end
    end    
end

%% K means loop
decrement = 1;
while (decrement > threshold)
    J_new = 0;
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
        J_new = J_new + sum(sum((Data_Clustered{i} - padarray(new_center(i, :), ...
            [size(Data_Clustered{i}, 1) - 1, 0], 'replicate', 'post')) .^ 2));
    end
    % dcrement rate
    decrement = abs(J_new - J)/J ;
    J = J_new;
    center = new_center;
    
end
%% Plot

figure()
hold on;
plot3(Data_Clustered{1}(:,1),Data_Clustered{1}(:,2),Data_Clustered{1}(:,3),'b.')
plot3(new_center(1, 1),new_center(1, 2),new_center(1, 3),'b+','MarkerSize',20);
plot3(Data_Clustered{2}(:,1),Data_Clustered{2}(:,2),Data_Clustered{2}(:,3),'k.')
plot3(new_center(2, 1),new_center(2, 2),new_center(2, 3),'k+','MarkerSize',20);
plot3(Data_Clustered{3}(:,1),Data_Clustered{3}(:,2),Data_Clustered{3}(:,3),'r.')
plot3(new_center(3, 1),new_center(3, 2),new_center(3, 3),'r+','MarkerSize',20);
plot3(Data_Clustered{4}(:,1),Data_Clustered{4}(:,2),Data_Clustered{4}(:,3),'g.')
plot3(new_center(4, 1),new_center(4, 2),new_center(4, 3),'g+','MarkerSize',20);
plot3(Data_Clustered{5}(:,1),Data_Clustered{5}(:,2),Data_Clustered{5}(:,3),'m.')
plot3(new_center(5, 1),new_center(5, 2),new_center(5, 3),'m+','MarkerSize',20);
plot3(Data_Clustered{6}(:,1),Data_Clustered{6}(:,2),Data_Clustered{6}(:,3),'y.')
plot3(new_center(6, 1),new_center(6, 2),new_center(6, 3),'y+','MarkerSize',20);
plot3(Data_Clustered{7}(:,1),Data_Clustered{7}(:,2),Data_Clustered{7}(:,3),'c.')
plot3(new_center(7, 1),new_center(7, 2),new_center(7, 3),'c+','MarkerSize',20);
