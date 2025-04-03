% tree_len = get_treelength(tree)
%
% Descriction: returns the length of the corresponding non-empty tree
%
% INPUT:
% tree = tree or vertice tree in structure of type cell
%
% OUTPUT:
% tree_len = length of the tree
%
% Author: Paulo Roberto Cabral Passos date: 05/03/2024

function tree_len = get_treelength(tree)

    if isempty(tree)
        tree_len=0;
        return
    end
    
    tree_len = 0;
    for k = 1:length(tree)
       if length(tree{k})> tree_len
          tree_len = length(tree{k}); 
       end
    end
end