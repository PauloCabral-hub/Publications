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
subj_num = 10;
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

load([file_path_p1 file_path_p2 'dataset_for_testing/' 'EEG_subj' aux_str '_clean.mat'])
%% Filter parameters
 
% INSERT high-pass cut-off frequency
low_cut = 1;
% INSERT low-pass cut-off frequency
high_cut = 45; 

%% Building GKlab data matrix

[data, channels, EEGtimes, EEGsignals] = EEG_data_matrix(EEG, ntrials, EEG.srate, subj_num, tree_num, 1);

%% Filtering EEG recordings
fEEGsignals = filtEEGdata(EEGsignals, EEG.srate,low_cut,high_cut);
EEG.data = fEEGsignals;

%% Tree estimation parameters

% TO REGISTER ALL COMMAND-WINDOW OUTPUT set diary_on to 1
% and provide a path for storing the diary
diary_on = 1;
diary_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X/diaries/';
diary_name = ['vol' num2str(subj_num) 'tree_est'];

% TO REGISTER TIKZ CODE for generenting the estimated tree set tikz_on to 1
% and provide a path for storing the diary
tikz_on = 1;
tikz_tree_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X/tikz_tree_storage/';

% INSERT the minimum time of response to consider for tree estimation [1]*
min_time = 0.300;

bs = [1 501 1001 1];
es = [500 1000 1500 1500];

for b = 1:length(bs)
    % INSERT from which trial the tree estimation should start
    
    b_trial = bs(b);

    % INSERT which will be the last trial in the estimation procedure
    e_trial = es(b);

    % INSERT the number of projection to be used in prunning decision
    proj_num = 5000; % 5000 is the default number of projections.

    % INSERT the last EEG channel
    last_ch = 31;

    % [1]* trials in which the response times (sec) are inferior to that parameter
    % will not be included in the analysis. 
    %% Tree estimation

    tree_data = cell(last_ch,2);
    for ch = 1: last_ch
        if diary_on == 1
            eval (['diary ' diary_path diary_name num2str(chan_info(ch).labels) '_subj' num2str(subj_num) '.log'])
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


        % Closing diary
        if diary_on == 1
           diary off
        end
    end
end

save([file_path_p1 file_path_p2 'estimations/' 'subj' aux_str '_EEGtrees_block_and_global.mat'])
