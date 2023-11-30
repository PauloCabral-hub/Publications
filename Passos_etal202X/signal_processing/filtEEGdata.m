% fEEGsignals = filtEEGdata(EEGsignals,fs,low_cut,upper_cut)
%
% The function receives the matrix EEGsignals in which each line
% corresponds to the time series of a given channel and returns the
% fEEGsignals that presents the same signals, but filtered with a bandpass
% procedure.
% INPUT:
% EEGsignals =  a matrix whose dimensions are channels and samples.
% fs = sampling frequency
% low_cut = frequency to be used in the high-pass filter
% uppercut = frequency to be used in the low-pass filter
%
% OUTPUT:
% fEEGsignals = corresponds to EEGsingals filtered according to the given
% parameters.
%
% date: 13/04/2022    author: Paulo Roberto Cabral Passos

function fEEGsignals = filtEEGdata(EEGsignals,fs,low_cut,upper_cut)

fEEGsignals = zeros(size(EEGsignals,1), size(EEGsignals,2));

for a = 1:size(EEGsignals,1)
    
sig = double(EEGsignals(a,:));

% High-pass filtering
if low_cut > 0 
    [c_high,d_high] = butter(2,low_cut*2/fs, 'high' );
    sig = filtfilt(c_high,d_high,sig);    
end  
 
% Low-pass filtering
if upper_cut > 0
    [c_low,d_low] = butter(2,upper_cut*2/fs, 'low' );
    sig = filtfilt(c_low,d_low,sig);    
end

fEEGsignals(a,:) = sig;

end


end






