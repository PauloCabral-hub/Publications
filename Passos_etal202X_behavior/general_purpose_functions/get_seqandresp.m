% [chain_seq, resp_seq, rt_seq] = get_seqandresp(data, tau, id, from, till)
%
% DESCRIPTION: Given the <data> matrix of the goalkeeper retrieves the 
% sequences associated with the tree identified by <tree> of the participant
% identified by <id> from position <from> to position <till>
%
% INPUT:
% data = data matrix used in the goalkeeper lab
% tree = index that identifies a given tree in files for reference
% id = id of the participant
% from = starting from position
% till = ending in position
%
% OUTPUT:
% chain_seq = conditioning sequence
% resp_seq = sequence of responses
% rt_seq = sequence of response times
%
% AUTHOR: Paulo Cabral  DATE: 13/08/2024


function [chain_seq, resp_seq, rt_seq] = get_seqandresp(data,tau, id, from, till)


b = 0; e = 0;
for a = 1:length(data)
   if (data(a,3) == 1)&&((data(a,6) == id)&&(data(a,5) == tau))
        b = a+from-1;
        e = b+(till-from);
        break;
   end
end

chain_seq = data(b:e,9); 
resp_seq = data(b:e,8);
rt_seq = data(b:e,7);

end
