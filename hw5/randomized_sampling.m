% Hw5 problem 2: randomized sampling for SVD very large input

clc
clear all
close all

%% (a) Power iterate on the matrix of images to find the dominant 
% eigenvector and eigenvalue

%% read images
A = []; 
count = 0;
m = 192; % Size of each picture
n = 168;
N = 64; % Number of sample pictures
K = 39;
% K = 3;
avg = zeros(m*n,1);  % the average face

% read cropped dataset
for i = 1:K
    if i == 14
        continue
    end
    
    % Find the image names under the folder
    data_dir = "C:/Users/Xiangyu Gao/Desktop/Amath MS/AMATH 584/hw2" + ...
        "/hw_yele_faceB/data/yalefaces_cropped/CroppedYale/yaleB";
    folder_dir = strcat(data_dir, ...
        num2str(i,'%02d'), '/');
    files = dir(folder_dir); % find all the files under the folder
    
    for j = 1:N
%         figure(1)
        ff = files(2+j).name;;
        u = imread(folder_dir + ff); % Read the image into a matrix
%         imshow(u)
        if(size(u,3)==1)
            M=double(u);
        else
            M=double(rgb2gray(u)); 
        end
%         pause(0.1);
        R = reshape(M,m*n,1);
        A = [A, R];
        avg = avg + R;
        count = count + 1;
    end
end

%% Calculate the SVD for "averaged" face
avg = avg /count;

% avgTS = uint8(reshape(avg,m,n));
% figure(1), imshow(avgTS);

% % Center the sample pictures at the "origin"
% A1 = A - avg;

% Computing the SVD
[U1,S1,V1] = svd(A,0);

% interpretate the U, S, V matrix
numImg = size(A, 2);
Phi = U1(:,1:numImg);
Phi(:,1) = -1*Phi(:,1);

% plot the first reshaped coumns of matrix U
figure(1)
imshow(uint8(25000*reshape(Phi(:, 1),m,n)));

%% Power iteration
iteration = 30;
eig_vet = randn(m*n, 1);

A2 = [A, zeros(size(A, 1), size(A, 1)-size(A, 2))];

for i=1:iteration
    eig_vet1 = A2 * eig_vet;
    eig_vet = eig_vet1 / norm(eig_vet1); % update eigenvector
    
    % calculate associated eigenvalue with Rayleigh quotient
    eig_val = eig_vet' * A2 * eig_vet / (eig_vet' * eig_vet);
end

figure(2)
imshow(uint8(25000*reshape(eig_vet,m,n)));

%% (b) Use randomized sampling to reproduce the SVD matrices: U, ? and V.
% stage A
K = 20;
Omega = rand(size(A, 2), K);
Y = A * Omega;
[Q, R] = qr(Y, 0);

% stage B
B = (Q') * A;
[U2, S2, V2] = svd(B, 0);
uapprox = Q * U2;
sapprox = S2;
vapprox = V2;

% plot the first reshaped coumns of matrix U
figure(3)
imshow(uint8(25000*reshape(-uapprox(:, 1),m,n)));

%% (c) Compare along with the singular value decay as a function of
% the number of randomized samples
gt_singular = diag(S1);
figure(4)
plot([1:K], diag(S2), '-', 'LineWidth',2)
hold on 
plot([1:K], gt_singular(1:K), '--', 'LineWidth',2)
legend('randomized sampling mode','true mode')
