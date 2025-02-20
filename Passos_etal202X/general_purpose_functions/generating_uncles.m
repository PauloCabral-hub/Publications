% uncles = generating_uncles(child_choice, alphabet)
%
% Description: Generates the uncles of a given child.
%
% INPUT:
%
% child_choice = vector of integers
% alphabet = alphabet with which the child was generated
%
% OUTPUT:
%
% uncles = uncles of the child
%
% Author: Paulo Roberto Cabral Passos Date: 10/04/23

function uncles = generating_uncles(child_choice, alphabet)

    if length(child_choice)>1
       w_aux = gen_imsufix(child_choice);
       if length(w_aux) ~= 1
          uncles = zeros( length(alphabet)-1, length(w_aux) ); aux_add2 = 1;
          for a = 1:length(alphabet)
              if w_aux(1,1) ~= alphabet(a)
                 uncles(aux_add2,:) = [ alphabet(a) gen_imsufix(w_aux)]; 
                 aux_add2 = aux_add2 + 1;
              end
          end
       else 
          uncles = zeros( length(alphabet)-1,1); aux_add2 = 1;
          for a = 1:length(alphabet)
              if w_aux(1,1) ~= alphabet(a)
                 uncles(aux_add2,:) = alphabet(a); 
                 aux_add2 = aux_add2 + 1;
              end
          end       
       end
    else
       uncles = zeros( length(alphabet)-1,1); aux_add2 = 1;
       for a = 1:length(alphabet)
           if child_choice(1,1) ~= alphabet(a)
              uncles(aux_add2,:) = alphabet(a); 
              aux_add2 = aux_add2 + 1;
           end
       end              
    end

end