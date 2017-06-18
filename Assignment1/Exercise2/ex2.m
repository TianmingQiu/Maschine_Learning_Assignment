close all; clear; clc;
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');

images_test=loadMNISTImages('t10k-images.idx3-ubyte');
labels_test=loadMNISTLabels('t10k-labels.idx1-ubyte');

images_zero_mean = images - padarray(mean(images, 2), [0, size(images, 2) - 1], ...
    'replicate', 'post'); %%%% why sybstract original mean?!!!
S = cov(images_zero_mean');

images_zero_mean_test = images_test - padarray(mean(images, 2), ...
    [0, size(images_test, 2) - 1], 'replicate', 'post');


[Eigvector, ~] = eig(S);
Eigvalue = eig(S);
[Eigvalue_sort,Eigvalue_index] = sort(Eigvalue,'descend');
Eigvector_sort = Eigvector(:,Eigvalue_index);

for d = 1:15
    W = Eigvector_sort(:, 1 : d);
    images_ld = W' * images_zero_mean;
    images_test_ld = W' * images_zero_mean_test;
    
    % find the digits and its position
    digit = cell(10, 4);
    for i = 1:10
        digit{i, 1} = find(labels == (i - 1));
        %digit{i, 2} = zeros(784, size(digit{i, 1}, 1));
        digit{i, 2} = images_ld(:, digit{i, 1});
        % labels == (i - 1) can be directe written above
        digit{i, 3} = mean(digit{i, 2}, 2);
        % pad_mean = padarray(mean(digit{i, 2}, 2), [0, 9999], 'replicate', 'post')';
        digit{i, 4} = cov(digit{i, 2}');
        Likelihood(:, i) = mvnpdf(images_test_ld', digit{i, 3}', digit{i, 4});
    end
    [Max_Likelihood, Index] = max(Likelihood,[],2);
    Index = Index - 1;
    a = Index ~= labels_test;
    error(d) = 100 * sum(a(:)) / size(images_test, 2);
end

