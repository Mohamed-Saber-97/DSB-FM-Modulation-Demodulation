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
