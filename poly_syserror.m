% Check the interval system
clc
clear all
close all
x = [1.920:0.001:2.080];

%% right hand of the polynomial
y1 = x.^9 - 18*x.^8 + 144*x.^7 - 672*x.^6 + 2016*x.^5 - 4032*x.^4 + ...
    5376*x.^3 - 4608*x.^2 + 2304*x - 512;
figure(1)
plot(x, y1)
xlabel('x')
ylabel('y1')

%% left hand of the polynomial
y2 = (x-2).^9;
figure(2)
plot(x, y2)
xlabel('x')
ylabel('y2')