%Purpose: To interpolate data in the time domain and prevent match filter power
%differences from occuring due to processing
clc 
close all
clear all

load ref_chirp


interpFactor=10;
fs = 15360000;
T=1/fs;
T2=1/(fs*interpFactor);


%center freq = 360
%dur = 8s
%gain = -8dB



t=[0:T:(length(ref_chirp)-1)*T];
t_up=[0:T2:(length(ref_chirp)-1)*T];
ref_chirp_upsampled = spline(t,ref_chirp,t_up);

save('ref_chirp_upsampled.mat','ref_chirp_upsampled')
