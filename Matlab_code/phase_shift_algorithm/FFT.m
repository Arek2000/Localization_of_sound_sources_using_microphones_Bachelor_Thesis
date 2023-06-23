Fs = 3000;
Ts = 1/Fs;
dt = 0:Ts:0.05-Ts;  %Duration of the signal od 0 do 2-Ts ze skokiem Ts
f1 = 1000;
f2 = 10000;
f3 = 12000;

%y = A*sin(wt+theta)
y1_1 = 10*sin(2*pi*f1*dt);
y1_2 = 10*sin(2*pi*f2*dt);
y1_3 = 10*sin(2*pi*f3*dt);
y1_4 = y1_1+rand(1,length(y1_1));

y2_1 = 10*sin(2*pi*f1*dt+1.1*pi/2);
y2_2 = 10*sin(2*pi*f2*dt+pi/2);
y2_3 = 10*sin(2*pi*f3*dt+pi);
y2_4 = y2_1+rand(1,length(y2_1));
% subplot(4,1,1);
% plot(dt,y1,'r');
% 
% subplot(4,1,2);
% plot(dt,y2,'r');
% 
% subplot(4,1,3);
% plot(dt,y3,'r');
% 
% subplot(4,1,4);
% plot(dt,y4,'r');

nfft = length(y1_4);  %length of time domain signal
nfft2 = 2^nextpow2(nfft);   %length of signal in power of 2
ff = fft(y1_4,nfft2);
fff = ff(1:nfft2/2);
xfft = Fs*(0:nfft2/2-1)/nfft2;
phase1 = angle(fff);

nfft = length(y2_4);  %length of time domain signal
nfft2 = 2^nextpow2(nfft);   %length of signal in power of 2
ff2 = fft(y2_4,nfft2);
fff2 = ff2(1:nfft2/2);
xfft = Fs*(0:nfft2/2-1)/nfft2;
phase2 = angle(fff2);
%phase = fftshift(fff);
%phase = unwrap(phase);

subplot(3,1,1);
plot(dt,y1_4);
xlabel('Time [s]');
ylabel('Amplitude [V]');
title('Time Domain Signal');

subplot(3,1,2);
plot(xfft,abs(fff));
xlabel('Frequency [Hz]');
ylabel('Normalized Amplitude');
title('Frequency Domain Signal');

subplot(3,1,3);
plot(xfft,phase1*180/(2*pi));
ylabel('phase [deg]');
xlabel('frequency [Hz]');
title('Frequency Domain Signal');
[maxval,indeks1_1] = max(fff);
phase1_1 = rad2deg(phase1(indeks1_1));
fff(indeks1_1) = 0;
[maxval,indeks1_2] = max(fff);
phase1_2 = rad2deg(phase1(indeks1_2));
fff(indeks1_2) = 0;
[maxval,indeks1_3] = max(fff);
phase1_3 = rad2deg(phase1(indeks1_3));
fff(indeks1_3) = 0;

[maxval,indeks2_1] = max(fff2);
phase2_1 = rad2deg(phase2(indeks2_1));
fff2(indeks2_1) = 0;
[maxval,indeks2_2] = max(fff2);
phase2_2 = rad2deg(phase2(indeks2_2));
fff2(indeks2_2) = 0;
[maxval,indeks2_3] = max(fff2);
phase2_3 = rad2deg(phase2(indeks2_3));
fff2(indeks2_3) = 0;


