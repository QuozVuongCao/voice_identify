function x=trichdactrung_fft(s)
FFTs = fft(s);
mag_FFTs = abs(FFTs);

% Tinh tong bien do pho trong khung cua so
N1=20;
%dac trung la tong bien do pho Fourier trong 40 cua so
x = zeros(30,1);
for k=1:30, %length(mag_FFTs)/2/N1
    x(k)=sum(mag_FFTs((k-1)*N1+1:k*N1));
end;
end