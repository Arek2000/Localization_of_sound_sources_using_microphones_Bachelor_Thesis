Fs = 250000;  %sampling frequency
side_length = 0.015;
data = fopen('2.csv');   %open csv file
readData = textscan(data,'%f %f %f %f %f','Delimiter',',');

ch1 = readData{1,1}(:,1);
ch2 = readData{1,2}(:,1);
ch3 = readData{1,3}(:,1);
ch4 = readData{1,4}(:,1);

%BandPass filter:
% %40kHz:
% BandPassLow = 39980;
% BandPassHigh = 40020;
% frequency = 40000;

% %35kHz:
% BandPassLow = 34980;
% BandPassHigh = 35020;
% frequency = 35000;

% %30kHz:
% BandPassLow = 29980;
% BandPassHigh = 30020;
% frequency = 30000;
% 
%25kHz:
% BandPassLow = 24980;
% BandPassHigh = 25020;
% frequency = 25000;
% 
% bpFilterInit = designfilt('bandpassiir','FilterOrder',4,'HalfPowerFrequency1',BandPassLow,'HalfPowerFrequency2',BandPassHigh,'SampleRate',Fs);

% %Filtering:
% ch1_fil = filter(bpFilterInit,ch1);
% ch2_fil = filter(bpFilterInit,ch2);
% ch3_fil = filter(bpFilterInit,ch3);
% ch4_fil = filter(bpFilterInit,ch4);
% 
% %Finding front of the wave:
% [ch1_fil,ch2_fil,ch3_fil,ch4_fil] = frontWave(ch1_fil,ch2_fil,ch3_fil,ch4_fil);

% %Fourier Transform:
% [f1,xfft1,phase1] = fourier(ch1_fil,Fs);
% [f2,xfft2,phase2] = fourier(ch2_fil,Fs);
% [f3,xfft3,phase3] = fourier(ch3_fil,Fs);
% [f4,xfft4,phase4] = fourier(ch4_fil,Fs);

% subplot(2,1,1);
% hold on;
% plot(ch1_fil);
% plot(ch2_fil);
% plot(ch3_fil);
% plot(ch4_fil);
% legend('1','2','3','4');
% ylabel('Amplitude [V]');
% xlabel('time [s]');
% title('Time Domain Signal');
% 
% subplot(2,1,2);
% hold on;
% plot(xfft1,abs(f1));
% plot(xfft2,abs(f2));
% plot(xfft3,abs(f3));
% plot(xfft4,abs(f4));
% ylabel('Amplitude [V]');
% xlabel('Frequency [Hz]');
% title('Frequency Domain Signal');

% %phase_shifts:
% ph1 = phase_shift(f1,phase1);
% ph2 = phase_shift(f2,phase2);
% ph3 = phase_shift(f3,phase3);
% ph4 = phase_shift(f4,phase4);

% ph1 = 0;
% ph2 = 120;
% ph3 = 180;
% ph4 = 0;

%angle = angle_calc(frequency,ph1,ph2,ph3,ph4);
% [azimuth,elevation] = angle_calc(frequency,ph1,ph2,ph3,ph4);
Angles = [];
length = 1;
for frequency = 25000:5000:40000
    bpFilterInit = designfilt('bandpassiir','FilterOrder',4,'HalfPowerFrequency1',frequency-20,'HalfPowerFrequency2',frequency+20,'SampleRate',Fs);

    %Filtering:
    ch1_fil = filter(bpFilterInit,ch1);
    ch2_fil = filter(bpFilterInit,ch2);
    ch3_fil = filter(bpFilterInit,ch3);
    ch4_fil = filter(bpFilterInit,ch4); 

    %Finding front of the wave:
    [ch1_fil,ch2_fil,ch3_fil,ch4_fil] = frontWave(ch1_fil,ch2_fil,ch3_fil,ch4_fil);

    %Graphs:
    hold on;
    figure(1);
    plot(ch1_fil);
    %plot(ch2_fil);
    %plot(ch3_fil);
    %plot(ch4_fil);
    legend('1','2','3','4');
    ylabel('Amplitude [V]');
    xlabel('time [s]');
    title('Time Domain Signal');

    %Run function
    [azimuth,elevation] = angle_calc3(ch1_fil,ch2_fil,ch3_fil,ch4_fil,frequency);
    % x = cosa * c
    x = cosd(azimuth + 90) * length;
    % y = sina * c
    y = sind(azimuth + 90) * length;
    vector = [x y];
    Angles = [Angles; vector];
    disp([frequency, ": ", azimuth]);
end


hold on;
%1 Angles_correct = [-22, 155, 15, 144];
Angles_correct = [-35, 152, 15, 143];
Correct = [];
for index=1:1:4
    % x = cosa * c
    x = cosd(Angles_correct(index) + 90) * length;
    % y = sina * c
    y = sind(Angles_correct(index) + 90) * length;
    vector = [x y];
    Correct = [Correct; vector];
end
starts = zeros(size(Angles));
figure
hold on
quiver(starts(:,1), starts(:,2), Angles(:,1), Angles(:,2), 'r');
quiver(starts(:,1), starts(:,2), Correct(:,1), Correct(:,2), 'g')
axis equal
hold off


% function [Fft,xfft,phase] = fourier(sig,Fs)
% nfft = length(sig);         %length of time domain signal
% nfft2 = 2^nextpow2(nfft);   %length of signal in power of 2
% Fft = fft(sig,nfft2);
% Fft = Fft(1:nfft2/2);
% xfft = Fs*(0:nfft2/2-1)/nfft2;
% %phase = angle(fff);         %phase shift in radians
% %phase = fftshift(fff);         %phase shift in radians
% phase = angle(Fft);         %phase shift in radians
% %fft_amp = abs(fff);
% end

function [sig_out1,sig_out2,sig_out3,sig_out4] = frontWave(sig1,sig2,sig3,sig4)
min_val = min(sig1);
max_val = max(sig1);
start = 0;
final_length = 512;
for i = 1:1:length(sig1)
    if sig1(i)>0.1*abs(max_val-min_val)
        start = i+7+5000;
        break
    end
end
sig_out1 = sig1(start:start+final_length);
sig_out2 = sig2(start:start+final_length);
sig_out3 = sig3(start:start+final_length);
sig_out4 = sig4(start:start+final_length);
end

function phase_max = phase_shift(fft_sig,phase)
[~,indeks] = max(abs(fft_sig));
phase_max = rad2deg(phase(indeks));
end
