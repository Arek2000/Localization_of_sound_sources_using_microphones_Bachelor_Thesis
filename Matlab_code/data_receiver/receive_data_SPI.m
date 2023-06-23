% Libname matches the name of the .dll
%global Libname;
Libname = 'libmpsse';

% "Don't call loadlibrary if the library is already loaded into memory" (loadlibrary help)
% The second argument is the header file containing the list of functions from Libname
% Note that it's ONLY used for the list of functions.  Therefore, any #include statements should be
% removed, and any typedefs used in the function declarations must be typedef'd inside the h file.
% Because the library is already compiled in the dll, the #include statements are extraneous, and cause
% loadlibrary to fail as it attempts to preprocess the header file.
if ~libisloaded( Libname )
	loadlibrary( Libname, 'libMPSSE_spi_matlabFriendly.h');
end

% Quick view of other library functions
% libfunctionsview(Libname)

% This shouldn't be required.
% calllib(Libname,'Init_libMPSSE');

% This is how we define a pointer in matlab.  Required to match the parameter types in various functions.
pNumchannels = libpointer('uint32Ptr',255);
%global pNumBytesTransferred;
pNumBytesTransferred = libpointer('uint32Ptr',255);
%global pChannelHandle;
pChannelHandle = libpointer('voidPtr',255);

% Get the number of SPI channels available.  If 1, we can talk to an FTDI chip.  If 0... not so much
calllib(Libname,'SPI_GetNumChannels',pNumchannels); pause(0.1);
sprintf('Channels Found: %d',get(pNumchannels,'value'))

% Connect to SPI channel 0.  Valid numbers are 0:(Numchannels-1).
calllib(Libname,'SPI_OpenChannel',0,pChannelHandle); pause(0.1);

% Define the channel configuration struct, and initialize the channel.
ChConfig.ClockRate = uint32(12e6); % Clock speed, Hz
ChConfig.LatencyTimer = uint8(2); % Users guide section 3.4, suggested value is 2-255 for all devices
ChConfig.configOptions = uint32(0); % Bit 1 is CPOL, bit 0 is CPHA.  Higher order bits configure the chip select.
calllib(Libname,'SPI_InitChannel',pChannelHandle,ChConfig); pause(0.1);

%global transfer_options;
transfer_options = 0; % No chip select used.

device = serialport("COM3",921600);
configureTerminator(device,"CR");

global signal;
signal = [];

Fs = 160000;
bpFilterInit = designfilt('bandpassiir','FilterOrder',4,'HalfPowerFrequency1',21000,'HalfPowerFrequency2',23000,'SampleRate',Fs);

pause(10);
disp(SPI_Read(Libname, pChannelHandle, pNumBytesTransferred, transfer_options, 6000));
%s.BytesAvailableFcn = {@callbackFcn, signal};
pause(5);
configureCallback(device, "byte", 1, @(src, evt) callbackFcn(Libname, pChannelHandle,pNumBytesTransferred, transfer_options, bpFilterInit));
%t = timer('TimerFcn',@(x,y) callbackFcn(Libname, pChannelHandle,pNumBytesTransferred, transfer_options),'StartDelay',5);
%t.ExecutionMode = 'fixedRate';
%t.Period = 0.025;


function callbackFcn(Libname, pChannelHandle,pNumBytesTransferred, transfer_options, filtr, ~)
    global signal;
    %data = read(src, 8000, "uint16");
    %pause(0.1);
    [data, err] = SPI_Read(Libname, pChannelHandle, pNumBytesTransferred, transfer_options, 6000);
    %disp(data);
    %disp(err);
    ch1 = data(1:2:end);
    ch2 = data(2:2:end);
    %L = length(ch1);
    ch1_fil = filter(filtr,double(ch1));
    ch2_fil = filter(filtr,double(ch2));
    %{
    if max(ch1_fil) > 0
        figure(2);
        hold on;
        plot(ch1_fil);
        plot(ch2_fil);
        hold off;
        clf;
    end
    %}
    %figure(3);
    %hold on;
    %plot(ch1_fil);
    %figure(4);
    %plot(ch2_fil);
    Fs = 160000;
    L = length(ch1_fil);
    f = Fs*(0:(L/2))/L;
    Y = fft(ch1);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(1);
    plot(f,P1)
    xlim([1000 80000]);
    Y = fft(ch2_fil);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    figure(2);
    plot(f,P1)
    xlim([1000 80000]);
    title("Single-Sided Amplitude Spectrum of X(t)")
    xlabel("f (Hz)")
    ylabel("|P1(f)|")
    %hold off;
    %clf;
    ch1_phase = phase_shift(ch1, 160000);
    ch2_phase = phase_shift(ch2, 160000);
    %disp(["difference: ", ch1_phase - ch2_phase]);
    %disp(["ch2: ", ch2_phase]);
    [c, lag] = xcorr(ch1_fil, ch2_fil);
    [maks, idx] = max(c);
    disp(["shift: ",lag(idx)]);
    disp(' ');
    %{
    if length(signal) >= 600000
        ch1 = signal(1:2:end);
        ch2 = signal(2:2:end);
        %L = length(ch1);
        ch1_fil = filter(filtr,double(ch1));
        ch2_fil = filter(filtr,double(ch2));
        %ch1_phase = phase_shift(ch1_fil, 160000);
        %ch2_phase = phase_shift(ch2_fil, 160000);
        %disp(["difference: ", ch1_phase - ch2_phase]);
        %disp(["ch2: ", ch2_phase]);
        [c, lag] = xcorr(ch1_fil, ch2_fil);
        [maks, idx] = max(c);
        disp(["shift: ",lag(idx)]);
        disp(' ');
        signal = [];
        %signal = [[signal(6000:end)] data];
        %L = 160000;
        %Fs = 160000;
        %Y = fft(signal);
        %P2 = abs(Y/L);
        %P1 = P2(1:L/2+1);
        %P1(2:end-1) = 2*P1(2:end-1);
        %f = Fs*(0:(L/2))/L;
        %figure(1);
        %plot(f,P1)
        %xlim([1000 80000]);
        %title("Single-Sided Amplitude Spectrum of X(t)")
        %xlabel("f (Hz)")
        %ylabel("|P1(f)|")
        
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
        %figure(2);
        %plot(signal);
        %configureCallback(device,"off");
    else
        signal = [signal data];
    end
    %}
end

function phase_max = phase_shift(sig, sampling_frequency)
    fft_sig = fft(sig);
    [~,indeks] = max(abs(fft_sig));

    %figure(2);
    L = length(sig);
    P2 = abs(fft_sig/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = sampling_frequency*(0:(L/2))/L;
    %plot(f,P1);
    %xlim([300, 30000]);
    %figure(3);
    %plot(rad2deg(angle(fft_sig)))

    phase_max = rad2deg(angle(fft_sig(indeks)));
    %if imag(fft_sig(indeks)) <=0
    %    phase_max = phase_max + 360;
    %end
    %phase_max = 360-phase_max;
end