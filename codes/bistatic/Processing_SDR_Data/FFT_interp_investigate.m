clear all 
close all 
clc 

% %% plotting sine waves
% dt1 = 3*pi/30;
% t1 = 0:dt1:3*pi;
% % y1 = sin(t1).^2 .* cos(t1);
% y1 = sin(t1);
% 
% 
% N = 200;
% y2 = interpft(y1,N);
% dt2 = dt1*length(t1)/N;
% t2 = 0:dt2:3*pi;
% y2 = y2(1:length(t2));
% 
% interpfactor = 8;
% y3 = resampleFDZP(y1, interpfactor);
% dt3 = dt1/interpfactor;
% t3 = 0:dt3:3*pi;
% y3 = y3(1:length(t3));
% 
% % 
% % figure();
% % hold on
% % plot(t1,y1,'o', 'DisplayName','Input')
% % plot(t3,y3,'.', 'DisplayName','Output')
% % legend('Location','southeast')
% 
% %% why are we adding zeros in the middle?
% dt = 3*pi/300;
% t = 0:dt:3*pi-dt;
% % y1 = sin(t1).^2 .* cos(t1);
% y= sin(2*pi*t);
% padlen = length(y)*(interpfactor - 1);
% % Compute FFT
% z = fft(y);
% % Construct a new spectrum (row vector) by centering zeros
% zp = [z zeros(1, padlen)];
% figure()
% plot(abs(z), 'LineWidth',3);
% % xlim([0,20]);


%% matlab example

Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector

S = 1+0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
Y = fft(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
stem(f,P1,'o') 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')