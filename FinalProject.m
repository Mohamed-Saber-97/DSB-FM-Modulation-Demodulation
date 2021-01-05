%Close all open windows
close all;
%Clear workspace log
clear all;
%Clears command window log
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXPERIMENT ONE: DOUBLE SIDEBAND MODULATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading from audio file
[signal,Fs] = audioread('eric.wav');
%%%%%%%%%%%%%%%%  Time Domain  %%%%%%%%%%%%%%%%
%Number of samples
samplesNumber = length(signal);
%Distribute of points on the x axis
time= linspace(0,samplesNumber/Fs,samplesNumber);
%show figure 1
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(time,signal);
title('Original Signal in Time Domain');
ylabel('Amplitude');
xlabel('Time');

%%%%%%%%%%%%%%%%  Frequency Domain  %%%%%%%%%%%%%%%%

%Signal in frequency domain
frequencyDomainSignal=fftshift(fft(signal));
%frequency range 
frequencyRange=(-Fs/2:Fs/samplesNumber:Fs/2-Fs/samplesNumber);
subplot(2,1,2);
plot(frequencyRange,abs(frequencyDomainSignal));
title('Original Signal in Frequency Domain');
ylabel('Amplitude');
xlabel('Frequency');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize cut off frequency
cutoffFrequency=4000/(Fs/2);
%using a low pass filter
[denumerator,numerator]=butter(20,cutoffFrequency,'low');
filteredSignalTime=filter(denumerator,numerator,signal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Frequency domain
filteredSignalFrequency=fftshift(fft(filteredSignalTime));
%Show figure 2
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(time,filteredSignalTime);
title('Signal filtered by Low pass filter in Time Domain');
ylabel('Amplitude');
xlabel('Time');
subplot(2,1,2);
plot(frequencyRange,abs(filteredSignalFrequency));
title('Signal filtered by Low pass filter in Frequency Domain');
ylabel('Amplitude');
xlabel('Frequency');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sound(filteredSignalTime,Fs);
pause(5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%  DSB-SC  %%%%%%%%%%%%%%%%

%Carrier frequency
Fc=100000;
%Sampling frequency
Fm=5*Fc;
%Signal resampling from Fs freq. to Fm freq.
resampledSignal=resample(filteredSignalTime,Fm,Fs);
samplesNumber=length(resampledSignal);
%time range
time=linspace(0,samplesNumber/Fm, samplesNumber);
%freqyency Range
FrequencyRange=-(Fm/2) : Fm/samplesNumber : (Fm/2) - Fm/samplesNumber;
%Carrier signal
carrierSignal=cos(2*pi*Fc*time);
%DSC-SC in time domain
%transpose to overcome the unmatched matrix and out of memory issue 
DSBSCTime=resampledSignal.*transpose(carrierSignal);
%DSC-SC in frequency domain
DSBSCFrequency=fftshift(fft(DSBSCTime));
%Show figure 3
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(DSBSCTime);
title('DSB-SC Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(FrequencyRange,abs(DSBSCFrequency));
title('DSB-SC Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');

%%%%%%%%%%%%%%%%  DSB-TC  %%%%%%%%%%%%%%%%
% modulation index
modulationIndex=0.5;
% Carrier amplitude
Ac=2*max(resampledSignal);
% m(t) = x(n)/ max(x(n)) Normalized Signal
normalizedSignal=resampledSignal/max(resampledSignal);
carrierSignal=Ac*carrierSignal;
% DSB-TC time domaim
DSBTCTime=(1+(modulationIndex*normalizedSignal)).*transpose(carrierSignal);
% DSB-TC frequency domaim
DSBTCFrequency=fftshift(fft(DSBTCTime));

%Show figure 4
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(time,DSBTCTime);
title('DSB-TC Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(FrequencyRange,abs(DSBTCFrequency));
title('DSB-TC Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Applying envelope filter
envelopeDSBSC=abs(hilbert(DSBSCTime));
envelopeDSBTC=abs(hilbert(DSBTCTime));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Resampling the signal again to it's original frequency
ResampledenvelopeDSBSC=resample(envelopeDSBSC,Fs,Fm);
samplesNumber=length(ResampledenvelopeDSBSC);
time=linspace(0,samplesNumber/Fs, samplesNumber);
%generating sound with Fs freq.
sound(ResampledenvelopeDSBSC, Fs);
%Show figure 5
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
plot(time,ResampledenvelopeDSBSC);
title('Resampled Envelope DSB-SC');
xlabel('Time');
ylabel('Amplitude');
pause(10);
 
ResampledenvelopeDSBTC=resample(envelopeDSBTC,Fs,Fm);
samplesNumber=length(ResampledenvelopeDSBTC);
time=linspace(0,samplesNumber/Fs, samplesNumber);
sound(ResampledenvelopeDSBTC, Fs);
%Show figure 6
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
plot(time,ResampledenvelopeDSBTC);
title('Resampled Envelope DSB-TC');
xlabel('Time');
ylabel('Amplitude');
pause(5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%add white gausian noises
DSBTC_noise0=awgn(DSBTCTime,0,'measured');  
DSBTC_noise10=awgn(DSBTCTime,10,'measured');
DSBTC_noise30=awgn(DSBTCTime,30,'measured');
%passing through envelope detector
EnvelopeNoise0=abs(hilbert(DSBTC_noise0));
EnvelopeNoise10=abs(hilbert(DSBTC_noise10));
EnvelopeNoise30=abs(hilbert(DSBTC_noise30));
%resampling signal
%Fm=5Fc
EnvelopeNoise0=resample(EnvelopeNoise0,Fs,Fm);
EnvelopeNoise10=resample(EnvelopeNoise10,Fs,Fm);
EnvelopeNoise30=resample(EnvelopeNoise30,Fs,Fm);
%Time range
samplesNumber=length(EnvelopeNoise0);
time= linspace(0,samplesNumber/Fs,samplesNumber);
%Show figure 7
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
subplot(3,1,1);
plot(time,EnvelopeNoise0);
title('Received DSB-TC with SNR=0');
subplot(3,1,2);
plot(time,EnvelopeNoise10);
title('Received DSB-TC with SNR=10');
subplot(3,1,3);
plot(time,EnvelopeNoise30);
title('Received DSB-TC with SNR=30')

sound(EnvelopeNoise0,Fs);
pause(10);

sound(EnvelopeNoise10,Fs);
pause(10);

sound(EnvelopeNoise30,Fs);
pause(10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 9 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%add white gausian noises
DSBSC_noise0=awgn(DSBSCTime,0,'measured');  
DSBSC_noise10=awgn(DSBSCTime,10,'measured');
DSBSC_noise30=awgn(DSBSCTime,30,'measured');
%Demodulation
DSBSC_noise0_Demodulation_Time=DSBSC_noise0.*transpose(carrierSignal);
DSBSC_noise10_Demodulation_Time=DSBSC_noise10.*transpose(carrierSignal);
DSBSC_noise30_Demodulation_Time=DSBSC_noise30.*transpose(carrierSignal);
%Resampling
DSBSC_noise0_Demodulation_Time=resample(DSBSC_noise0_Demodulation_Time,Fs,Fm);
DSBSC_noise10_Demodulation_Time=resample(DSBSC_noise10_Demodulation_Time,Fs,Fm);
DSBSC_noise30_Demodulation_Time=resample(DSBSC_noise30_Demodulation_Time,Fs,Fm);
%Resampling in frequency domain
DSBSC_noise0_Demodulation_Frequency=fftshift(fft(DSBSC_noise0_Demodulation_Time));
DSBSC_noise10_Demodulation_Frequency=fftshift(fft(DSBSC_noise10_Demodulation_Time));
DSBSC_noise30_Demodulation_Frequency=fftshift(fft(DSBSC_noise30_Demodulation_Time));
%Time range
samplesNumber=length(DSBSC_noise0_Demodulation_Time);
%frequency range
time= linspace(0,samplesNumber/Fs,samplesNumber);
frequencyRange= -Fs/2:Fs/samplesNumber:Fs/2-Fs/samplesNumber;
%generate sound Fs freq.
sound(DSBSC_noise0_Demodulation_Time,Fs);
%Show figure 8
%Plot and play Noise 0 Signal Time and frequency Domain
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(time,DSBSC_noise0_Demodulation_Time);
title('Received DSB-SC SNR= 0 dB in Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(frequencyRange,abs(DSBSC_noise0_Demodulation_Frequency));
title('Received DSB-SC SNR= 0 dB in Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
pause(10);

%Plot and play Noise 10 Signal Time and frequency Domain
sound(DSBSC_noise10_Demodulation_Time,Fs);
%Show figure 9
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(time,DSBSC_noise10_Demodulation_Time);
title('Received DSB-SC SNR= 10 dB in Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(frequencyRange,abs(DSBSC_noise10_Demodulation_Frequency));
title('Received DSB-SC SNR= 10 dB in Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
pause(10);

%Plot and play Noise 30 Signal Time and frequency Domain
sound(DSBSC_noise30_Demodulation_Time,Fs);
%Show figure 10
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(time,DSBSC_noise30_Demodulation_Time);
title('Received DSB-SC SNR= 30 dB in Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(frequencyRange,abs(DSBSC_noise30_Demodulation_Frequency));
title('Received DSB-SC SNR= 30 dB in Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
pause(10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 10 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%New Fc=100.1KHz instead of 100KHz
Fc=100100;
samplesNumber=length(DSBSCTime);
%Time range
time=linspace(0,samplesNumber/Fm, samplesNumber);
%freq. range
FrequencyRange=-(Fm/2) : Fm/samplesNumber : (Fm/2) - Fm/samplesNumber;
%Carrier signal
carrierSignal=cos(2*pi*Fc*time);
%add white gausian noises
DSBSC_noise0=awgn(DSBSCTime,0,'measured');  
DSBSC_noise10=awgn(DSBSCTime,10,'measured');
DSBSC_noise30=awgn(DSBSCTime,30,'measured');
%Demodulation
DSBSC_noise0_Demodulation_Time=DSBSC_noise0.*transpose(carrierSignal);
DSBSC_noise10_Demodulation_Time=DSBSC_noise10.*transpose(carrierSignal);
DSBSC_noise30_Demodulation_Time=DSBSC_noise30.*transpose(carrierSignal);
%Resampling
DSBSC_noise0_Demodulation_Time=resample(DSBSC_noise0_Demodulation_Time,Fs,Fm);
DSBSC_noise10_Demodulation_Time=resample(DSBSC_noise10_Demodulation_Time,Fs,Fm);
DSBSC_noise30_Demodulation_Time=resample(DSBSC_noise30_Demodulation_Time,Fs,Fm);
%Resampling in frequency domain
DSBSC_noise0_Demodulation_Frequency=fftshift(fft(DSBSC_noise0_Demodulation_Time));
DSBSC_noise10_Demodulation_Frequency=fftshift(fft(DSBSC_noise10_Demodulation_Time));
DSBSC_noise30_Demodulation_Frequency=fftshift(fft(DSBSC_noise30_Demodulation_Time));
samplesNumber=length(DSBSC_noise0_Demodulation_Time);
time= linspace(0,samplesNumber/Fs,samplesNumber);
frequencyRange= (-Fs/2:Fs/samplesNumber:Fs/2-Fs/samplesNumber);
%Show figure 11
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
sound(DSBSC_noise0_Demodulation_Time,Fs);
subplot(2,1,1);
plot(time,DSBSC_noise0_Demodulation_Time)
title('DSB-SC Demodulation with Frequency Error=100.1KHz SNR=0 Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(frequencyRange,abs(DSBSC_noise0_Demodulation_Frequency))
title('DSB-SC Demodulation with Frequency Error=100.1KHz SNR=0 Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
pause(10);

%Show figure 12
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
sound(DSBSC_noise10_Demodulation_Time,Fs);
subplot(2,1,1);
plot(time,DSBSC_noise10_Demodulation_Time)
title('DSB-SC Demodulation with Frequency Error=100.1KHz SNR=10 Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(frequencyRange,abs(DSBSC_noise10_Demodulation_Frequency))
title('DSB-SC Demodulation with Frequency Error=100.1KHz SNR=10 Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
pause(10);

%Show figure 13
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
sound(DSBSC_noise30_Demodulation_Time,Fs);
subplot(2,1,1);
plot(time,DSBSC_noise30_Demodulation_Time)
title('DSB-SC Demodulation with Frequency Error=100.1KHz SNR=30 Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(frequencyRange,abs(DSBSC_noise30_Demodulation_Frequency))
title('DSB-SC Demodulation with Frequency Error=100.1KHz SNR=30 Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
pause(10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 11 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%carrier freq. 100KHz
Fc=100000;
samplesNumber=length(DSBSCTime);
time=linspace(0,samplesNumber/Fs, samplesNumber);
FrequencyRange=-(Fm/2) : Fm/samplesNumber : (Fm/2) - Fm/samplesNumber;
%Carrier with Phase error 20 deg.
carrierSignal=cos((2*pi*Fc*time) + deg2rad(20));
%Demodulation
DSBSC_noise0_Demodulation_Time=DSBSC_noise0.*transpose(carrierSignal);
DSBSC_noise10_Demodulation_Time=DSBSC_noise10.*transpose(carrierSignal);
DSBSC_noise30_Demodulation_Time=DSBSC_noise30.*transpose(carrierSignal);
%Resampling
DSBSC_noise0_Demodulation_Time=resample(DSBSC_noise0_Demodulation_Time,Fs,Fm);
DSBSC_noise10_Demodulation_Time=resample(DSBSC_noise10_Demodulation_Time,Fs,Fm);
DSBSC_noise30_Demodulation_Time=resample(DSBSC_noise30_Demodulation_Time,Fs,Fm);
%Resampling in frequency domain
DSBSC_noise0_Demodulation_Frequency=fftshift(fft(DSBSC_noise0_Demodulation_Time));
DSBSC_noise10_Demodulation_Frequency=fftshift(fft(DSBSC_noise10_Demodulation_Time));
DSBSC_noise30_Demodulation_Frequency=fftshift(fft(DSBSC_noise30_Demodulation_Time));
samplesNumber=length(DSBSC_noise0_Demodulation_Time);
time= linspace(0,samplesNumber/Fs,samplesNumber);
frequencyRange= (-Fs/2:Fs/samplesNumber:Fs/2-Fs/samplesNumber);
%Show figure 14
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
sound(DSBSC_noise0_Demodulation_Time,Fs);
subplot(2,1,1);
plot(time,DSBSC_noise0_Demodulation_Time)
title('DSB-SC Demodulation with Phase Error=20 degree SNR=0 Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(frequencyRange,abs(DSBSC_noise0_Demodulation_Frequency))
title('DSB-SC Demodulation with Phase Error=20 degree SNR=0 Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
pause(10);

%Show figure 15
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
sound(DSBSC_noise10_Demodulation_Time,Fs);
subplot(2,1,1);
plot(time,DSBSC_noise10_Demodulation_Time)
title('DSB-SC Demodulation with Phase Error=20 degree SNR=10 Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(frequencyRange,abs(DSBSC_noise10_Demodulation_Frequency))
title('DSB-SC Demodulation with Phase Error=20 degree SNR=10 Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
pause(10);

%Show figure 16
figure ('Name','DOUBLE SIDEBAND MODULATION','NumberTitle','off');
sound(DSBSC_noise30_Demodulation_Time,Fs);
subplot(2,1,1);
plot(time,DSBSC_noise30_Demodulation_Time)
title('DSB-SC Demodulation with Phase Error=20 degree SNR=30 Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot(2,1,2);
plot(frequencyRange,abs(DSBSC_noise30_Demodulation_Frequency))
title('DSB-SC Demodulation with Phase Error=20 degree SNR=30 Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
pause(10);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXPERIMENT ONE: DOUBLE SIDEBAND MODULATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%  Time Domain  %%%%%%%%%%%%%%%%
[signal,Fs] = audioread('eric.wav'); samplesNumber = length(signal);
time= linspace(0,samplesNumber/Fs,samplesNumber);
frequencyDomainSignal=fftshift(fft(signal));
frequencyRange=(-Fs/2:Fs/samplesNumber:Fs/2-Fs/samplesNumber);
figure ('Name','FREQUENCY MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(time,signal);
title('Original Signal in Time Domain');
ylabel('Amplitude');
xlabel('Time');
subplot(2,1,2);
plot(frequencyRange,abs(frequencyDomainSignal));
title('Original Signal in Frequency Domain');
ylabel('Amplitude');
xlabel('Frequency');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize cut off frequency
cutoffFrequency=4000/(Fs/2);
%using a low pass filter
[denumerator,numerator]=butter(20,cutoffFrequency,'low');
filteredSignalTime=filter(denumerator,numerator,signal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filteredSignalFrequency=fftshift(fft(filteredSignalTime));
%Show figure 2
figure ('Name','FREQUENCY MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(time,filteredSignalTime);
title('Signal filtered by Low pass filter in Time Domain');
ylabel('Amplitude');
xlabel('Time');
subplot(2,1,2);
plot(frequencyRange,abs(filteredSignalFrequency));
title('Signal filtered by Low pass filter in Frequency Domain');
ylabel('Amplitude');
xlabel('Frequency');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sound(filteredSignalTime,Fs);
pause(5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fc=100000;
resampledSignal=resample(filteredSignalTime,Fm,Fs);
time=linspace(0,length(resampledSignal)/(Fm),length(resampledSignal))
%Integeration of m(t)
MessageIntegeration=cumsum(resampledSignal');
NBFMTime=cos((2*pi*Fc*time)+MessageIntegeration)
samplesNumber = length(NBFMTime);
FrequencyRange=(-(Fm)/2:(Fm)/samplesNumber:(Fm)/2-(Fm)/samplesNumber);
NBFMFrequency=fftshift(fft(NBFMTime));
figure ('Name','FREQUENCY MODULATION','NumberTitle','off');
subplot(2,1,1);
plot(time,NBFMTime);
title('NBFM Signal in Time Domain');
xlabel('Time')
ylabel('Amplitude');
subplot(2,1,2);
plot(FrequencyRange,abs(NBFMFrequency));
title('NBFM Signal in Frequency Domain');
xlabel('Frequency')
ylabel('Amplitude');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%NB frequency demodulation
NBFD=diff(NBFMTime);
%Creating a matrix
NBFD=[0,NBFD];
%Envelope detector
envelopeNBFD=abs(hilbert(NBFD));
%Resampling  
%Fm = 5Fc
ResampledenvelopeNBFD=resample(envelopeNBFD,Fs,Fm);

