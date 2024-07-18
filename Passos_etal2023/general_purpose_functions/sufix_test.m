% log_test = sufix_test(v,w)
%
% This function test if v is sufix of w. Both being vectors.

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