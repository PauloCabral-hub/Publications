% Date: 23/02/2024
% Description: This script performs the following procedures:
%
% 1. Open an EEGlab data set (.ftd and .set) with ICA decomposed info 
% 2. Removes Components with less than 10% probability of being brain related according to IClabel.
% 3. Saves the new data set with removed components.
%
% obs.: Please use EEGlab 2023 or above
% obs.: For previous ICA decomposition, 1hz high-pass filter should be used

% Adding path for EEGlab scripts
eeglab_dir = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/eeglab2023/';
addpath(genpath(eeglab_dir));

%% Opening EEGlab files

% Do not include the forward slash in file_name 
file_name = 'icadecomposed_PDPauloPassos_vol04.set';
file_path_p1 = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/';
file_path_p2 = 'Publications/Passos_etal202X/dataset_for_testing/';
EEG = pop_loadset('filename',file_name,'filepath',[file_path_p1 file_path_p2]);

% Loading channel information in case it is necessary
chan_file = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X/dataset_for_testing/chan_info.mat';
load(chan_file)

%% Assigning channel information
for a = 1:31
    ALLEEG.chanlocs(a) = chan_info(a);
    EEG.chanlocs(a) = chan_info(a);
end

EEG.chaininfo = chan_info;

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