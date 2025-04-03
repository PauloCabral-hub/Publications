% Date: 23/02/2024
% (SERVER) Description: This script performs the following procedures:
%
% 1. Build the GKlab datamatrix from EEG recordings (EEGlab format) of
% the goalkeeper game
% 1. Filter EEG data (EEGlab format) for isolating signal in 1-45 Hz
% 2. Performs context tree estimation for a EEG recording (EEGlab format)
% associated with the goalkeeper game
%
% ATTENTION: You should provide the values for the variables <first_subj>,
% <last_subj> and <b> which corresponds to the first subject and the last
% subject in the processing and the respective block.
%
% Obs.: Previous use of aux_routine1 is advised for removing components
% not associated with brain activity.

%% Setting the paths
% Codes for tree estimation
addpath(genpath('C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X'))
% EEGlab codes
addpath(genpath('C:\Users\Cabral\Documents\pos_doc\eeglab_current\eeglab2024.2'))
% Path to the files
origin_path = 'C:\Users\Cabral\Documents\pos_doc\Coleta\clean_data';
% Destination path
dest_path =  'C:\Users\Cabral\Documents\pos_doc\Coleta\tree_data';

subjects = first_subj:last_subj;

for s = 1:length(subjects)
    %% General parameters
    subj_num = subjects(s);
    % INSERT the number of trials of the experiment
    ntrials = 1500;
    % INSERT tree-reference number in the experiment
    tree_num = 7;
    % INSERT the length of the alphabet (different stimuli)
    alphal = 3;
    % INSERT the block to be processed

    aux_str = Ndigits_str(subj_num,2);

    EEG = pop_loadset([origin_path '/PDPauloPassos_vol' aux_str '_clean.set']);
    %% Filter parameters

    % INSERT high-pass cut-off frequency
    low_cut = 1;
    % INSERT low-pass cut-off frequency
    high_cut = 45;
    %% Building GKlab data matrix
    disp('Building GKlab matrix.')
    correction = ~(subj_num>=40);
    
    [data, channels, ~ , EEGsignals] = EEG_data_matrix(EEG, ntrials, EEG.srate, subj_num, tree_num, correction);

    % REMOVING EOG and EMG for the following processing
    EEGsignals([32 33],:) = [];
    EEG.chanlocs([32 33]) = [];
    channels([32 33]) = [];
    
    %% Filtering EEG recordings
    disp('Filtering EXG data.')
    fEEGsignals = filtEEGdata(EEGsignals, EEG.srate,low_cut,high_cut,[]);
    EEG.data = fEEGsignals;
    
    %% Tree estimation parameters
    % INSERT the minimum time of response to consider for tree estimation [1]*
    min_time = 0.300;

    bs = [1 501 1001 1];
    es = [500 1000 1500 1500];

    % INSERT from which trial the tree estimation should start

    b_trial = bs(b);

    % INSERT which will be the last trial in the estimation procedure
    e_trial = es(b);

    % INSERT the number of projection to be used in prunning decision
    proj_num = 5000;

    % INSERT the last EEG channel
    last_ch = 32;
    % [1]* trials in which the response times (sec) are inferior to that parameter
    % will not be included in the analysis.
    %% Tree estimation
    disp('Starting tree estimation.')
    
    tree_data = cell(last_ch,2);

    for ch = 1:last_ch
        disp(['going through channel ' num2str(ch)])
        try
            load([dest_path '/subj' aux_str '_EEGtrees_blockB' num2str(b) '.mat'])
        catch ME
            no_file = strcmp(ME.identifier, 'MATLAB:load:couldNotReadFile');
            if no_file == 1
                disp("no_file")
            end
        end
        % Selecting the valid trials
        [valids, signals, sample_stretch] = valid_functionals(data, EEG.srate, min_time, EEG, 0, 0);
        aux = 1;
        sig_set = cell(e_trial-b_trial+1,1);
            for a = b_trial:e_trial
                sig_set{aux,1} = signals{a,ch};
                aux = aux + 1;
            end
        chain = data(b_trial:e_trial,9)';

        % Estimating tree
        [tau_est, ~] = tauest_ftype(alphal, chain, sig_set, proj_num, sample_stretch); 
        tree_data{ch,1} = tau_est;
        if exist('summary_repo','var')
           if check_summary_repo(summary_repo, subj_num, b_trial, e_trial, ch) == 1
                summary_repo = insert_summary_repo(summary_repo,...
                    subj_num, ch, channels{ch}, tau_est, b_trial, e_trial);
           end
        else
           summary_repo = new_summary_repo();
           summary_repo = insert_summary_repo(summary_repo,...
                subj_num, ch, channels{ch}, tau_est, b_trial, e_trial);
        end
        save([dest_path '/subj' aux_str '_EEGtrees_blockB' num2str(b) '.mat'],'summary_repo')
    end
    clearvars -except origin_path dest_path subjects s
end