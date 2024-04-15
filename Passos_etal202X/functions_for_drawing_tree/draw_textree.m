% draw_textree(repository_path, target_path, tree_file, prefix)
%
% DESCRIPTION: Draws the context trees in a variable 'tree_set' in the respo-
% sitory path. Trees are named with the 'prefix' string and a number that in-
% dicates the position of the tree in 'tree_set'.
%
% INPUT:
%
% repository_path = path with the file containing the trees
% ex.: '/PATH/TO/THE/FILE/'
% target_path = path where the latex tree will be saved.
% ex.: '/SAVE/PATH/TO/THE/FILE/'
% tree_file = name of the file in the repository path containing the trees
% ex.: 'tree_set.mat'
% prefix = prefix to left apped in the name of the latex tree
% ex.: 'tree_example' leads to 'tree_example_X.tex' (where X will be an integer)
%
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 15/04/2024

function draw_textree(repository_path, target_path, tree_file, prefix)

load([repository_path tree_file])
    
    alphabet = [];
    for a = 1:length(tree_set) %#ok<USENS>
        input_tree = tree_set{a};
        temp_alphabet = get_tree_alphabet(input_tree);
        if length(temp_alphabet) > alphabet
            alphabet = temp_alphabet;
        end
    end

    for a = 1:length(tree_set)
        tree_variant = tree_set{a};
        tikz_seq = tikz_tree(tree_variant, [0:length(alphabet)-1], 1); %#ok<NBRAK>
        file_name = [prefix '_' num2str(a) ];
        standalone_tickztree(target_path, tikz_seq, file_name);    
    end

end