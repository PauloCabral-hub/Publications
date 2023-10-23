% [valids, signals, sample_stretch] = valid_functionals(data, fs, time_stretch, EEG)
%
% Returns a vector <valids> of zeros/ones related to <data>. The trials la-
% beled 1 indicates trials in which is possible to get a signal of size gi-
% ven by <time_stretch> in ms without entering in the previous trial feed-
% back. Also returns cell <signals> with the corresponding signals for the
% given <time_stretch> for each trial and EEG channel.
%
%
% INPUT:
%
% data = data matrix from EEG_data_matrix function
% fs = sampling frenquecy for the signals to which the data is related.
% time_stretch = time in ms. ex.: 0.2 indicates 200 ms.
% EEG = structure given by eeglab software. For valid trials  it  contains 
% the corresponding signal, otherwise, a empty vector.
% 
%
% OUTPUT:
%
% valids = vector of zeros/ones indicating valid trials.
% signals = cell containing, for  each  column,  stretch  signals  from  a
% different electrode.
% sample_stretch = length in samples of the time stretch of the given EEG
% signal.
%
% Author: Paulo Roberto Cabral Passos       Last Modified: 17/10/2023

function [valids, signals, sample_stretch] = valid_functionals(data, fs, time_stretch, EEG)

    sample_stretch = floor(time_stretch*fs);    
    valids = zeros( size(data,1), 1 );
    for k = 2:size(data,1) % the first trial is always discarded
        validation = data(k-1,14)+sample_stretch;
        if validation < data(k,10)
           valids(k,1) = 1; 
        end
    end
    
    signals = cell( length(valids), length(EEG.chanlocs) );
    for a = 1:length(EEG.chanlocs)
       for b = 1:length(valids)
          if valids(b) == 1
            signals{b,a} = EEG.data(  a, floor(data(b,10)-sample_stretch): floor(data(b,10)) );
          else
            signals{b,a} = [];  
          end
       end
    end
    
end