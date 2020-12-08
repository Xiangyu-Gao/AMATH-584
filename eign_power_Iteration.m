% Hw5 problem 1: Eigenvalues Decomposition and Power Iterations

clc
clear all
close all

%% (a) Create symmetric matrix
rng(111);
m = 10;
A = randn(m);
As = A;
% As = (A + A')/2; %symmetric matrix
[V, D] = eigs(As);

%% (b) Power interation to find the greatest eigenvalue
iteration = 30;
eig_vet = randn(m, 1);
est_err_ary = [];

for i=1:iteration
    eig_vet1 = As * eig_vet;
    eig_vet = eig_vet1 / norm(eig_vet1); % update eigenvector
    % calculate associated eigenvalue with Rayleigh quotient
    eig_val = eig_vet' * As * eig_vet / (eig_vet' * eig_vet);
    % calculaet the eigenvalue error with MSE 
%     est_err = (eig_val - D(1,1))^2;
    est_err = norm(eig_val - D(1,1));
    est_err_ary = [est_err_ary, est_err];
end

% plot the estimation accuracy as a function of iterations
figure(1)
plot([1:iteration], est_err_ary)
xlabel('Interation')
ylabel('MSE error')

%% (c) Find all ten eigenvalues by Rayleigh Quotient iteration
[V, D] = eig(As);
iteration = 30;
ep = 0.01; % epusil threshold
eig_vet_mat_initial = eye(m);
eig_vet = eig_vet_mat_initial(:, 1);
eig_val = 10;
est_err_ary = [];
esti_eig_val_ary = [];

for k = 1:iteration
    eig_val = (eig_vet' * As * eig_vet) / (eig_vet' * eig_vet);
    eig_vet1 = (As - eig_val * eye(m)) \ eig_vet;
    eig_vet = eig_vet1 / norm(eig_vet1);
    % calculaet the eigenvalue error with MSE 
%     est_err = (eig_val - D(6,6))^2;
    est_err = norm(eig_val - D(10, 10));
    est_err_ary = [est_err_ary, est_err];
end

% plot the estimation accuracy as a function of iterations
figure(2)
plot([1:iteration], est_err_ary)
xlabel('Interation')
ylabel('MSE error')

% find all ten eigenvalues
% while length(esti_eig_val_ary) < 10
%     flag = round(rand([1, m]));
%     for i = 1:m
%         if flag(i) == 1
%             eig_vet = eig_vet_mat_initial(:, i);
%         end
%     end
%     eig_val = 10;
%     eig_vet = eig_vet .* rand([m, 1]);
%     for k = 1:iteration
%         eig_val = (eig_vet' * As * eig_vet) / (eig_vet' * eig_vet);
%         eig_vet1 = (As - eig_val * eye(m)) \ eig_vet;
%         eig_vet = eig_vet1 / norm(eig_vet1);
%     end
%     
%     if length(esti_eig_val_ary) == 0
%         esti_eig_val_ary = [esti_eig_val_ary, eig_val];
%     end
%     
%     for i = 1:length(esti_eig_val_ary)
%         if abs(eig_val - esti_eig_val_ary(i)) < 0.001
%             break
%         elseif i == length(esti_eig_val_ary)
%             esti_eig_val_ary = [esti_eig_val_ary, eig_val];
%             find(flag == 1)
%         end
%     end
% end

%% (d)  Repeat (b) and (d) with a random matrix that is not symmetric
% Now the eigenvalues and eigenvectors are not guranteed to be real
