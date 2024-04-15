% istree = isthisatree(candidate)
%
% Description: Indicates if the set of vertices in candidates is a tree.
%
% INPUT:
% candidate = cell line vector containing the possible tree
%
% OUTPUT:
% istree = 1 if the candidate is a tree
%
% Author: Paulo Roberto Cabral Passos Date: 10/04/23

function istree = isthisatree(candidate)
    istree = 1;
    for a = 1:length(candidate)
        for b = 1:length(candidate)
            if (a ~= b)
               if sufix_test(candidate{1,a}, candidate{1,b})
                  istree = 0;
                  break;
               end
            end
        end
        if istree == 0
           break; 
        end
    end
end