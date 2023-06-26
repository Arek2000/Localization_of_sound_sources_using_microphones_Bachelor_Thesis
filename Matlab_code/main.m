clear device;
% Constants
d_mic = 0.0127;         % distance between 2 microphones
speed_of_sound = 343;   % m/s
Fs = 125000;            % Sampling frequency

% Initialization of designed digital filter
bpFilterInit = designfilt('bandpassiir','FilterOrder',4,'HalfPowerFrequency1',1000,'HalfPowerFrequency2',14000,'SampleRate',Fs);

global angles_of_arrival; % Used for storing results
angles_of_arrival = [];

% USB Configuration
device = serialport("COM5",921600);
configureTerminator(device,"CR");
% Interrupt function is called when 6600 samples of data are received via 
% USB
configureCallback(device, "byte", 6600, @(src, evt) callbackFcn(src, Fs, bpFilterInit, speed_of_sound));

function callbackFcn(src, Fs, filtr, speed_of_sound, ~)
    global angles_of_arrival;
    data = read(src, 6600, "uint16");   % Reading data from USB
    % Separating data to 3 channels each for different microphone
    ch1 = data(1:3:end);
    ch2 = data(2:3:end);
    ch3 = data(3:3:end);
    
    % Filtering of all 3 signals
    ch1_fil = filter(filtr,double(ch1));
    ch2_fil = filter(filtr,double(ch2));
    ch3_fil = flter(filtr,double(ch3));

    % Calculating frequency , amplitude and phase shift of all 
    [ch1_phase, ch1_frequency, ch1_amplitude] = phase_shift(ch1_fil(201:end), Fs);
    [ch2_phase, ch2_frequency, ch2_amplitude] = phase_shift(ch2_fil(201:end), Fs);
    [ch3_phase, ch3_frequency, ch3_amplitude] = phase_shift(ch3_fil(201:end), Fs);

    % Calculations are done only if signal is strong enough to prevent
    % capturing random noise
    if (ch1_amplitude >= 7 ||  ch2_amplitude >= 7 ||  ch3_amplitude >= 7) && ((ch1_frequency == ch2_frequency) && (ch2_frequency == ch3_frequency))
    
        disp(" ");
    
        % Calculating phase difference between microphones 1 - 3 from phase
        % shifts of all 3 microphones
        phase_difference_1_3 = phase_difference(ch1_phase, ch2_phase) + phase_difference(ch2_phase, ch3_phase);

        % Calculating the distance difference between microphones 1 and 3:
        distance_difference = (speed_of_sound/ch3_frequency * phase_difference_1_3/360);
        d = 2*d_mic; %distance between 2 microphones
        x = d + 100;  %random value (must be greather than d)
    
        % Calculating angle of arrival
        cos_a = (d^2+2*x*distance_difference+distance_difference^2)/(2*d*(x+distance_difference));

        % Changing cosinus value to angle in degrees
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
    
        % Presenting average angle from last 5 measurements:
        if length(angles_of_arrival) >= 5
            disp(["angle:", mean(angles_of_arrival)]);
            DOADisplay(mean(angles_of_arrival));
            angles_of_arrival = [];
        end
    end
end
