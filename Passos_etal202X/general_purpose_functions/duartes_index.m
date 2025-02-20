% idx = duartes_index(alphabet, input_tree)
%
% DESCRIPTION: The function returns the index developed for resuming trees
% by Aline Duarte (in development)
%
% INPUT:
%
% alphabet = alphabet of the tree, ex. [0 1 2]
% input_tree = a tree defined as in the exemple bellow:
% ex.:
% tree_a = {0, [0 1], [1 1], [2 1], [2] };
%
% OUTPUT:
%
% idx = index
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 18/02/2025


function idx = duartes_index(alphabet, input_tree)

add_pen = {[1 0], [1 0 1], [0 1 1], [0 2 1], [0 2]};
sub_pen = {[0 1], 0};

add_p = [1/3 1/6 1/6 1/6 1/3];
sub_p = [1 1];

full_tree = full_tree_with_vertices(alphabet, get_treelength(input_tree));

% Adding all suffixes
input_tree = add_all_suffixes(input_tree);

idx = 0;

    for a = 1:length(add_pen)
       for b = 1:length(input_tree)
          if isequal(add_pen{1,a},input_tree{1,b})
             idx = idx + add_p(a); 
          end
       end
    end
    
    for a =1:length(sub_pen)
        found = 0;
        for b = 1:length(input_tree)
           if isequal(sub_pen{1,a},input_tree{1,b})
              found  = 1; 
           end
        end
        if found == 0
            idx = idx - sub_p(a);
        end
    end
    
end
