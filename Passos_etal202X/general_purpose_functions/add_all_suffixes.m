% output_tree = add_all_suffixes(input_tree)
%
% DESCRIPTION: The function returns the vertice tree from the provided tree
% structure.
%
% ex. of a tree: 
% tree = {[0, [0 1], [1 1], [2 1], 2};
% ex. of the output_tree
% tree = {[0, [0 1], [1 1], [2 1], 2, 1};
%
% INPUT:
%
% input_tree = A tree structure defined as in the example.
%
% OUTPUT:
%
% output_tree = corresponding vertice tree from the input tree;
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 18/02/2025

function output_tree = add_all_suffixes(input_tree)

if isempty(input_tree)
   %disp('Empty trees have no vertices.')
   output_tree = input_tree;
   return 
end

a = 1;
while a <= length(input_tree)
    w = input_tree{1,a};
    if length(w) > 1
       w_suf = gen_imsufix(w);
       add_w_suf = 1;
       for b = 1:length(input_tree)
          w_prime = input_tree{1,b};
          if isequal(w_suf, w_prime)
             add_w_suf = 0; 
          end
       end
       if add_w_suf == 1
          input_tree{1,length(input_tree)+1} = w_suf; 
       end
    end
a = a + 1;
end

output_tree = input_tree;

end