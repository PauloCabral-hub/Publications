% result = treesequal(tree_a, tree_b)
%
% Description: Returns 1 if trees are equal
%
% INPUT:
%
% tree_a = first tree
% tree_b = second tree
%
% OUTPUT:
%
% result = 1 if the trees are equal, 0 otherwise
%
% AUTHOR: Paulo Roberto Cabral Passos   MODIFIED: 07/03/2024

function result = treesequal(tree_a, tree_b)
    
    % Testing empty trees
    if isempty(tree_a)
       if isempty(tree_b)
           result = 1;
           return
       else
           result = 0;
           return
       end
    else
       if isempty(tree_b)
          result = 0;
          return
       end
    end

    
    % Testing non-empty trees
    aux = 0;
    for k = 1:length(tree_a)
       ctx = tree_a{k};
       for k2 = 1:length(tree_b)
          ctx2 = tree_b{k2};
          if isequal(ctx,ctx2)
             aux = aux+1; 
          end
       end
    end
    
    if aux == length(tree_a)
       if length(tree_a) == length(tree_b)
          result = 1;
          return
       end
    end
    result = 0;
    

end