Fs = 44100;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 480;             % Length of signal
t = (0:L-1)*T;        % Time vector

bpFilterInit = designfilt('bandpassiir','FilterOrder',4,'HalfPowerFrequency1',1100,'HalfPowerFrequency2',1300,'SampleRate',Fs);
S = 0.7*sin(2*pi*500*t) + sin(2*pi*1200*t);

X = filter(bpFilterInit, S) + 2*randn(size(t));

figure(1);
plot(1000*t(1:50),X(1:50))
title("Signal Corrupted with Zero-Mean Random Noise")
xlabel("t (milliseconds)")
ylabel("X(t)")

Y = fft(X);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
figure(2);
plot(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")

Y = fft(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure(3);
plot(f,P1) 
title("Single-Sided Amplitude Spectrum of S(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")