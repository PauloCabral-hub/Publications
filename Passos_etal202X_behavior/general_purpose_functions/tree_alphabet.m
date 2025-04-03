% alphabet = tree_alphabet(full_tree)
%
% Descriction: returns the alphabet of the corresponding non-empty tree
% 
% INPUT:
% full_tree = a tree given by the function full_tree_with_vertices.
%
% OUTPUT:
% alphabet = vector containing the alphabet of the tree.
%
% Author: Paulo Roberto Cabral Passos date: 05/03/2024

function alphabet = tree_alphabet(full_tree)

    if isempty(full_tree)
        disp('EMPTY TREE. No alphabet can be provided.')
        return
    end
    
    tree = [];
    for k = 1:length(full_tree)
       tree = [tree full_tree{k}];  %#ok<AGROW>
    end
    alphabet = unique(tree);
end