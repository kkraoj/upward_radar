clear all 
close all 
clc 

% figure()
% t = 0:0.05:1.5;
% y = sin(t*2*pi).^2.*cos(t*2*pi);
% interpfactor = 16;
% tu = linspace(min(t),max(t),length(t)*interpfactor);
% yu2 = interpft(y, interpfactor*length(t));
% yu = resampleFDZP(y,interpfactor);
% plot(t,y, 'o','DisplayName','raw');
% hold on
% % plot(tu,yu,'.', 'DisplayName',sprintf('upsampled %dx', interpfactor));
% plot(tu,yu2,'.', 'DisplayName',sprintf('upsampled %dx', interpfactor));
% % xlim([0 1]);
% ylim([-1,1]);
% % xticks([0,0.25,0.5,0.75,1]);
% grid on
% legend();


figure()
dt1 = 3*pi/30;
t1 = 0:dt1:3*pi;
y1 = sin(t1).^2 .* cos(t1);
y1 = sin(t1);
plot(t1,y1,'o', 'DisplayName','Input')

N = 200;
y2 = interpft(y1,N);
dt2 = dt1*length(t1)/N;
t2 = 0:dt2:3*pi;
y2 = y2(1:length(t2));

interpfactor = 8;
y3 = resampleFDZP(y1, interpfactor);
dt3 = dt1/interpfactor;
t3 = 0:dt3:3*pi;
y3 = y3(1:length(t3));



hold on
plot(t3,y3,'.', 'DisplayName','Output')
legend('Location','southeast')