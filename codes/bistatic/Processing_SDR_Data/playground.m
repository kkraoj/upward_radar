Fs = 2100;
T = 1/Fs;
L = 1500;
t = (0:L-1)*T;

X = 0.7*sin(2*pi*800*t) + sin(2*pi*1000*t);

% plot(Fs*t,X)


dataf = fft(X);
% L = length(data);
P2 = abs(dataf/L);
%     P1 = fftshift(P2);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f, P1);