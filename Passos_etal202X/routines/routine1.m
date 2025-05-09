% Description: This routine is used for calculating the ERP from the
% from the subjects data
% 
% Comment 1: column 12 (D2), 13(D3) and 14(D4) indicates the arrow, begin-
% ning and end of the feed-
% back

%% Setting adresses

data_address = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\sim_data\working_matrix.mat';
eeglab_address = 'C:\Users\Cabral\Documents\pos_doc\AuxiliaryPackages\eeglab2025.0.0';
eeg_data_address = 'C:\Users\Cabral\Documents\pos_doc\Coleta\clean_data';
tree_file_address = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\files_for_reference\num7.tree';
montage_folder = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\montage_info';
montage_name = 'montage_eeg32';
montage_version = '01';

%% Setting parameters

leave_out = [10 42];  % Choosing participants to leave out
srate = 256;
low_cutoff = 1;       % high-pass frequency
high_cutoff = 30;     % low-pass frequency

%% Loading files and paths

load(data_address,'total_data')
addpath(genpath(eeglab_address))

%% Cleaning directories from the list of files

list_files = get_folder_fdtfiles(eeg_data_address); % substitute for <file_list_with_ext> in a near future.

%% Listing and eliminating subjects

total_data = rm_subjectfromdata(total_data, leave_out);
list_subjs = unique(total_data(:,15));  % not necessary anymore?

%% Loading EEG and behavioral data

repo = pack_data(total_data, list_files, eeg_data_address, eeglab_address, low_cutoff, high_cutoff);

%% Checking integrity of the data

corrupted = check_corruption(repo); 

%% Calculating ERPs

[gerp, ierp_easy_access, gerp_test_ref,...
    gcerp, icerp_easy_access, gcerp_test_ref] = erp_summary(repo,...
    'd4','d3',0.75,'right',tree_file_address, 0.05);

%% Estimating the arrow latencies

[ar_lat_estimate] = est_arrow_latency(repo);

%% Loading electrode data

montage_folder = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\montage_info';
montage_name = 'montage_eeg32';
montage_version = '01';

[electrodes, emap] = electrode_mapping(montage_folder, montage_name,montage_version);

%% Visualizing the data group data

ar_lat_estimate = [];

gv_erp_plot(gerp, ierp_easy_access, gerp_test_ref, electrodes, emap, 0, 'right', srate, ar_lat_estimate, [0 0.8], [-2 2]);

%% Plotting response times quantile

plot_quantiles_over(repo, [0.25 0.5 0.75], 1)