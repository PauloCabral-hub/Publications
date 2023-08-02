% result = brother_suffofacontext(tau_est, w, alphal)
%
% Returns an integer <result> which indicates if <w> is suffix of any
% context in tau_est.
%
% INPUT:
%
% tau_est = cell in which each entry corresponds to a context of the 
%           estimated tree.
% w       = vector representing a context to be tested.
% alphal  = length of the alphabet used to describe the conditioning
%           sequence.
%
% OUTPUT:
% result  = set to 1 if <w> is suffix of a context in <tau_est>. 
%
% AUTHOR: Paulo Roberto Cabral Passos MODIFIED: 02/08/2023


function result = brother_suffofacontext(tau_est, w, alphal)

% Determining which are the brothers

brothers = cell(1,alphal-1);
aux = 1;
if length(w) == 1
    for a = 1:alphal 
        if (a-1) ~= w
            brothers{1,aux} = a-1;
            aux = aux+1;
        end
    end
else
    u = w(2:end);
    for a = 1:alphal
        if ~isequal([(a-1) u], w)
           brothers{1,aux} = [(a-1) u];
           aux = aux+1;
        end
    end
end
   
% Testing

result = 0;
for a = 1: length(tau_est)
    for b = 1:length(brothers)
       if length(tau_est{1,a}) > length(brothers{1,b})
          result = ~ insert_s({tau_est{1,a}}, brothers{1,b}); % test of suffix, if it returns 0 it means suffix
          if result == 1
            return
          end
       end
    end
end

result  = 0;
end

% % BACKUP 08/01/2021
% 
% % result = brother_suffofacontext(tau_est, w, alphal)
% %
% % This function test if the brothers of w are suffix of contexts that appear
% % in the final estimated tree.
% %
% % INPUT:
% % tau_est = estimated tree till now
% % w = the context that will be tested
% % alphal = length of the alphabet
% %
% % OUTPUT:
% % result = 1 if the brothers are sufix of contexts not prunned after test,
% % 0 otherwise.
% 
% 
% function result = brother_suffofacontext(tau_est, w, alphal)
% 
% % Determining which are the brothers
% 
% brothers = cell(1,alphal-1);
% aux = 1;
% if length(w) == 1
%     for a = 1:alphal 
%         if (a-1) ~= w
%             brothers{1,aux} = a-1;
%             aux = aux+1;
%         end
%     end
% else
%     u = w(2:end);
%     for a = 1:alphal
%         if ~isequal([(a-1) u], w)
%            brothers{1,aux} = [(a-1) u];
%            aux = aux+1;
%         end
%     end
% end
%    
% % Testing
% 
% for a = 1: length(tau_est)
%     for b = 1:length(brothers)
%        if length(tau_est{1,a}) > length(brothers{1,b})
%           result = ~ insert_s({tau_est{1,a}}, brothers{1,b}); % test of suffix, if it returns 0 it means suffix
%           return 
%        end
%     end
% end
% 
% result  = 0;
% end