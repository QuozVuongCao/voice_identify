clear all
clc
load sounddata5_2.mat
recsound=audioplayer(s, 8000);
play(recsound);
% disp('Hay doc vao mot tu...')
% r = audiorecorder(8000, 16, 1);
% record(r,1);     % speak into microphone...
% pause(2)
% play(r);   % listen
% s = getaudiodata(r, 'double'); % get data as int16 array

s1=s/max(s);             % chuan hoa bien do tin hieu am thanh
s2=tachtu(s1);           % tach tu
x = trichdactrung(s2);   % trich dac trung

load Nhandangtiengnoi.mat   % load mang neuron da huan luyen
ynet = sim(Net,x);
[ymax,ind] = max(ynet);
if ymax > 0.5,
    switch ind,
        case 1, disp('Tu vua nhan dang la: KHONG');
        case 2, disp('Tu vua nhan dang la: MOT');
        case 3, disp('Tu vua nhan dang la: HAI');
        case 4, disp('Tu vua nhan dang la: BA');
        case 5, disp('Tu vua nhan dang la: BON');
        case 6, disp('Tu vua nhan dang la: NAM');
        case 7, disp('Tu vua nhan dang la: SAU');
        case 8, disp('Tu vua nhan dang la: BAY');
        case 9, disp('Tu vua nhan dang la: TAM');
        case 10, disp('Tu vua nhan dang la: CHIN');
    end
else disp('Khong nhan dang duoc');
end
    



    
    


