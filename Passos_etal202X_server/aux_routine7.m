% Description: This script performs the following procedures:
%
% 1. After running aux_routine6, it saves the set of unique trees into tex files.


work_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X';
addpath(genpath(work_path))

tree = 7;
alphal = 3;

for k = 1:length(unique_trees)
    tree_variant = unique_trees{k};
    
    % Generating the tikz code for drawing the tree
    tikz_seq = tikz_tree(tree_variant, [0:alphal-1], 1); %#ok<NBRAK>

    % Storing the tikz tree code
    aux_str = ['tree_num' num2str(find(Ds_asc == k)) 'from' num2str(7) ];
    standalone_tickztree([work_path '/estimations/'], tikz_seq, aux_str);    
end
