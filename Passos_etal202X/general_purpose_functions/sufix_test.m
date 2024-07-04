% log_test = sufix_test(v,w)
%
% Description: Verifies if sequence v is a sufix of sequence w.
%
% INPUT:
% v = sequence vector
% w = sequence vector
%
% OUTPUT:
%
% log_test = result of the test, 1 indicates that v is a suffix of w
%
% Author: Paulo Roberto Cabral Passos Date: 10/04/23

function log_test = sufix_test(v,w)
    if length(v) == length(w)
        if isequal(v,w)
            log_test = 1;
        else
            log_test = 0;
           return
        end
    elseif length(v) > length(w)
          log_test =  0;
    else
          if isempty(v)
              log_test = 1;
              return
          elseif isequal(w(1+(length(w)-length(v)):length(w)),v)
              log_test = 1;
              return
          else
              log_test = 0;
              return
          end
    end
end