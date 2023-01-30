function [Photo_detrend3, Photo_detrend2, Photo_detrend1] = CB_photodetrend(Photo)


% xt = linspace(1,length(Photo),length(Photo))';
% f=fit(xt,Photo,'exp1');
% curfit1=f.a*exp(f.b*xt);
% Photo_detrend1=(Photo-curfit1)+mean(curfit1);
% figure;
% subplot(2,1,1)
% plot(f,xt,Photo,'g')
% title('original dFF with fitted decaying exponent')
% subplot(2,1,2)
% plot(xt,Photo,'g');hold on;plot(xt,Photo_detrend1,'r')
% title('original and exp1 trace')
Photo_detrend1 = 1;
xt = linspace(1,length(Photo),length(Photo))';
f=fit(xt,Photo,'exp2');
curfit2=f.a*exp(f.b*xt);
Photo_detrend2=(Photo-curfit2)+mean(curfit2);
% figure;
% subplot(2,1,1)
% plot(f,xt,Photo,'g')
% title('original dFF with fitted decaying exponent')
% subplot(2,1,2)
% plot(xt,Photo,'g');hold on;plot(xt,Photo_detrend2,'r')
% title('original and exp2 trace')

f2=fit(xt,Photo_detrend2,'exp1');
curfit3=f2.a*exp(f2.b*xt);
Photo_detrend3=(Photo_detrend2-curfit3)+mean(curfit3);
figure;
subplot(2,1,1)
plot(f2,xt,Photo_detrend2,'g')
title('original dFF with fitted decaying exponent')
subplot(2,1,2)
plot(xt,Photo_detrend2,'g');hold on;plot(xt,Photo_detrend3,'r')
title('original and double detrend trace')
