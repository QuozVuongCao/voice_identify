clear all;
disp('Dang huan luyen...');

D=zeros(10,50); % 10 ngo ra mong muon, moi tu co 5 mau
X=[];
for Tu=0:9,
    for k=1:5,
        filename=['sounddata' int2str(Tu) '_' int2str(k) '.mat'];
        load(filename); %doc file am thanh
        s1=s/max(s);            % chuan hoa bien do tin hieu am thanh
        s2=tachtu(s1);           % tach tu
        x = trichdactrung(s2);   % trich dac trung
        X=[X x];
        D(Tu+1,Tu*5+k)=1;
    end
end
r=rand(1,50);
[temp,index]=sort(r);

Net=newff(X,D,10,{'logsig','purelin'});
Net.trainParam.goal=0.000001;
Net.trainParam.epochs=100;
Net=train(Net,X(:,index),D(:,index));

save Nhandangtiengnoi_Test.mat Net
disp('Da huan luyen xong!');

