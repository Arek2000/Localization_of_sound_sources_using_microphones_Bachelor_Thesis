sample = [1 2 3 4 5 6 7 8];

ch1 = sample(1:2:end);
ch2 = sample(2:2:end);

L = length(ch1);
Fs = 160000;

bpFilterInit = designfilt('bandpassiir','FilterOrder',4,'HalfPowerFrequency1',21100,'HalfPowerFrequency2',21200,'SampleRate',Fs);

%Filtering:
ch1_fil = filter(bpFilterInit,double(ch1));
ch2_fil = filter(bpFilterInit,double(ch2));

ch1_phase = phase_shift(ch1_fil, Fs);
ch2_phase = phase_shift(ch2_fil, Fs);

%{
Y = fft(sample_fil);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
figure(1);
plot(f,P1)
xlim([1000 80000]);
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")

P2 = angle(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
figure(2);
plot(f,P1)
xlim([50 80000]);
title("Single-Sided Phase Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("phase P1(f)")
%}

function phase_max = phase_shift(sig, sampling_frequency)
    fft_sig = fft(sig);
    [~,indeks] = max(abs(fft_sig));

    figure(2);
    L = length(sig);
    P2 = abs(fft_sig/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = sampling_frequency*(0:(L/2))/L;
    plot(f,P1);
    figure(3);
    plot(rad2deg(angle(fft_sig)))

    phase_max = rad2deg(angle(fft_sig(indeks)));
    %if imag(fft_sig(indeks)) <=0
    %    phase_max = phase_max + 360;
    %end
    %phase_max = 360-phase_max;
end
