% alphabet = get_tree_alphabet(input_tree)
%
% DESCRIPTION: Gets a tree in the form of a single column/line cell and
% returns the alphabet in the tree
%
% INPUT:
%
% tree = tree in the form of a cell.
%
% ex.: tree = {[0], [0 1], [1 1], [2 1], [2]};
%
% OUTPUT:
%
% alphabet = alphabet used in the tree
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 15/04/2024

function alphabet = get_tree_alphabet(input_tree)

    if isempty(input_tree)
       disp('WARNING: empty tree. No alphabet can be retrieved.');
       alphabet = [];
       return
    end

alphabet = []; 
    for a = 1:length(input_tree)
        leaf = input_tree{a};
        for b = 1:length(leaf)
            alphabet = [alphabet leaf]; %#ok<AGROW>
        end
    end

alphabet = unique(alphabet);

end