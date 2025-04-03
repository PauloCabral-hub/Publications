% [elements_row, modified] = best_uncles_fit(uncle_list, elements_row)
%
% Description: UNAVAILABLE
%
% INPUT:
% variable1: UNAVAILABLE
%
% OUTPUT:
% variable1: UNAVAILABLE
%
% Author: Paulo Roberto Cabral Passos   Date: 11/04/23

function [elements_row, modified] = best_uncles_fit(uncle_list, elements_row, string_set)
uncle_candidates = find(uncle_list == 1);
pos_results = permwithrep( [0 1], length(uncle_candidates) );
[~, I] = sort( sum(pos_results,2),'descend' );
pos_results = pos_results(I,:); pos_results = pos_results(1:end-1, :);

modified = 0;
for a = 1:size(pos_results,1)
    uncle_list = zeros( 1,size(elements_row,2) );
    for b = 1:size(pos_results,2)
        if pos_results(a,b) == 1
           uncle_list(1,uncle_candidates(b)) = 1;
           elements_aux = [uncle_list + elements_row] > 0;
           %working
            if ~isequal(elements_aux, elements_row)
            % get the rectified tree
            tree_alt = string_set(find(elements_aux == 1));  %#ok<FNDSB>
               if isthisatree(tree_alt)
                  elements_row = elements_aux;
                  modified = 1; break
               end 
            end
           %working
           if modified == 1; break; end
        end
    end
    if modified == 1; break; end
end

end

