% [data, channels, EEGtimes, EEGsignals] = EEG_data_matrix(ALLEEG, ntrials, fs, idnum, tau, correction)
%
% 
% Returns the data from the Goalkeeper experiment EEG structure into a mat-
% rix <data> that can be used in Goalkeeper Lab for data screening.  Multi-
% ple <data> matrices can be concatenated to build a big dataset.
%
% INPUT:
%
% ALLEEG = structure from eeglab software containing the EEG data and  mar-
% kers.
%
% ntrials = number of trials of the experiment, excluding the warm-up tri-
% als.
% fs = sampling frequency of the signals. <EEG.srate> should be used ideal-
% ly.
% idnum = alternative identification
% correction = Use 1 for data bitwise marked.
%
% OUTPUT:
%
% data = data matrix for goalkeeperlab
% channels = EEG channel labels
% EEGtimes = vector with the time vector of the experiment
% EEGsignals = Data with EEG signals.
%
% Author: Paulo Roberto Cabral Passos     Last modified = 17/10/2023


function [data, channels, EEGtimes, EEGsignals] = EEG_data_matrix(ALLEEG, ntrials, fs, idnum, tau, correction)

if correction == 1
   workwith_corrected = data_correction(ALLEEG.event);
   N = length(workwith_corrected);
   if workwith_corrected(N).type(1) ~= 'D' % in case it ends with the goalkeeper event
      workwith_corrected(N+1) = workwith_corrected(N);
      workwith_corrected(N+1).code = 'D  3';
      workwith_corrected(N+1).type = 'D  3';
      workwith_corrected(N+1).latency = ALLEEG.pnts;
   end
else
   workwith_corrected = ALLEEG.event;
end
% Counting the number of trials
trials = 0;
for a = 1:length(workwith_corrected)
    if strcmp(workwith_corrected(a).type, 'G  1')
       trials = trials+1;
    end
end

% Registering channels
channels = cell(length(ALLEEG.chanlocs),1);

for a = 1:length(ALLEEG.chanlocs) 
    channels{a,1} = ALLEEG.chanlocs(a).labels;
end

%Building the data matrix

data = zeros (ntrials,14);

data(:,1) = ones(ntrials,1);
data(:,2) = ones(ntrials,1);
data(:,3) = [1:ntrials]'; %#ok<NBRAK>
data(:,4) = ones(ntrials,1);
data(:,5) = tau*ones(ntrials,1);
data(:,6) = idnum*ones(ntrials,1);

% collecting stochastic chain, latency of the response (10), trial
% initiation game (11) and trial initiation display (12)

warmup = trials-ntrials; count = 0; rcount = 0;
for a = 1:length(workwith_corrected)   
    if strcmp(workwith_corrected(a).type, 'G  1')
       count = count +1; 
    end
    if count > warmup
       if ~strcmp(workwith_corrected(a).type, 'G  1')
             %%%%%% Getting the trial initiation by the Game and Response latency  %%%%%%
          if strcmp(workwith_corrected(a).type(1), 'G') && strcmp(workwith_corrected(a+1).type(1), 'G')
             rcount = rcount+1;
                    %%%% Defining signal latencies %%%%
             data(rcount,10) = workwith_corrected(a).latency;
             % ALTERNATIVE: USING THE GOALKEEPER TO GET THE RESP. TIME
             data(rcount,13) = workwith_corrected(a).latency;
             % ALTERNATIVE: USING THE GOALKEEPER TO GET THE RESP. TIME
             data(rcount,11) = workwith_corrected(a-1).latency;
                    %%%% --------------------- %%%%
             if workwith_corrected(a).type(4) == '2'
                data(rcount,9) = 0;
             elseif workwith_corrected(a).type(4) == '4'
                data(rcount,9) = 1;
             else
                data(rcount,9) = 2;    
             end
             %%%%%%% Getting the trial the appearence of the arrows
             if strcmp(workwith_corrected(a-2).type, 'D  2')
                 data(rcount,12) = workwith_corrected(a-2).latency;
             else
                data(rcount,12) = workwith_corrected(a-1).latency;    
             end
             %%%%%%%
             %%%%%%% Getting the begining of the fb (13)
             % ALTERNATIVE: USING THE GOALKEEPER TO GET THE RESP. TIME
             if (a+2 <= length(workwith_corrected)) && strcmp(workwith_corrected(a+2).type,'D  3')
                data(rcount,13) = workwith_corrected(a+2).latency; 
             end
             % ALTERNATIVE: USING THE GOALKEEPER TO GET THE RESP. TIME
             %%%%%%% Getting the end of the fb (14)
             if (a+4 <= length(workwith_corrected)) && strcmp(workwith_corrected(a+4).type,'D  1')
                data(rcount,14) = workwith_corrected(a+4).latency;
             else
                data(rcount,14) = workwith_corrected(length(workwith_corrected)).latency; 
             end    
          end
       end
    end
end

% collecting responses

warmup = trials-ntrials; count = 0; rcount = 0;
for a = 1:length(workwith_corrected)   
    if strcmp(workwith_corrected(a).type, 'G  1')
       count = count +1; 
    end
    if count > warmup
       if ~strcmp(workwith_corrected(a).type, 'G  1')
          if strcmp(workwith_corrected(a).type(1), 'G') && (~strcmp(workwith_corrected(a+1).type(1), 'G'))
             rcount = rcount+1;
             if workwith_corrected(a).type(4) == '2'
                data(rcount,8) = 0;
             elseif workwith_corrected(a).type(4) == '4'
                data(rcount,8) = 1;
             else
                data(rcount,8) = 2;    
             end
          end
       end
    end
end

% Response time calculated from 

for a = 1:size(data,1)
   data(a,7) =  (data(a,10)-data(a,12))*(1/fs);
end

EEGtimes = ALLEEG.times;
EEGsignals = ALLEEG.data;

% Data columns 10-14 quicksheet
% 10 indicates the momment of the response according to game marker
% 11 idicates the trial initiation according to game marker
% 12 indicates arrow appearance according to display marker
% 13 indicates feedback initiation according to the display marker
% 14 indicates feedback ending according to the display marker

end