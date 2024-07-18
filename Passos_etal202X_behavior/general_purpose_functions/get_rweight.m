% rindex = get_symindex(tree)
%
% Description:...
%
% INPUT:
% ...
%
% OUTPUT:
% ...
% 
% Author: Paulo Roberto Cabral Passos Date: 05/03/2024



function rindex = get_rweight(tree)
    alphabet = [0 1 2];
    alpha_values = [1 2 3];
    
    if isempty(tree)
       rindex = 0;
       return
    end
    
    aux_vec = [];
    for k = 1: length(tree)
       aux_vec = [aux_vec tree{k}];  %#ok<AGROW>
    end
    rindex = sum(aux_vec == alphabet(1))*alpha_values(1)...
        + sum(aux_vec == alphabet(2))*alpha_values(2)...
        + sum(aux_vec == alphabet(3))*alpha_values(3);
end