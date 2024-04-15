% Date: 23/02/2024
% Description: This script performs the following procedures:
%
% 1. Build the GKlab datamatrix from EEG recordings (EEGlab format) of 
% the goalkeeper game
% 1. Filter EEG data (EEGlab format) for isolating signal in 1-45 Hz 
% 2. Performs context tree estimation for a EEG recording (EEGlab format) 
% associated with the goalkeeper game 
%
% Obs.: Previous use of aux_routine1 is advised for removing components
% not associated with brain activity.

%% Setting the paths
file_path_p1 = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/';
file_path_p2 = 'Publications/Passos_etal202X/';
%% General parameters

% INSERT the number to which the subject will be associated
subj_num = 5;
% INSERT the number of trials of the experiment 
ntrials = 1500;
% INSERT tree-reference number in the experiment
tree_num = 7;
% INSERT the length of the alphabet (different stimuli)
alphal = 3;

if subj_num < 10
   aux_str = ['0' num2str(subj_num)];
else
   aux_str = num2str(subj_num);
end

load([file_path_p1 file_path_p2 'dataset_for_testing/EEG_subj' aux_str '_clean.mat'])
%% Filter parameters
 
% INSERT high-pass cut-off frequency
low_cut = 1;
% INSERT low-pass cut-off frequency
high_cut = 45; 

%% Building GKlab data matrix

[data, channels, EEGtimes, EEGsignals] = EEG_data_matrix(EEG, ntrials, EEG.srate, subj_num, tree_num, 1);
min_time = 0.300;
[valids, signals, sample_stretch] = valid_functionals(data, EEG.srate, min_time, EEG, 0, 0);
sum(valids)
