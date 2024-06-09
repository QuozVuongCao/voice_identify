% r = audiorecorder(8000, 16, 1);
% record(r,1);     % speak into microphone...
% pause(2)
% play(r);   % listen
%s = getaudiodata(r, 'double'); % get data as int16 array
%save soundata1_1.mat s

clear all
load sounddata7_3.mat
% recsound=audioplayer(s, 8000);
% play(recsound);
subplot(321);
plot(s)

s=s/max(abs(s)); %chuan hoa bien do tin hieu
subplot(322);
plot(s)

% Tinh nang luong thoi gian ngan
N=128;
for k=1:length(s)/N,
    Es(k)=s((k-1)*N+1:k*N)'*s((k-1)*N+1:k*N)/N;
end;

%Xac dinh frame bat dau va ket thuc tin hieu
subplot(323);
plot(Es)
Emax=max(Es);
[temp,index]=find(Es>0.1*Emax);
start_frame=index(1);
end_frame=index(length(index));

s1=s((start_frame-1)*N+1:end_frame*N);
recsound=audioplayer(s1, 8000);
play(recsound);
subplot(324);
plot(s1)

x=trichdactrung_fft(s1);

subplot(325);
plot(x)































