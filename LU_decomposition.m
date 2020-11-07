clc
clear all
close all

%% Test LU_deComp
A = rand(4);
% My LU
[L1, U1, P1] = LU_deComp(A);
% Matlab LU
[L2, U2, P2] = lu(A);

%% Define LU_deComp function
function [L,U, P] = LU_deComp(A)
    U = A;
    m = size(A,1);
    L = eye(m);
    P = eye(m);
    for k=1:m-1
        [~, i] = max(abs(U(k:m, k)));
        temp = U(k, k:m);
        U(k, k:m) = U(k+i-1, k:m);
        U(k+i-1, k:m) = temp;
        temp = L(k, 1:k-1);
        L(k, 1:k-1) = L(k+i-1, 1:k-1);
        L(k+i-1, 1:k-1) = temp;
        P(k, :) = P(k+i-1, :);
        for j=k+1:m
            L(j, k) = U(j, k)/U(k, k);
            U(j, k:m) = U(j, k:m) - L(j, k)*U(k, k:m);
        end
    end
    
end