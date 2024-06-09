X=[];
D=zeros(10,70);
for Tu=0:9,
    for k1=1:7,
        filename = ['sounddata' int2str(Tu) '_' int2str(k1) '.mat'];
        load(filename);
        
        s=s/max(abs(s)); %chuan hoa bien do tin hieu

        % Tinh nang luong thoi gian ngan
        N=128;
        for k=1:length(s)/N,
            Es(k)=s((k-1)*N+1:k*N)'*s((k-1)*N+1:k*N)/N;
        end;

        %Xac dinh frame bat dau va ket thuc tin hieu
        Emax=max(Es);
        [temp1,index]=find(Es>0.1*Emax);
        start_frame=index(1);
        end_frame=index(length(index));
        s1=s((start_frame-1)*N+1:end_frame*N);
        
        x = trichdactrung_fft(s1);
        X = [X x];
        D(Tu+1,Tu*7+k1)=1;
    end
end
    
% hoan doi ngau nhien cac mau du lieu, tranh tinh trang huan
% luyen lien tuc 1 so mau co ngo ra giong nhau
temp=rand(1,70);
[temp,ind]=sort(temp);
X=X(:,ind);
D=D(:,ind);

Net=newff(X,D,10,{'tansig','purelin'});
Net=train(Net,X,D); %huan luyen mang

save mangnhandangtiengnoi.mat Net
