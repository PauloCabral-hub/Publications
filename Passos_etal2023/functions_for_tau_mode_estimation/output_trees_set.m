% [trees_set, var_count, which_tree] = output_trees_set(trees_list)
%
% Identifies the trees that occur in <trees_list>  and  returns  it without
% repetion in <trees_set> along with the number of times that each tree  in 
% <unique> appears in <trees_list>. 
%
% INPUT:
% 
% trees_list = cell containing at each column a different tree.
%
% OUTPUT:
%
% trees_set   = cell in which each column presents a tree that  appears  at
%             least one time in <trees_list>.
% var_count   = row vector with the same size of <trees_set> that indicates
%             in position k how many times the tree in the same position in
%             <trees_set> occurs.
% which_tree  = row vector with the same size of <trees_list>. It   indica-
%             tes the location of the tree in  position  k  <tree_list>  in 
%             <trees_set>.
%
% AUTHOR: Paulo Roberto Cabral Passos Last MODIFIED: 09/08/2023

function [trees_set, var_count, which_tree] = output_trees_set(trees_list)


un = 0; emptie = 0; var_count = []; which_tree = zeros(1,length(trees_list));
for a = 1:length(trees_list)
    tree = trees_list{1,a}; add = 1;
    if un == 0
        trees_set = cell(1,1);
        add = 1; 
    else
        for b = 1:un
            utree = trees_set{1,b};
            if length(tree) == length(utree) % comment: in case that can be the same tree
                if isempty(tree)
                    if emptie == 0
                        add = 1;
                        break; 
                    else
                        add = 0; var_count(1,empix) = var_count(1,empix)+1; which_tree(1,a) = empix;
                        break;
                    end
                else
                matching = zeros(1,length(tree));
                    for w = 1:length(tree)
                        for u = 1:length(utree)
                            if isequal(tree{1,w},utree{1,u})
                            matching(1,w) = 1;   
                            end
                        end
                    end
                result = sum(matching)/length(matching);
                    if result == 1
                        add = 0; var_count(1,b) = var_count(1,b)+1; which_tree(1,a) = b;
                        break;
                    end
                end
            end
        end
    end
    if add == 1 % comment: adding the empty list to the set
        if isempty(tree)
           emptie = 1;
           empix = un+1;
        end
        un = un+1;
        trees_set{1,un} = tree; var_count(1,un) = 1; which_tree(1,a) = un;
    end
end


end

