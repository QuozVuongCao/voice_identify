% r = audiorecorder(8000, 16, 1);
% record(r,1);     % speak into microphone...
% pause(2)
% play(r);   % listen
%s = getaudiodata(r, 'double'); % get data as int16 array
%save soundata1_1.mat s
clear all
load sounddata3_1.mat
% recsound=audioplayer(s, 8000);
% play(recsound);
subplot(321);
plot(s)

s1=s/max(abs(s));  %chuan hoa bien do am thanh da ghi
subplot(322);
plot(s1)
for k=1:8000/128,
    EW(k)=(s1((k-1)*128+1:k*128,1))'*s1((k-1)*128+1:k*128,1);
end
subplot(323);
plot(EW)
index=find(EW>mean(EW))

s2=s1((index(1)-1)*128+1:(index(end)+1)*128);
subplot(324);
plot(s2)
recsound=audioplayer(s2, 8000);
play(recsound);

f=fft(s2);
subplot(325);
plot(abs(f))

for k=1:50,
    fw(k)=sum(abs(f((k-1)*10+1:k*10)));
end
subplot(326);
plot(fw)


