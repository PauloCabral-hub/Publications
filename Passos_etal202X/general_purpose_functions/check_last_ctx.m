% pos = check_last_ctx(vec, tree)
%
% DESCRIPTION: Check the last context in vec and returns its corresponding
% position in the tree;
%
% INPUT:
%
% vec = contains a markov chain following the tree in contexts
%
% OUTPUT:
%
% pos = last context position in tree
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 20/02/2025

function pos = check_last_ctx(vec, tree)

for a = 1:length(tree)
   ctx = tree{1,a};
   if length(vec)  > ( length(ctx) - 1 )
      if isequal(  vec( 1, length(vec)-length(ctx) + 1:length(vec) ), ctx  )
         pos = a;
         return
      end
   end
end
