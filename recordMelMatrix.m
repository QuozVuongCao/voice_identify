function X = recordMelMatrix(sec)
% X = recordMelMatrix(sec)
% record 'sec' seconds of speech
% and return mel power spectrum in X(channelIdx,frameIdx)
% last update 6.2.04

%seconds to record
data.T = sec;

%sampling frequency
data.fs = 8000;

%number of samples to record
data.samples = data.T * data.fs;

%fft length
data.N=256;

%time shift is 10ms
data.shift = 10*data.fs/1000;

%number of mel filter channels
data.nofChannels = 22;

%compute matrix of mel filter coefficients
data.W = melFilterMatrix(data.fs,data.N,data.nofChannels);

data.s = wavrecord(data.samples,data.fs,'double');
wavplay(data.s,data.fs);

%compute mel spectra
data.MEL = computeMelSpectrum(data.W,data.shift,data.s);
data.nofFrames = size(data.MEL.M,2);
data.nofMelChannels = size(data.MEL.M,1);

%normalize energy of mel spectra
%take log value
epsilon = 10e-5;
for k = 1:data.nofFrames
    for c = 1:data.nofMelChannels
        %normalize energy
        data.MEL.M(c,k) = data.MEL.M(c,k)/data.MEL.e(k);
        %take log energy
        data.MEL.M(c,k) = loglimit(data.MEL.M(c,k),epsilon);
    end %for c
end %for k

X = data.MEL.M ;
