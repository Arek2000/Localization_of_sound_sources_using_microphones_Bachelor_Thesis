function [data, err] = SPI_Read(Libname, channel_handle, pNumBytesTransferred, transfer_option, num_of_bytes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    rdmsgPtr = libpointer('uint8Ptr', [zeros(1,num_of_bytes)]); % Same size as msg
    %rdmsgPtr = [zeros(1,num_of_bytes)];
    msg = [zeros(1,num_of_bytes)];
    %calllib(Libname, "SPI_ToggleCS", channel_handle, 8);
    err = calllib(Libname,'SPI_Read',channel_handle,rdmsgPtr,length(msg),pNumBytesTransferred,transfer_option);
    response = rdmsgPtr.value;
    %X = uint8(rdmsgPtr.value);
    %disp(rdmsgPtr.value);
    data = swapbytes(typecast(uint8(rdmsgPtr.value),'uint16'));
    %data = [zeros(1,num_of_bytes/2)];
    %i = 1;
    %for byte = 1:2:num_of_bytes
    %    format hex;
    %    X =  [response(byte) response(byte+1)];
    %    data(i) = typecast(X,'uint16');
    %    i = i + 1;
    %end
    %}
end