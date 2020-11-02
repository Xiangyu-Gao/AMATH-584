% Compare 3 QR decomposition algorithms 
clc
clear all
close all
m = 10;
n = 7;

%% create an ill-conditioned matrix A
A = randn(m, n);
A(:, n) = A(:, 1);
cond(A)

%% test 3 qr decomposition algorithms
% qrfactor
[Q1, R1] = qrfactor(A);
% modified gram-schmidt
[Q2, R2] = mod_gramschm(A);
% matlab qr
[Q3, R3] = qr(A);

%% evaluate their stablity
A_new = A + 1e-12 * randn(m, n);
% qrfactor
[Q1_new, R1_new] = qrfactor(A_new);
% modified gram-schmidt
[Q2_new, R2_new] = mod_gramschm(A_new);
% matlab qr
[Q3_new, R3_new] = qr(A_new);

Q1_dif = abs(Q1-Q1_new);
Q2_dif = abs(Q2-Q2_new);
Q3_dif = abs(Q3-Q3_new);

mean(Q1_dif(:, 7))
mean(Q2_dif(:, 7))
mean(Q3_dif(:, 7))
