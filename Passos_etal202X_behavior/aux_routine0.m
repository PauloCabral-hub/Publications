% DESCRIPTION: build the data matrix from the EEG files


% Adding the path to EEGlab 
addpath(genpath('C:\Users\Cabral\Documents\pos_doc\eeglab_current\eeglab2024.2'))

% Adding the folder with EEG clean files

file_list = dir('C:\Users\Cabral\Documents\pos_doc\Coleta\clean_data');

del_dir = [];
for a = 1:length(file_list)
   if file_list(a).isdir == 1
      del_dir = [ del_dir a ]; 
   end
end

file_list(del_dir) = [];


% Leave out these participants

leave_out = [10 42];

%Open EEG files

clearvars jdata

aux = 1; tau = 7; ntrials = 1500;
for a = 1:length(file_list)
   file_name = file_list(a).name; 
   if strcmp( file_name(end-2:end),'set')
       add_to = 1;
       EEG = pop_loadset('filename',file_name,'filepath',file_list(a).folder);
       num_id = str2num( file_name(end-11:end-10) );
       for c = 1:length(leave_out)
          if isequal(num_id,leave_out(c))
             add_to = 0; 
          end
       end
       if add_to == 1
           for b = 2:length(EEG.event)
               EEG.event(b).code = [ EEG.event(b).code(1) '  ' EEG.event(b).code(end) ];
           end
           [data, ~, ~, ~] = EEG_data_matrix(EEG, ntrials, EEG.srate, aux, tau, 0);
           if ~exist('jdata')
               jdata = data;
           else
               jdata = [jdata; data];
           end
           aux = aux + 1;           
       end
   end
end



