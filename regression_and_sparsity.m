%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hw6: Regression and Sparsity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
close all

IS_one_digit = 1; 
digit = 0;

%% Problem 1
% read training data
data = load('.\mnist\mnist_train.csv');
train_label = data(:, 1)';
train_image = data(:, 2:end)'; % matrix X

if ~ IS_one_digit
    B_label = zeros(10, size(train_label, 2));% matrix B
    for i=1:size(train_label, 2)
        if train_label(1, i) > 0
            B_label(train_label(1, i), i) = 1;
        else
            B_label(10, i) = 1;
        end
    end
else
    B_label = zeros(2, size(train_label, 2));% matrix B
    for i=1:size(train_label, 2)
        if train_label(1, i) == digit
            B_label(1, i) = 1;
        else
            B_label(2, i) = 1;
        end
    end
end

A = train_image';
B = B_label';

% Solve AX = B
X1 = pinv(A) * B;

X2 = A \ B;

% lambda = 0.1;
% cvx_begin;
% variable X3(784, 10)
% minimize(norm(A*X3-B, 2) + lambda*norm(X3, 1));
% cvx_end


%% Problem 2
X2_spars = abs(X2);
X2_spars_sort = max(X2_spars, [], 2);
[val, pixel_sort] = sort(X2_spars_sort, 'descend');

X2_spars(find(X2_spars < 1e-3)) = NaN;

if ~ IS_one_digit
    figure(1)
    surf([1:10], [1:784], abs(X2_spars))
    axis([1, 10, 1, 784])
    colorbar
else
    figure(1)
    pixel_impt = reshape(X2_spars_sort, 28, 28);
    surf([1:28], [1:28], pixel_impt')
    axis([1, 28, 1, 28])
    colorbar
end

%% Problem 3
% read test data
data = load('.\mnist\mnist_test.csv');
test_label = data(:, 1)';
test_image = data(:, 2:end)'; % matrix X

if ~ IS_one_digit
    B1_label = zeros(10, size(test_label, 2));% matrix B
    for i=1:size(test_label, 2)
        if test_label(1, i) > 0
            B1_label(test_label(1, i), i) = 1;
        else
            B1_label(10, i) = 1;
        end
    end
else
    B1_label = zeros(2, size(test_label, 2));% matrix B
    for i=1:size(test_label, 2)
        if test_label(1, i) == digit
            B1_label(1, i) = 1;
        else
            B1_label(2, i) = 1;
        end
    end
end

A1 = test_image';
B1 = B1_label';

for i = 1:3
    pix_num = i*100;
    pix_label = zeros(1,784);
    pix_label(pixel_sort(1:pix_num, 1)) = 1;
    A1_pix = A1 .* pix_label;

    % Visualuze the cropped image
    show_index = 13;
    figure()
    subplot(1, 2, 1)
    image = reshape(A1(show_index, :), 28, 28);
    imshow(image')
    subplot(1, 2, 2)
    image = reshape(A1_pix(show_index, :), 28, 28);
    imshow(image')

    % test
    B_test = A1_pix * X2;

    % calculate accuracy
    test_soft = softmax(B_test');
    test_soft = test_soft';
    [~, testI] = max(test_soft, [], 2);
    [~, ground_truth] = max(B1, [], 2);
    compare = (testI == ground_truth);
    accuracy = sum(compare) / length(compare)
end
