% DESCRIPTION: Estimate the context trees based on the response choices of
% the subjects

% Loading data
load('/home/paulo/Documents/Publications/Passos_etal202X_behavior/data/data.mat')

% Adding dependencies
addpath(genpath('/home/paulo/Documents/Publications/SeqROCTM-Matlab-Toolbox/'))

% Defining paramenters
tau = 7;
tree_file_address = '/home/paulo/Documents/Publications/Passos_etal202X_behavior/files_for_reference/num7.tree';
num_of_subj = max(data(:,6));
tau_cardinal = 5;
alphabet = [0 1 2];
from_vec = [1 501 1001];
till_vec = [500 1000 1500];

est_repo = cell(num_of_subj,length(from_vec));
prob_repo = cell(num_of_subj,length(from_vec));
for a = 1:num_of_subj
    for b = 1:length(from_vec)
        from = from_vec(b);
        till = till_vec(b);
        [chain_seq, resp_seq, rt_seq] = get_seqandresp(data,tau, a, from, till);
        [~,~, tree_summary] = tune_SeqROCTM(chain_seq', resp_seq', alphabet);
        chosen_tree = tree_summary.idxOptTree;
        est_repo{a,b} = tree_summary.champions{1,chosen_tree};
        prob_repo{a,b} = tree_summary.Ps{1,chosen_tree};
    end
end