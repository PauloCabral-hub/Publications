% full_tree = full_tree_with_vertices(alphabet, height)
%
% Returns a full vertice tree with height defined in <height> using the al-
% phabet in the row vector <alphabet>. See balding 2009, for the definition
% of the the vertice tree.
%
% INPUT:
%
% alphabet  = a row vector with the tree symbols.
% height    = an integer that indicates the height of the tree.
%
% OUTPUT:
%
% full_tree = a cell with each column containing one vertice of the tree.
%
% AUTHOR: Paulo Roberto Cabral Passos MODIFIED: 03/08/2023
%
% REFERENCE: Balding, D., Ferrari, P.A., Fraiman, R. et al. Limit theorems 
%            for sequences of random trees. TEST 18, 302–315 (2009). https
%            ://doi.org/10.1007/s11749-008-0092-z


function full_tree = full_tree_with_vertices(alphabet, height)

size_aux = 0;
    for a = 1:height
        size_aux = size_aux + length(alphabet)^a;
    end

full_tree = cell(1,size_aux); aux = 1;
    for h = 1:height
        new_strings = permwithrep(alphabet, h);
        for k = 1:size(new_strings,1)
            full_tree{1,aux} = new_strings(k,:);
            aux = aux+1;
        end
    end

end