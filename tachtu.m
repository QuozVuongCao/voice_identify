function s2=tachtu(s1)
    
for k=1:8000/128,
    EW(k)=(s1((k-1)*128+1:k*128,1))'*s1((k-1)*128+1:k*128,1);
end
index=find(EW>mean(EW));
s2=s1((index(1)-1)*128+1:(index(end)+1)*128);
end