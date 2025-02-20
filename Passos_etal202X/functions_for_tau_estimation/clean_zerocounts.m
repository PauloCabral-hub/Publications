% tau_est = clean_zerocounts(tau_est, pos, count)
%
% Returns <tau_est> after removing contexts that do not occur according
% to the counts in <count>.
%
% INPUT:
%
% tau_est = cell in which each entry corresponds to a context of the 
%           estimated tree.
% pos     = column vector containing counts of the contexts in <tau_-
%           est>
% count   = a vector with the occurence count of each branch
%
% OUTPUT:
%
% tau_est = cell in which each entry corresponds to a context of the 
%           estimated tree.
%
% AUTHOR: Paulo Roberto Cabral Passos MODIFIED: 02/08/2023

function tau_est = clean_zerocounts(tau_est, pos, count)

if find(count == 0)
pos0 =  pos(1,find(count == 0)); %#ok<FNDSB> comment:checking contexts with zero count.
holder = cell(1,length(tau_est)-length(pos0));
aux0 = 1; 
    for c = 1:length(tau_est)
       aux = isempty(find(c == pos0,1));
       if aux == 1
       holder{1,aux0} = tau_est{1,c};
       aux0=aux0+1;
       end
    end
tau_est = holder;


end