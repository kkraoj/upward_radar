clear all 
close all 
clc 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function yp = myresampleFDZP(y, m) 
% Calculate number of padding zeros
padlen = length(y)*(m - 1);
% Compute FFT
z = fft(y);
% Construct a new spectrum (row vector) by centering zeros
zp = [z zeros(1, padlen)];
yp = ifft(zp)*m; 
end

