% Date: 04/03/2024
%
% Description: This script performs the following procedures:
%
% 1. Draw trees from a matlab file 'ptrees', containing a set of trees,
% into tex files.

work_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X';
addpath(genpath(work_path))

load([work_path '/files_for_reference/num7possible_trees/num7_possibletrees.mat'])


file_path = [work_path '/files_for_reference/num7possible_trees/'];
tree = 7;
alphal = 3;

for k = 1:length(ptrees)
    tree_variant = ptrees{k,1};
    
    % Generating the tikz code for drawing the tree
    tikz_seq = tikz_tree(tree_variant, [0:alphal-1], 1); %#ok<NBRAK>

    % Storing the tikz tree code
    aux_str = ['num' num2str(tree) 'variant' num2str(k) ];
    standalone_tickztree(file_path, tikz_seq, aux_str);    
end
