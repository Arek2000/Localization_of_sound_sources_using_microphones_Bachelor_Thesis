clear device;
speed_of_sound = 343;   % m/s
Fs = 125000;            % Sampling frequency
bpFilterInit = designfilt('bandpassiir','FilterOrder',4,'HalfPowerFrequency1',1000,'HalfPowerFrequency2',14000,'SampleRate',Fs);
global angles_of_arrival;
angles_of_arrival = [];

device = serialport("COM5",921600);
configureTerminator(device,"CR");
configureCallback(device, "byte", 6600, @(src, evt) callbackFcn(src, Fs, bpFilterInit, speed_of_sound));

function callbackFcn(src, Fs, filtr, speed_of_sound, ~)
    global angles_of_arrival;
    data = read(src, 6600, "uint16");
    ch1 = data(1:3:end);
    ch2 = data(2:3:end);
    ch3 = data(3:3:end);
    
    ch1_fil = filter(filtr,double(ch1));
    ch2_fil = filter(filtr,double(ch2));
    ch3_fil = filter(filtr,double(ch3));

    [ch1_phase, ch1_frequency, ch1_amplitude] = phase_shift(ch1_fil(201:end), Fs);
    [ch2_phase, ch2_frequency, ch2_amplitude] = phase_shift(ch2_fil(201:end), Fs);
    [ch3_phase, ch3_frequency, ch3_amplitude] = phase_shift(ch3_fil(201:end), Fs);

    if (ch1_amplitude >= 7 ||  ch2_amplitude >= 7 ||  ch3_amplitude >= 7) && ((ch1_frequency == ch2_frequency) && (ch2_frequency == ch3_frequency))
    
    disp(" ");

    %ch1 - ch2 difference:
    if ch1_phase > 0 && ch2_phase > 0
        if abs(ch1_phase-ch2_phase) < 180
            phase_difference_1_2 = ch1_phase - ch2_phase;
        else
            if ch1_phase > ch2_phase
                phase_difference_1_2 = 360 - (ch1_phase - ch2_phase);
            else
                phase_difference_1_2 = -(360 - (ch2_phase - ch1_phase)); 
            end    
        end
    end
    
    if ch1_phase > 0 && ch2_phase < 0
        if abs(ch1_phase-ch2_phase) < 180
            phase_difference_1_2 = ch1_phase - ch2_phase;
        else
            phase_difference_1_2 = -(360 - (ch1_phase - ch2_phase));  
        end
    end

    if ch1_phase < 0 && ch2_phase > 0
        if abs(ch2_phase-ch1_phase) < 180
            phase_difference_1_2 = ch1_phase - ch2_phase;
        else
            phase_difference_1_2 = (360 - (ch2_phase - ch1_phase));  
        end
    end

    if ch1_phase < 0 && ch2_phase < 0
        if abs(ch2_phase - ch1_phase) < 180
            phase_difference_1_2 = ch1_phase - ch2_phase;
        else
            if ch1_phase < ch2_phase
                phase_difference_1_2 = 360 + (ch2_phase - ch1_phase);
            else
                phase_difference_1_2 = -(360 + (ch1_phase - ch2_phase)); 
            end    
        end
    end
    
    %ch2 - ch3 difference:
    if ch2_phase > 0 && ch3_phase > 0
        if abs(ch2_phase-ch3_phase) < 180
            phase_difference_2_3 = ch2_phase - ch3_phase;
        else
            if ch2_phase > ch3_phase
                phase_difference_2_3 = 360 - (ch2_phase - ch3_phase);
            else
                phase_difference_2_3 = -(360 - (ch3_phase - ch2_phase)); 
            end    
        end
    end
    
    if ch2_phase > 0 && ch3_phase < 0
        if abs(ch2_phase-ch3_phase) < 180
            phase_difference_2_3 = ch2_phase - ch3_phase;
        else
            phase_difference_2_3 = -(360 - (ch2_phase - ch3_phase));  
        end
    end

    if ch2_phase < 0 && ch3_phase > 0
        if abs(ch3_phase-ch2_phase) < 180
            phase_difference_2_3 = ch2_phase - ch3_phase;
        else
            phase_difference_2_3 = (360 - (ch3_phase - ch2_phase));  
        end
    end

    if ch2_phase < 0 && ch3_phase < 0
        if abs(ch3_phase - ch2_phase) < 180
            phase_difference_2_3 = ch2_phase - ch3_phase;
        else
            if ch2_phase < ch3_phase
                phase_difference_2_3 = 360 + (ch3_phase - ch2_phase);
            else
                phase_difference_2_3 = -(360 + (ch2_phase - ch3_phase)); 
            end    
        end
    end
    
    phase_difference_1_3 = phase_difference_1_2 + phase_difference_2_3;

    % Calculating the distance difference between microphones 1 and 3:
    distance_difference = (speed_of_sound/ch3_frequency * phase_difference_1_3/360);
    d = 2*0.0127; %distance between 2 microphones
    x = 100;  %random value
    
    cos_a = (d^2+2*x*distance_difference+distance_difference^2)/(2*d*(x+distance_difference));

    if phase_difference_1_3 > 0
        angle_of_arrival = -(90 - acosd(abs(cos_a)));
    else
        angle_of_arrival = (90 - acosd(abs(cos_a)));
    end

    % If result of cos is greater than 1 it means thar measurements were
    % incorrect and this angle must be ignored:
    if not(isreal(angle_of_arrival))
        return
    end

    angles_of_arrival = [angles_of_arrival, angle_of_arrival];
    
    % Presenting average angle from last 20 measurements:
    if length(angles_of_arrival) >= 5
        disp(["angle:", mean(angles_of_arrival)]);
        DOADisplay(mean(angles_of_arrival));
        angles_of_arrival = [];
    end
    end
end

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

function display_measurements(ch1, ch2, ch3)
    clf;
    plot(ch1);
    hold on;
    plot(ch2);
    plot(ch3);
    legend('1','2','3');
    hold off;
end

function DOADisplay(angles)         %angle in degrees
    x = 0;                          % X coordinate of arrow start
    y = 0;                          % Y coordinate of arrow start
    L = 2;                          % Length of arrow
    xEnds = [];
    yEnds = [];
    for angle=1:length(angles)  
        theta = deg2rad(angles(angle));             % Angle of arrow, from x-axis
        xEnds = [xEnds, x+L*cos(theta)];            % X coordinate of arrow end
        yEnds = [yEnds, y+L*sin(theta)];            % Y coordinate of arrow end
    end
    Z = compass(xEnds, yEnds);
    colors = get(0,'DefaultAxesColorOrder');
    for i=1:length(Z)
        set(Z(i),'color',colors(mod(i-1,length(colors))+1,:),'linewidth',2)
    end
    view(90,90);
end
