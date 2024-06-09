function x=trichdactrung(s);
    f=fft(s);
    fm = abs(f);
    for k=1:50,
        x(k,1) = sum(fm((k-1)*10+1:k*10,1));
    end
end