function Exercise3_nubs(motion_data, cluster_number)
    Input = motion_data;
    sample_idx = 0;

    %% reorder the original 3D data to 2D:
    for i = 1 : size(Input, 1)
    for j = 1 : size(Input, 2)
        sample_idx = sample_idx + 1;
        for k = 1 : size(Input, 3)
            Data(sample_idx, k) = Input(i, j, k);
        end
    end
    end

    %% 1st split:
    y = zeros(cluster_number ,3);
    J = zeros(cluster_number, 1);
    y(1, :) = mean(Data, 1);
    k = 1;

    %% step2 - step 5:
    Label = zeros(size(Data, 1), 1);
    Cluster = cell(cluster_number, 1);
    Cluster{1, 1} = Data;
    while (k < cluster_number)
    [~, i] = max(J(1 : k));
    Center_a = y(i, :) + [0.08, 0.05, 0.02];
    Center_b = y(i, :) - [0.08, 0.05, 0.02];
    Label = i * ones(size(Cluster{i}, 1), 1);
    distance_a = sum((Cluster{i, 1} - ...
        repmat(Center_a, [size(Cluster{i}, 1), 1])) .^ 2, 2);
    distance_b = sum((Cluster{i, 1} - ...
        repmat(Center_b, [size(Cluster{i}, 1), 1])) .^ 2, 2);
    Label(distance_a > distance_b) = k + 1;

    Cluster{k + 1, 1} = Cluster{i, 1}(Label == k + 1, :);
    Cluster{i, 1} = Cluster{i, 1}(Label == i, :);
    y(i, :) = mean(Cluster{i, 1}, 1);
    J(i) = sum(sum((Cluster{i, 1} - repmat(y(i, :), [size(Cluster{i}, 1), 1])) .^ 2));

    y(k + 1, :) = mean(Cluster{k + 1, 1}, 1);
    J(k + 1) = sum(sum((Cluster{k + 1, 1} - ...
        repmat(y(k + 1, :), [size(Cluster{k + 1}, 1), 1])) .^ 2));
    k = k + 1;

    end
    new_center = y;

    %% plot
    figure()
    hold on;
    plot3(Cluster{1}(:,1),Cluster{1}(:,2),Cluster{1}(:,3),'b.')
    plot3(new_center(1, 1),new_center(1, 2),new_center(1, 3),'b+','MarkerSize',20);
    plot3(Cluster{2}(:,1),Cluster{2}(:,2),Cluster{2}(:,3),'k.')
    plot3(new_center(2, 1),new_center(2, 2),new_center(2, 3),'k+','MarkerSize',20);
    plot3(Cluster{3}(:,1),Cluster{3}(:,2),Cluster{3}(:,3),'r.')
    plot3(new_center(3, 1),new_center(3, 2),new_center(3, 3),'r+','MarkerSize',20);
    plot3(Cluster{4}(:,1),Cluster{4}(:,2),Cluster{4}(:,3),'g.')
    plot3(new_center(4, 1),new_center(4, 2),new_center(4, 3),'g+','MarkerSize',20);
    plot3(Cluster{5}(:,1),Cluster{5}(:,2),Cluster{5}(:,3),'m.')
    plot3(new_center(5, 1),new_center(5, 2),new_center(5, 3),'m+','MarkerSize',20);
    plot3(Cluster{6}(:,1),Cluster{6}(:,2),Cluster{6}(:,3),'y.')
    plot3(new_center(6, 1),new_center(6, 2),new_center(6, 3),'y+','MarkerSize',20);
    plot3(Cluster{7}(:,1),Cluster{7}(:,2),Cluster{7}(:,3),'c.')
    plot3(new_center(7, 1),new_center(7, 2),new_center(7, 3),'c+','MarkerSize',20);
end