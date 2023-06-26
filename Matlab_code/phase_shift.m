function [phase_max, frequency_max, amplitude_max] = phase_shift(sig, sampling_frequency)
    fft_sig = fft(sig);
    L = length(sig);
    P2 = abs(fft_sig/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = sampling_frequency*(0:(L/2))/L;
    [~,index] = max(P1);
    frequency_max = f(index);
    amplitude_max = P1(index);
    P2 = rad2deg(angle(fft_sig));
    P1 = P2(1:L/2+1);
    phase_max = P1(index);
end