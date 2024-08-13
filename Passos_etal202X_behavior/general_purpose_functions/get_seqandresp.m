% [X,Y,Z] = get_seqandresp(data,tau,id, start, stop)
%
% This function gets the response and conditioning sequence from data.
%
% Input:
% data = same data as in responsetimeandresponses
% tau = integer indicating the tree in data.
% id = id of the participant in data.
% from = from which play it starts
% till = to which play it goes
%
% Output:
% X = column vector with the conditioning sequence
% Y = column vector with the response sequence
% Z = column vector with the response time sequence
%
% Author: Paulo Cabral Last Modified: 15/06/2020



function [X,Y,Z] = get_seqandresp(data,tau, id, from, till)


b = 0; e = 0;
for a = 1:length(data)
   if (data(a,3) == 1)&&((data(a,6) == id)&&(data(a,5) == tau))
        b = a+from-1;
        e = b+(till-from);
        break;
   end
end

X = data(b:e,9); 
Y = data(b:e,8);
Z = data(b:e,7);

end

% Backup
% function [X,Y,Z] = get_seqandresp(data,tau, id, from, till)
% 
% 
% b = 0; e = 0;
% for a = 1:length(data)
%    if (data(a,3) == 1)&&((data(a,6) == id)&&(data(a,5) == tau))
%         b = a+from-1;
%         e = b+till-1;
%         break;
%    end
% end
% 
% X = data(b:e,9); 
% Y = data(b:e,8);
% Z = data(b:e,7);
% 
% end

