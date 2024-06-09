%doc anh goc
clc
clear all
%doc am thanh
load sounddata8_9.mat
recsound=audioplayer(s, 8000);
play(recsound);
subplot(321);
plot(s)

s1= tachtu_ste(s);
x=trichdactrung_fft(s1);

load mangnhandangtiengnoi.mat

y=sim(Net,x);

[ymax,ind]=max(y);
if ymax<0.75,
    disp('Khong nhan dang duoc');
else
    disp(['Am thanh vua doc la: ', int2str(ind-1)]);
end

