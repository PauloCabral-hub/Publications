% result = insert_s(tau_est, s)
%
% Returns 1 if the string <s> should be inserted in <tau_est>
% and 0 otherwise.
%
% INPUT:
% s       = the string that induces a terminal branch
% tau_est = cell in which each entry corresponds to a context of the 
%           estimated tree.
% OUTPUT:
%
% result = set to 1 if the string s should be inserted in <tau_est>
%
% AUTHOR: Paulo Roberto Cabral Passos MODIFIED: 02/08/2023

function result = insert_s(tau_est, s)

for a = 1:length(tau_est)
    u = tau_est{1,a};
    if length(u)> length(s)
    aux = u(1,length(u)-length(s)+1: end) == s;
        if (sum(aux,2)/length(s)) == 1
        result = 0;
        return;
        end
    end
end

result = 1;
end

