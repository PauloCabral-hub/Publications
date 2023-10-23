% [ctx_posi, ctx_pose, ctx_count] = count_contexts(contexts, chain)
%
% Returns the number of contexts in in the sequence defined in <chain>.
%
% INPUT:
%
% contexts  =  cell with a different context expressed as a vector in each column.
% chain     =  sequence in which the contexts will be counted
%
% OUTPUT:
%
% ctx_count =  column vector containing the count of each context. The conunt in 
%              row j corresponds to the context in column j of <contexts>
% ctx_posi  =  matrix with dimensions NxN in which N is the length of the <chain-
%              >. If M is the number of contexts, then each row with index > M is
%              filled with zeros. Non-zero values in row j corresponds to   posi-
%              tions where the first symbol of the context in column j of   <con-
%              texts> appear in <chain>.
% ctx_pose  =  matrix with dimensions NxN in which N is the length of the <chain-
%              >. If M is the number of contexts, then each row with index > M is
%              filled with zeros. Non-zero values in row j corresponds to   posi-
%              tions where the last symbol of the context in column j of    <con-
%              texts> appear in <chain>.
%
% AUTHOR: Paulo Roberto Cabral Passos MODIFIED: 02/08/2023

function [ctx_posi, ctx_pose, ctx_count] = count_contexts(contexts, chain)

N = size(contexts,2);

ctx_count = zeros(N,1);

S = length(chain);
ctx_posi = zeros(S,S);
ctx_pose = zeros(S,S);

for a = 1: N
    lc = length(contexts{1,a}); aux = contexts{1,a};
    b = lc;
    d = 1;dc = 1;
    while b < S
        ul = b;
        ll = b-lc+1; 
        if strcmp(num2str(chain(1, ll:ul)), num2str(aux)) 
        ctx_count(a,1) = ctx_count(a,1)+1;
        ctx_posi(a,dc) = d; ctx_pose(a,dc) = b;dc = dc+1;
        end
    d = d+1;    
    b = b+1;    
    end    
end

end

