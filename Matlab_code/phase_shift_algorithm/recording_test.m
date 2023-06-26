Fs = 96000;  %sampling frequency
noc = 2;  %number of channels
nob = 16;  %number of bits per sample
t_rec = 5;  %recording duration
d = 0.062;    %distance between microphones in m
min_wave_length = d/2;
min_freq = 344/min_wave_length;

recObj = audiorecorder(Fs,nob,noc);  %recording object

recordblocking(recObj,t_rec);
recording  = getaudiodata(recObj);
ch1 = recording(:,1);   %channel1
ch2 = recording(:,2);   %channel2
play(recObj);
[f1,xfft1,phase1] = fourier(ch1,Fs);
[f2,xfft2,phase2] = fourier(ch2,Fs);

% subplot(2,1,1);
plot(xfft1,f1);
xlabel('Frequency [Hz]');
ylabel('Normalized Amplitude');
title('Frequency Domain Signal');

% subplot(2,1,2);
% plot(xfft1,rad2deg(phase1));
% ylabel('phase [deg]');
% xlabel('frequency [Hz]');
% title('Frequency-phase Domain Signal');

[maxval1,indeks1] = max(f1);
phase_dif1 = rad2deg(phase1(indeks1));

[maxval2,indeks2] = max(f2);
phase_dif2 = rad2deg(phase2(indeks2));

phase_shift = phase_dif1-phase_dif2;

% subplot(2,1,1);
% plot(ch1);
% subplot(2,1,2);
% plot(ch2);
%play(recObj);

function [fft_amp,xfft,phase] = fourier(sig,Fs)
nfft = length(sig);         %length of time domain signal
nfft2 = 2^nextpow2(nfft);   %length of signal in power of 2
ff = fft(sig,nfft2);
fff = ff(1:nfft2/2);
xfft = Fs*(0:nfft2/2-1)/nfft2;
phase = angle(fff);         %phase shift in radians
fft_amp = abs(fff);
end
