close all; clear; clc;
images=loadMNISTImages('train-images.idx3-ubyte');
labels=loadMNISTLabels('train-labels.idx1-ubyte');
images_test = loadMNISTImages('train-images.idx3-ubyte');
labels_test = loadMNISTLabels('train-labels.idx1-ubyte');

images_zero_mean = images - padarray(mean(images, 2), [0, size(images, 2) - 1], ...
    'replicate', 'post');
S = cov(images_zero_mean * images_zero_mean');

images_zero_mean_test = images - padarray(mean(images_test, 2), ...
    [0, size(images_test, 2) - 1], 'replicate', 'post');
S_test = cov(images_zero_mean_test * images_zero_mean_test');

[Eigvector, Eigvalue] = eig(S);
Eigvalue = eig(S);
[Eigvalue_sort,Eigvalue_index] = sort(Eigvalue,'descend');
Eigvector_sort = Eigvector(:,Eigvalue_index);

for d = 1:15
    W = Eigvector_sort(:, 1 : d);
    images_ld = W' * images_zero_mean;
    
    % find the digits and its position
    digit = cell(10,5);
    for i = 1:10
        digit{i, 1} = find(labels == (i - 1));
        %digit{i, 2} = zeros(784, size(digit{i, 1}, 1));
        digit{i, 2} = images_ld(:, digit{i, 1});
        digit{i, 3} = mean(digit{i, 2}, 2);
        digit{i, 4} = cov(digit{i, 2} * digit{i, 2}');
    end
    images_test_ld = W' * images_test;
    
    digit{i, 5} = mvnpdf(images_test_ld, digit{i, 3}, digit{i, 4});
end

