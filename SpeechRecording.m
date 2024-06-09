clear all
% r = audiorecorder(8000, 16, 1);
% record(r,1);     % speak into microphone...
% pause(2)
% play(r);   % listen
% s = getaudiodata(r, 'double'); % get data as int16 array
% save sounddata2_9.mat s

load sounddata0_7.mat
recsound=audioplayer(s, 8000);
play(recsound);
y=s;

y=y/max(y);
E=y.*y
N=length(y);
W=128;
for k=1:(N/W),
    EW(k)=sum(E((k-1)*W+1:k*W),1);
end
EW_avg=mean(EW);
index=find(EW>EW_avg);
ind=find(index>5);
k1=(index(ind(1))-2)*W;
k2=(index(length(index))+2)*W;
x=y(k1:k2,1);

subplot(321)
plot(y)
subplot(322)
plot(E)
subplot(323);
plot(EW)
subplot(324);
plot(x);


f=fft(x);
subplot(325);
plot(abs(f))

    
    
    

            