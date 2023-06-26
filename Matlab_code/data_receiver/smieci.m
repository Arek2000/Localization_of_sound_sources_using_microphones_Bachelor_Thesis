%clf;
    %hold on;
    %legend('1','2');
    %plot(ch1);
    %plot(ch2);
    %plot(ch3_fil(201:end));
    %plot(ch4(200:end));
    %hold off;
    %ch3 = data(3:3:end);
    %ch4 = data(4:4:end);
    %L = length(ch1);


    %clf;
    %hold on;
    %legend('1','2','3');
    %plot(ch1_fil(201:end));
    %plot(ch2_fil(201:end));
    %plot(ch3_fil(201:end));
    %plot(ch4(200:end));
    %hold off;

%disp(["ch1 phase:", ch1_phase]);
    %disp(["ch2 phase:", ch2_phase]);
    %disp(["ch3 phase:", ch3_phase]);
    %disp(["ch1 amplitude:", ch1_amplitude]);
    %disp(["ch2 amplitude:", ch2_amplitude]);
    %disp(["ch3 amplitude:", ch3_amplitude]);
    %clf;
    %figure(2);
    %hold on;
    %legend('1','2','3');
    %plot(ch1_fil(201:end));
    %plot(ch2_fil(201:end));
    %plot(ch3_fil(201:end));
    %plot(ch4(200:end));
    %hold off;
    %phase = [ch1_phase ch2_phase ch3_phase ch4_phase];
    %[index, value] = min(phase);
    %ch2_phase = ch2_phase - ch1_phase;
    %ch3_phase = ch3_phase - ch1_phase;
    %ch4_phase = ch4_phase - ch1_phase;
    %ch1_phase = 0;
    % measure delay:
    %angle_delay = (ch1_frequency/Fs) * 360;

% correct angles:
    %if ch1_phase < 0
    %    ch1_phase = ch1_phase + 360;
    %end
    %ch2_phase = ch2_phase + angle_delay;
    %if ch2_phase < 0
    %    ch2_phase = ch2_phase + 360;
    %end
    %ch3_phase = ch3_phase + angle_delay * 2;
    %if ch3_phase < 0
    %    ch3_phase = ch3_phase + 360;
    %end
    %ch4_phase = ch4_phase + angle_delay * 3;
    %if ch4_phase < 0
    %    ch4_phase = ch4_phase + 360;
    %end

    %disp(["ch1_phase: ", ch1_phase]);
    %disp(["ch2_phase: ", ch2_phase]);
    %disp(["ch3_phase: ", ch3_phase]);
    %disp(["ch4_phase: ", ch4_phase]);

%phase_difference_1_2 = ch1_phase - (ch2_phase + angle_delay);
    %if phase_difference_1_2 > 180
    %    phase_difference_1_2 = 360 - phase_difference_1_2;
    %end
    %if phase_difference_1_2 < -180
    %    phase_difference_1_2 = -360 - phase_difference_1_2;
    %end

    %phase_difference_2_3 = ch2_phase - (ch3_phase + angle_delay);
    %if phase_difference_2_3 > 180
    %    phase_difference_2_3 = 360 - phase_difference_2_3;
    %end
    %if phase_difference_2_3 < -180
    %    phase_difference_2_3 = -360 - phase_difference_2_3;
    %end
    
    %phase_difference_3_4 = ch3_phase - (ch4_phase + angle_delay);
    %if phase_difference_3_4 > 180
    %    phase_difference_3_4 = 360 - phase_difference_3_4;
    %end
    %if phase_difference_3_4 < -180
    %    phase_difference_3_4 = -360 - phase_difference_3_4;
    %end

%sin_a = distance_difference_1(1)/d;
    %angle_of_arrival_1 = asind(sin_a);
    %disp(["angle of arrival 1:", angle_of_arrival_1]);
    %sin_a = distance_difference_1(2)/d;
    %angle_of_arrival_2 = asind(sin_a);
    %disp(["angle of arrival 2:", angle_of_arrival_2]);
    %if ch1_amplitude <= ch4_amplitude
    %    angle_of_arrival_1 = -angle_of_arrival_1;
    %end
    %sin_a = distance_difference_1(2)/d_1;
    %angle_of_arrival_2 = asind(sin_a);
   
    %sin_a = distance_difference_1(3)/d_1;
    %angle_of_arrival_3 = asind(sin_a);

    %cos_a = (d^2+2*x*distance_difference_1(1)+distance_difference_1(1)^2)/(2*d*(x+distance_difference_1(1)));
    %angle_of_arrival_1 = 90 - acosd(abs(cos_a));
    %disp(["cos a:", cos_a]);
    %disp(["angle of arrival 1:", angle_of_arrival_1]);

    %cos_b = (d^2-2*x*distance_difference_1(2)-distance_difference_1(2)^2)/(2*x*d);
    %angle_of_arrival_2 = 90 - acosd(abs(cos_b));
    %disp(["cos b:", cos_b]);
    %disp(["angle of arrival 2:", angle_of_arrival_2]);
%if angle_of_arrival_2 > angle_of_arrival_1
    %    disp(["angle:", angle_of_arrival_1]);
    %else
    %    disp(["angle:", -angle_of_arrival_1]);
    %end

%if angle_of_arrival_3 > angle_of_arrival_2
    %    angle_of_arrival_2 = -angle_of_arrival_2;
    %end

