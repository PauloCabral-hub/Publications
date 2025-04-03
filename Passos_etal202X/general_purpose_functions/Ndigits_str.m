% str_out = Ndigits_str(int_in, digits)
%
% The function takes an integer as the input and returns the integer as a
% string with the number of zeros to the left so as to match digits.
%
% INPUT:
% int_in = integer number to be converted to a string
%
% OUTPUT:
% digits = number of digits that should represent the integer in the
% corresponding string
%
% AUTHOR: Paulo Roberto Cabral Passos LAST MODIFICATION: 23/01/2025

function str_out = Ndigits_str(int_in, digits)
    str_out = num2str(int_in);
    zero_append = digits - length( str_out );
    while zero_append > 0
       str_out = [ '0' str_out ]; %#ok<AGROW>
       zero_append = digits - length( str_out );
    end
end