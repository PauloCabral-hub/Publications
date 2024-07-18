% tau_est = removing_branch_how(tau_est, pos, scontext, cleans)
%
% Returns <tau_est> with the branch induced by <s> prunned. Also used
% for cleaning empty strings in <tau_est>.
%
% INPUT:
%
% tau_est  = cell in which each entry corresponds to a context of the 
%          estimated tree.
% pos      = indicates the indixes in <tau_est> where contexts  indu-
%           ced by <scontext> occur.
% scontext = string which induces a branch.
% clean    = set to 1 to clean empty contexts in <tau_est>
%
% OUTPUT:
%
% tau_est  = cell in which each entry corresponds to a context of the 
%          estimated tree.
%
% AUTHOR: Paulo Roberto Cabral Passos     MODIFIED: 02/08/2023

function tau_est = removing_branch_how(tau_est, pos, scontext, clean)


if clean == 1
    holder = cell(1,1); aux = 1;
    for a = 1:length(tau_est)
        if ~isempty(tau_est{1,a})
           holder{1,aux} = tau_est{1,a};
           aux = aux+1;
        end
    end
    tau_est = holder;
    if (length(tau_est) == 1)&&(isempty(tau_est{1,1}))
    tau_est = [];
    end    
else
    if (length(tau_est)-length(pos)) == 0
        tau_est = [];
    else
        holder = cell(1,length(tau_est)-length(pos));
        aux0 = 1; 
        for c = 1:length(tau_est)
           aux = isempty(find(c == pos,1));
           if aux == 1
           holder{1,aux0} = tau_est{1,c};
           aux0=aux0+1;
           end
        end
        tau_est = holder;
        if insert_s(tau_est,scontext) == 1; tau_est{1,length(tau_est)+1} = scontext; end
    end    
end
 

end
