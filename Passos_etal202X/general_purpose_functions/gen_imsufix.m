% sufix_vec = gen_imsufix(vector)
%
% Returns the immediate suffix of the row vector.
%
% INPUT:
%
% vector = vector of integers
%
% OUTPUT:
%
% imsufix = row vector containing the immediate sufix of 
%           the input vector.
%
% AUTHOR: Paulo Roberto Cabral Passos MODIFIED: 03/08/2023


function sufix_vec = gen_imsufix(vector)
    if length(vector) > 1
       sufix_vec = vector(1,2:end);
    else
       sufix_vec = [];
    end
end