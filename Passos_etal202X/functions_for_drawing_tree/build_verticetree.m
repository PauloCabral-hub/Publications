% [fvtree, velements] = build_verticetree(alphabet, tree)
%
% Returns a vertice tree for <tree> coposed of the elements  of  <fvtree>.
% The row vector <velements> has the same dimensions of <fvtree>. The  en-
% in <velements> are filled with 0's and 1's. 1 indicates that the element
% of <fvtree> in that position is a vertice of <tree>.
%
% INPUT:
%
% alphabet    = row vector containing the symbols of the tree
% tree        = cell in which each column indicates a leaf of a tree. 
%
% OUTPUT:
%
% fvtree      = cell in which each column contains a vertice  of  the  full 
%             tree with the same height as tree.
% velements   = vector of 0's and 1's indicating which elements of <fvtree> 
%             are present in the vertice tree of <tree>.
% vtree       = cell in which each column corresponds to a vertice of <tre-
%              e>
%             
% AUTHOR: Paulo Roberto Cabral Passos   MODIFIED: 03/08/2023

function [fvtree, velements, vtree] = build_verticetree(alphabet, tree)

height = 0;
for k = 1:length(tree)
    if length(tree{1,k}) > height
       height = length(tree{1,k});
    end
end

fvtree = full_tree_with_vertices(alphabet, height);
velements = zeros(1,length(fvtree));

    for w = 1:length(tree)
        w_next = tree{1,w};
        for s = 1:length(fvtree)
            if isequal(tree{1,w},fvtree{1,s})
               while ~isempty(w_next)
                      for ws = 1:length(fvtree)
                          if isequal(fvtree{1,ws},w_next)
                             velements(1,ws) = 1;
                          end
                      end
                      w_next = gen_imsufix(w_next);
               end   
            end
        end
    end

vtree = fvtree(1, find(velements == 1)); %#ok<FNDSB>

end