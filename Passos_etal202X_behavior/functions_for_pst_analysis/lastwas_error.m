% [ctx_fer,ct_poscell] = lastwas_error(ct_pos, ctx_er, contexts, chain, responses, step)
%
% The function returns for the given chain and responses of the goalkeeper
% game if the the response was given following an error (1) or not (0);
%
% INPUT: 
% ct_pos = matrix of (contexts , positions);
% ctx_er =  cell containing the information regarding the success or
% failure in predicting the kicker's choice given a the context;
% contexts = cell containing the contexts;
% chain = chain given by get_seqandresp;
% responses =  responses given by get_seqandresp;
% step = how many before;
%
% OUTPUT:
% ctx_fer = matrix similar to ctx_er, but refering to the the last trial;
% ct_poscell = ct_pos in cell form;
%
% Author: Paulo Roberto Cabral Passos  Last Modified: 24/06/2021

function [ctx_fer,ct_poscell] = lastwas_error(ct_pos, ctx_er, contexts, chain, responses, step)

ct_poscell = cell(length(contexts),1);
for a = 1:length(contexts)
   for b = 1:size(ct_pos,2)
       if ct_pos(a,b) ~= 0
          ct_poscell{a,1} = [ct_poscell{a,1} ; ct_pos(a,b)]; %#ok<USENS>
       end
   end 
end

ctx_fer = cell(length(ct_poscell),1);
for a = 1:length(ct_poscell)
    for b = 1:size(ctx_er{a,1},1)
        pos = ct_poscell{a,1}(b,1) +1 - step;
        if (pos < 1) || (chain(pos,1) == responses(pos,1))
           ctx_fer{a,1} = [ ctx_fer{a,1}; 0];
        else
           ctx_fer{a,1} = [ ctx_fer{a,1}; 1];
        end
    end
end


end