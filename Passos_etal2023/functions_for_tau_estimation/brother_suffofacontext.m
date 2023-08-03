% result = brother_suffofacontext(tau_est, context, alphal)
%
% Returns an integer <result> which indicates if <context> is suffix of any
% context in tau_est.
%
% INPUT:
%
% tau_est = cell in which each entry corresponds to a context of the 
%           estimated tree.
% context = vector representing a context to be tested.
% alphal  = length of the alphabet used to describe the conditioning
%           sequence.
%
% OUTPUT:
% result  = set to 1 if <context> is suffix of a context in <tau_est>. 
%
% AUTHOR: Paulo Roberto Cabral Passos MODIFIED: 02/08/2023


function result = brother_suffofacontext(tau_est, context, alphal)

% determining which are the brothers

brothers = cell(1,alphal-1);
aux = 1;
if length(context) == 1
    for a = 1:alphal 
        if (a-1) ~= context
            brothers{1,aux} = a-1;
            aux = aux+1;
        end
    end
else
    u = context(2:end);
    for a = 1:alphal
        if ~isequal([(a-1) u], context)
           brothers{1,aux} = [(a-1) u];
           aux = aux+1;
        end
    end
end
   
% testing

result = 0;
for a = 1: length(tau_est)
    for b = 1:length(brothers)
       if length(tau_est{1,a}) > length(brothers{1,b})
          result = ~ insert_s({tau_est{1,a}}, brothers{1,b}); % comment: suffix test
          if result == 1
            return
          end
       end
    end
end

end

