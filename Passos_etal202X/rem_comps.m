% Description: This routine get a EEGlab data with ICA decomposition and
% removes components with probability less than 10% of being brain related.
% ATTENTION: Depending on the environment, the parameters bellow may be
% subject to change.
%
% Requisites: 
% - Should add the eeglab package to searching path list
% - Should add the Passos_etal202X package to searching path list
% Parameters:

dir_path = 'C:\Users\Cabral\Documents\pos_doc\tmp_testing\ica_dec_files';
dest_path = 'C:\Users\Cabral\Documents\pos_doc\tmp_testing\clean_data';
dir_content = dir(dir_path);
addpath(genpath('C:\Users\Cabral\Documents\pos_doc\eeglab_current\eeglab2024.2'))
addpath(genpath('C:\Users\Cabral\Documents\pos_doc\Publications'))

for f = 1:length(dir_content)
   if ~isempty(strfind(dir_content(f).name, '.set'))
           file_name = dir_content(f).name;

           % Opening EEGlab file with ICA decomposition
           EEG = pop_loadset('filename',file_name, 'filepath',dir_path);

           % Running ICLabel classifier
           EEG = pop_iclabel(EEG,'default');

           % Discading components outside the criteria
           IC_matrix = EEG.etc.ic_classification.ICLabel.classifications;
           IC_classes = EEG.etc.ic_classification.ICLabel.classes;
           for col = 1:length(IC_classes)
              if ~isempty(strfind(IC_classes{col},'Brain'))
                 brain_class = col; 
              end
           end
           maintain_comp = zeros(size(IC_matrix,1),1);

           for c = 1:size(IC_matrix,1)
              if IC_matrix(c,1) > 0.10
                 maintain_comp(c) = 1;
              end
           end
           remove_comp = find(maintain_comp == 0);
           EEG = pop_subcomp( EEG, remove_comp, 0);

           % Saving non-eeg channels for reliability
           if size(EEG.data,1) > 32
               exclude_chs = [32 33];
               EEG.etc.non_eeg = EEG.data(exclude_chs,:);
               non_eeg_labels = [];
               for l = 1:length(exclude_chs)
                   non_eeg_labels = [non_eeg_labels ', ' EEG.chanlocs(exclude_chs(l)).labels]; %#ok<AGROW>
               end
               EEG.etc.non_eeg_lab = non_eeg_labels; 
           end

           % Filtering data
           fs = EEG.srate;
           low_cut = 1;
           upper_cut = 50;
           EEG.data = filtEEGdata(EEG.data,fs,low_cut,upper_cut, exclude_chs);

           % Subsampling data to 256 Hz
           EEG = pop_resample(EEG, 256);
           
           % Saving the processed data set
           EEG = eeg_checkset( EEG );
           patt_match1 = findstr(file_name, 'vol');
           patt_match2 = findstr(file_name, '.');

           % Save the dataset to the specified path and file name
           new_file_name = [ 'PDPauloPassos1022_' file_name(patt_match1:patt_match2-1) '_clean'];
           EEG.setname = new_file_name;
           EEG.filename = new_file_name;
           EEG.datfile = new_file_name;
           pop_saveset(EEG, 'filename', file_name, 'filepath', dest_path);
       clearvars -except eeglab_dir dir_path dest_path dir_content f
   end
end