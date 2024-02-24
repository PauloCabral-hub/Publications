% Date: 24/02/2024
%
% Description: This script performs the following procedures:
%
% 1. Build the GKlab datamatrix from EEG recordings (EEGlab format) of 
% the goalkeeper game
% 1. Filter EEG data (EEGlab format) for isolating signal in 1-45 Hz 
% 2. Performs context tree estimation USING REAL DATA AS A TEMPLATE FOR
% CHECKING IF THE TREE ESTIMATION IS CORRECT.
%
% Obs.: Previous use of aux_routine1 is advised for removing components
% not associated with brain activity.

%% General parameters

% INSERT the number to which the subject will be associated
subj_num = 1;
% INSERT the number of trials of the experiment 
ntrials = 1500;
% INSERT tree-reference number in the experiment
tree_num = 7;
% INSERT the length of the alphabet (different stimuli)
alphal = 3;

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

% INSERT from which trial the tree estimation should start
b_trial = 1;

% INSERT which will be the last trial in the estimation procedure
e_trial = 500;

% INSERT the number of projection to be used in prunning decision
proj_num = 5000; % 5000 is the default number of projections.

% INSERT the last EEG channel
last_ch = 1;

% [1]* trials in which the response times (sec) are inferior to that parameter
% will not be included in the analysis. 
%% Tree estimation

tree_data = cell(last_ch,2);
for ch = 1: last_ch
    if diary_on == 1
        eval (['diary ' diary_path diary_name num2str(chan_info(ch).labels) '_subj' num2str(subj_num) '.log'])
    end
    
    % Selecting the valid trials [1]*
    [valids, signals, sample_stretch] = valid_functionals(data, EEG.srate, min_time, EEG, 0, 0);
    aux = 1;
    sig_set = cell(e_trial-b_trial+1,1);
        for a = b_trial:e_trial
            sig_set{aux,1} = signals{a,ch};
            aux = aux + 1;
        end
    chain = data(b_trial:e_trial,9)';
    % OVERWRITTING original signals by sinusoids
    sig_len = length(signals{2,1});
        for a = 3:length(chain)
            if isequal(chain(a-1),0)
                w = 10*(2*pi/EEG.srate);
                sig_set{a,1} = cos(w*[1:sig_len]); %#ok<NBRAK>
            elseif isequal(chain(a-2:a-1),[0 1])
                w = 20*(2*pi/EEG.srate);
                sig_set{a,1} = cos(w*[1:sig_len]); %#ok<NBRAK>
            elseif isequal(chain(a-2:a-1),[1 1])
                w = 30*(2*pi/EEG.srate);
                sig_set{a,1} = cos(w*[1:sig_len]); %#ok<NBRAK>
            elseif isequal(chain(a-2:a-1),[2 1])
                w = 40*(2*pi/EEG.srate);
                sig_set{a,1} = cos(w*[1:sig_len]); %#ok<NBRAK>
            else
                w = 50*(2*pi/EEG.srate);
                sig_set{a,1} = cos(w*[1:sig_len]); %#ok<NBRAK>
            end
        end
    % OVERWRITTING original signals by sinusoids
    
    % Estimating tree
    [tau_est, mosaic] = tauest_ftype(alphal, chain, sig_set, proj_num, sample_stretch);
    tree_data{ch,1} = tau_est;
    tree_data{ch,2} = mosaic;
    
    % Generating the tikz code for drawing the tree
    tikz_seq = tikz_tree(tau_est, [0:alphal-1], 1); %#ok<NBRAK>
    
    % Storing the tikz tree code
    if tikz_on == 1
        aux_str = ['ch' num2str(chan_info(ch).labels) '_est_tree_' ...
            'trials' num2str(b_trial) 'to' num2str(e_trial) '_filt' ...
            num2str(low_cut) 'to' num2str(high_cut) ];
        standalone_tickztree(tikz_tree_path, tikz_seq, aux_str);
    end
    
    % Closing diary
    if diary_on == 1
       diary off
    end
end

