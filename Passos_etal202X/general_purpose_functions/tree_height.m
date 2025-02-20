% height = tree_height(tree)
%
% DESCRIPTION: returns the height of the tree
%
% INPUT:
%
% tree = row cell with the tree structure (one leaf per column)
%
% OUTPUT:
%
% height = integer corresponding to the height of the tree
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 20/02/2025

function height = tree_height(tree)
    height = 0;
    for a = 1:length(tree)
       if length(tree{1,a}) > height
          height = length(tree{1,a});
       end
    end

end