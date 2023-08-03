% result = insert_s(tau_est, scontext)
%
% Returns 1 if the string <scontext> should be inserted in <tau_est>
% and 0 otherwise.
%
% INPUT:
% scontext = the string that induces a terminal branch
% tau_est  = cell in which each entry corresponds to a context of the 
%          estimated tree.
% OUTPUT:
%
% result = set to 1 if the string s should be inserted in <tau_est>
%
% AUTHOR: Paulo Roberto Cabral Passos MODIFIED: 02/08/2023

function result = insert_s(tau_est, scontext)

for a = 1:length(tau_est)
    u = tau_est{1,a};
    if length(u)> length(scontext)
    aux = u(1,length(u)-length(scontext)+1: end) == scontext;
        if (sum(aux,2)/length(scontext)) == 1
        result = 0;
        return;
        end
    end
end

result = 1;
end