% calculating the 3D angle of arrival:
    %phase_difference_2 = ch1_phase - ch3_phase;
    %distance_difference_2 = speed_of_sound/ch1_frequency * abs(phase_difference_2)/360;
    %d_2 = 0.009;
    %sin_a = distance_difference_2/d_2;
    %angle_of_arrival_2 = asind(sin_a);
    %if phase_difference_2 < 0
    %    angle_of_arrival_2 = -angle_of_arrival_2;
    %end
    % angle_of_arrival_2 = 90 - angle_of_arrival_2;

    %if abs(phase_difference_1) <= 180
    %    disp(["frequency: ", ch1_frequency]);
    %    
    %    disp(["angle of arrival 1: ", angle_of_arrival_1]);
    %    disp(["phase difference 1: ", phase_difference_1]);
        %disp(["angle of arrival 2: ", angle_of_arrival_2]);
        %disp(["phase difference 2: ", phase_difference_2]);

    %    DOADisplay(angle_of_arrival_1);
    %end

    %hold on;
    %plot(ch1_fil);
    %plot(ch2_fil);
    %hold off;
    %clf;
    %{
    Y = fft(ch1);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    figure(1);
    plot(f,P1)
    xlim([500 40000]);
    title("Single-Sided Amplitude Spectrum of X(t)")
    xlabel("f (Hz)")
    ylabel("|P1(f)|")                     
    
    Y = fft(ch2);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    figure(2);
    plot(f,P1)
    xlim([500 40000]);
    title("Single-Sided Amplitude Spectrum of X(t)")
    xlabel("f (Hz)")
    ylabel("|P1(f)|")
    x = 0;
    %}
    %{
    if length(signal) >= 40000
        signal = [[signal(4000:end)] data];
        L = 40000;
        Fs = 40000;
        Y = fft(signal);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L;
        figure(1);
        plot(f,P1)
        xlim([50 23000]);
        title("Single-Sided Amplitude Spectrum of X(t)")
        xlabel("f (Hz)");
        ylabel("|P1(f)|");
        %{
        P2 = angle(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        figure(2);
        plot(f,P1)
        xlim([50 23000]);
        title("Single-Sided Phase Spectrum of X(t)")
        xlabel("f (Hz)")
        ylabel("phase P1(f)")
        %}
        figure(3);
        plot(signal);
    else
        signal = [signal data];
    end
    %}
    %plot(fft_sig);
    %plot(signal);

function DOADisplay(angles) %angle in degrees
    x = 0;                          % X coordinate of arrow start
    y = 0;                          % Y coordinate of arrow start\
    L = 2;                          % Length of arrow
    xEnds = [];
    yEnds = [];
    for angle=1:length(angles)  
        theta = deg2rad(-angles(angle));   % Angle of arrow, from x-axis
        xEnds = [xEnds, x+L*cos(theta)];          % X coordinate of arrow end
        yEnds = [yEnds, y+L*sin(theta)];           % Y coordinate of arrow end
        %points = linspace(0, theta);    % 100 points from 0 to theta
        %xCurve = x+(L/2).*cos(points);  % X coordinates of curve
        %yCurve = y+(L/2).*sin(points);  % Y coordinates of curve
    end
    %clf;
    %plot(x+[-L L], [y y], '--k');   % Plot dashed line
    %hold on;                        % Add subsequent plots to the current axes
    %axis([x+[-L L] y+[-L L]]);      % Set axis limits
    %axis equal;                     % Make tick increments of each axis equal
    Z = compass(xEnds, yEnds);
    colors = get(0,'DefaultAxesColorOrder');
    for i=1:length(Z)
        set(Z(i),'color',colors(mod(i-1,length(colors))+1,:),'linewidth',2)
    end  
    view(90,90);
    %quiver(x, y, xEnd - x, yEnd - y, 0);    % Plot arrow
    %plot(xCurve, yCurve, '-k');     % Plot curve
    %plot(x, y, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w');  % Plot point
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
    %figure(2);
    %stem(f(2:end),P1(2:end));
    %xlabel 'Frequency (Hz)'
    %ylabel '|y|'
    %grid
    %xlim([300, 160000]);
    P2 = rad2deg(angle(fft_sig));
    P1 = P2(1:L/2+1);
    %figure(3);
    %stem(f(2:end),P1(2:end))
    %plot(rad2deg(angle(fft_sig)))
    
    phase_max = P1(index);
    %phase_max = rad2deg(angle(fft_sig(index)));
    %disp(index);
    %if imag(fft_sig(indeks)) <=0
    %    phase_max = phase_max + 360;
    %end
    %phase_max = 360-phase_max;
end

if start == false && max([ch1_amplitude, ch2_amplitude, ch3_amplitude]) > 5
    [~, ch_p] = max([ch1_amplitude, ch2_amplitude, ch3_amplitude]);
    ch_p = ch_p - 1;
    start = true;
    disp(["start ch", ch_p+1]);
end

if ch1_amplitude < 6 && test == false
    test = true;
end 
%test = false;


if abs(distance_difference(1)) > 0.0127 && abs(distance_difference(2)) > 0.0127
        return
end

if phase_difference_1_3 > 0
        cos_a = (d^2+2*x*distance_difference(3)+distance_difference(3)^2)/(2*d*(x+distance_difference(3)));
        angle_of_arrival = -(90 - acosd(abs(cos_a)));
else
        cos_a = (d^2+2*x*distance_difference(3)+distance_difference(3)^2)/(2*d*(x+distance_difference(3)));
        angle_of_arrival = (90 - acosd(abs(cos_a)));
end


distance_difference(1) = (speed_of_sound/ch1_frequency * phase_difference_1_2/360);
    distance_difference(2) = (speed_of_sound/ch2_frequency * phase_difference_2_3/360);
    distance_difference(3) = (speed_of_sound/ch3_frequency * phase_difference_1_3/360);