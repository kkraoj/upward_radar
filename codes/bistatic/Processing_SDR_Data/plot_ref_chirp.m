close all

load ref_chirp

x = real(ref_chirp);
y = imag(ref_chirp);

% for i=1:length(x)
%     plot(x(i),y(i),'or','MarkerSize',5,'MarkerFaceColor','r');
%     axis([-500 500 -500 500])
%     pause(.001)
% end
% % comet(x,y);