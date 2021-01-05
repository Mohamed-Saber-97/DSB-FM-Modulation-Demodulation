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
