% Date: 18/06/2024
% (SERVER) Description: This script performs the following procedures:
%
% 1. Open an EEGlab data set (.ftd and .set) with ICA decomposed info 
% 2. Removes Components with less than 10% probability of being brain related according to IClabel.
% 3. Saves the new data set with removed components.
%
% obs.: Please use EEGlab 2023 or above
% obs.: For previous ICA decomposition, 1hz high-pass filter should be used

% Adding path for EEGlab scripts
eeglab_dir = '/home/guestmae/paulocabral-local/eeg_signal_processing/eeglab2024';
addpath(genpath(eeglab_dir));


%% Looping through files


for f= 1:length(dir_content)
    dir_path = '/var/tmp/paulo_neuromat_data/ica_data/';
    dir_content = dir(dir_path);
    if ~isempty( strfind(dir_content(f).name,'.set') )
        %% Opening EEGlab with ica info
        file_name = dir_content(f).name;
        % observation: file_name should not end with forward slash
        EEG = pop_loadset('filename',file_name,'filepath',dir_path);
        
        %% Assigning channel information
        eeglocs  = '/plugins/dipfit/standard_BEM/elec/standard_1005.elc';
        eeglocs = [eeglab_dir eeglocs];
        new_eeglocs = [];
        for a = 1: length(eeglocs)
           if eeglocs(a) == '\'
               new_eeglocs = [new_eeglocs '\\'];
           else
               new_eeglocs = [ new_eeglocs eeglocs(a) ];
           end
        end
        EEG = pop_chanedit(EEG, 'lookup', eeglocs);
        EEG = eeg_checkset( EEG );
        
        %% Running IClabel classification
        EEG = pop_iclabel(EEG, 'default');

        %% Selecting components based in the criteria on the headings of this file
        IC_matrix = EEG.etc.ic_classification.ICLabel.classifications;
        maintain_comp = zeros(size(IC_matrix,1),1);
        for a = 1:size(IC_matrix,1)
            if IC_matrix(a,1) > 0.10 
               maintain_comp(a) = 1;
            end
        end
        remove_com = find(maintain_comp == 0);
        EEG = pop_subcomp( EEG, remove_com, 0);
        dest_path = '/var/tmp/paulo_neuromat_data/icadecomposed_data/'; 
        save([file_path 'EEG_subj' aux_str '_clean.mat'])

    end  
end





