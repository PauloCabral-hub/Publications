% DESCRIPTION: This routine is used for verifying the integrity of the data
% in a EEG file associated with the goalkeeper game

events = EEG.event;

% Identyfing the triggers that appears in the file

trgs = {}; aux = 1;
for a = 1:length(events)
    if isempty(trgs)
       trgs{aux,1} = events(a).code;
       aux = aux +1;
    else
       check = 0;
       for b = 1:length(trgs)
           if isequal(trgs{b,1},events(a).code)
              check = 1; 
           end
       end
       if check == 0
            trgs{aux,1} = events(a).code;
            aux = aux +1;
       end
    end
end

% Counting how many times each of them appear

counts = zeros(length(trgs),1);
for a = 1:length(events)
    for b = 1:length(trgs)
       if isequal(trgs{b,1}, events(a).code)
          counts(b,1) =  counts(b,1) +1;  
       end
    end
end

% For identifying the location of atypical triggers

atip_trg = 'G  5';
location = [];
for a = 1:length(events)
   if isequal(atip_trg,events(a).code)
      location = [location a]; 
   end
end


% Bulding the datamatrix
[data, channels, EEGtimes, EEGsignals] = EEG_data_matrix(EEG, 1500, EEG.srate, 1, 7, 1);