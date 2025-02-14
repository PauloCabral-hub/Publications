% Basic Tutorial: Tree estimation 

% Loading data and parameters

subject = 1;
alphal = 3;
rtree = 7;
path_to_rtree = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X_behavior\files_for_reference';
load('C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X_behavior\data\master_matrix.mat')


% Processing the data

% Estimating a tree from the response times of a participant

[chain, ~, real_chain] = get_seqandresp(data,rtree,subject,1, 500);
output_tree = tauest_real(alphal, real_chain', chain');

% Estimating a mode tree from a set of trees

tree_set = {};
tree_set{1,1} = output_tree;
tree_set{1,2} = output_tree;

mode_tau = taumode_est(alphal, tree_set, 5, 0);