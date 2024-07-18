% dorder_tree_repo = order_distances(path_to_rtree,rtree, tree_repo)
%
% DESCRIPTION: 
%
% INPUT:
%
%
% OUTPUT:
%
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2024

function dorder_tree_repo = order_distances(path_to_rtree,rtree, vec_tree_repo)


[contexts, ~] = build_treePM ([path_to_rtree '/num' num2str(rtree) '.tree']);

% Getting the unique trees
unique_trees = {};
aux = 1;
    for a = 1:length(vec_tree_repo) 
        tree_var = vec_tree_repo{a};
        if isempty(unique_trees)
           unique_trees{aux} = tree_var; %#ok<AGROW>
           aux = aux+1;
        else
            checker = 1;
            for b = 1:length(unique_trees)
                if treesequal(tree_var,unique_trees{b})
                    checker = 0;
                end
            end
            if checker == 1
               unique_trees{aux} = tree_var; %#ok<AGROW>
               aux = aux+1;            
            end
        end
    end
Dists = zeros(length(unique_trees),1);

    for a = 1:length(unique_trees)
      Dists(a,1) = balding_distance(contexts,unique_trees{a}); 
    end
[~, Ds_asc] = sort(Dists);

% Getting the number in ascending order


dorder_tree_repo = zeros(size(vec_tree_repo,1),1);
for a = 1:size(vec_tree_repo,1)
    for b = 1:size(unique_trees,2)
        if treesequal(vec_tree_repo{a},unique_trees{b})
           dorder_tree_repo(a) = Ds_asc(b); 
        end
    end
end
    
end

