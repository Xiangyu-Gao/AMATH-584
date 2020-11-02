% Check the condition number
clc
clear all
close all

%% condition number increase with matrix size
cond_mat = zeros(10);
for iter = 1:100
    for m = 2:10
        for n =1:m-1
            A = randn(m, n);
            cond_mat(m, n) = cond_mat(m, n) + cond(A);
        end
    end
end
cond_mat = cond_mat/100;

%% append column and check condition number
m = 7;
n = 6;
A = randn(m, n);
cond(A)
A1 = [A, A(:, 1)];
cond(A1)
det(A1)

%% add noise to the appended column and check condition number
cond_list = [];
for epsul = 5:15
    A1_temp = A1;
    A1_temp(:, n+1) = A1_temp(:, n+1) + rand(m, 1) * 10^(-epsul);
    cond_list = [cond_list, cond(A1_temp)];
end

figure(1)
plot([5:15], cond_list)