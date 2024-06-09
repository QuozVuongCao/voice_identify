function s1=tachtu_ste(s)
s=s/max(abs(s)); %chuan hoa bien do tin hieu
% Tinh nang luong thoi gian ngan
N=128;
for k=1:length(s)/N,
    Es(k)=s((k-1)*N+1:k*N)'*s((k-1)*N+1:k*N)/N;
end;

plot(Es)
Emax=max(Es);
[temp,index]=find(Es>0.1*Emax);
start_frame=index(1);
end_frame=index(length(index));

s1=s((start_frame-1)*N+1:end_frame*N);
end