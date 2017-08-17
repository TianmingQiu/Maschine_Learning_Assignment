function Exercise2(d_max)

    images = loadMNISTImages('train-images.idx3-ubyte');
    labels = loadMNISTLabels('train-labels.idx1-ubyte');
    images_test=loadMNISTImages('t10k-images.idx3-ubyte');
    labels_test=loadMNISTLabels('t10k-labels.idx1-ubyte');

    %% PCA: eigenvalue and eigenvector
    % make the training data 'zero mean'
    images_zero_mean = images - padarray(mean(images, 2), [0, size(images, 2) - 1], ...
        'replicate', 'post');
    % corvariance matrix for training data
    S = cov(images_zero_mean');
    % make the test data 'zero mean'
    images_zero_mean_test = images_test - padarray(mean(images, 2), ...
        [0, size(images_test, 2) - 1], 'replicate', 'post');
    % calculate the eigenvlaue and eigen =vector to make them in descend oder
    [Eigvector, ~] = eig(S);
    Eigvalue = eig(S);
    [Eigvalue_sort,Eigvalue_index] = sort(Eigvalue,'descend');
    Eigvector_sort = Eigvector(:,Eigvalue_index);

    %% find optimal d
    for d = 1 : 60
        % PCA: reduce dimension with transform matrix W
        W = Eigvector_sort(:, 1 : d);
        images_ld = W' * images_zero_mean;
        images_test_ld = W' * images_zero_mean_test;
        % find the digits and its position
        digit = cell(10, 3);
        for i = 1:10 % loop for each digit
            digit{i, 1} = images_ld(:, labels == (i - 1)); % ith digit training sample
            digit{i, 2} = mean(digit{i, 1}, 2);            % mean value for ith digit
            digit{i, 3} = cov(digit{i, 1}');               % covariance matrix for ith digit
            Likelihood(:, i) = mvnpdf(images_test_ld', digit{i, 2}', digit{i, 3});
        end
        [Max_Likelihood, Index(: , d)] = max(Likelihood,[],2); % find the max likelihood
        Index(: , d) = Index(: , d) - 1; % make the index to allign each digit

        % find the wrong predicition and calculate the error percentage
        error_bool = Index(: , d) ~= labels_test;
        error(d) = 100 * sum(error_bool(:)) / size(images_test, 2);
    end
    [min_error, d_optimal] = min(error);

    %% plot percentage of error
    figure()
    plot(error,'b*');
    xlabel('d')
    ylabel('the percentage of error in %')

    %% returns the optimal d's confusion matrix
    C = confusionmat(Index(: , d_optimal), labels_test);
    helperDisplayConfusionMatrix(C);
end