clear device;
global signal;
signal = [];
device = serialport("COM3",921600);
configureTerminator(device,"CR");
%s.BytesAvailableFcn = {@callbackFcn, signal};
configureCallback(device, "byte", 4000, @(src, evt) callbackFcn(src, evt));

%while true
%    disp(signal);
%end


function callbackFcn(src, ~)
    global signal;
    data = read(src, 8000, "uint16");
    %global Libname;
    %global pChannelHandle;
    %global pNumBytesTransferred;
    %global transfer_options;
    %[data, ~] = SPI_Read(Libname, pChannelHandle, pNumBytesTransferred, transfer_options, 8000);
    %disp(data);
    
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
        xlabel("f (Hz)")
        ylabel("|P1(f)|")
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
   
    %plot(fft_sig);
    %plot(signal);
    %toc;
    %tic;
end