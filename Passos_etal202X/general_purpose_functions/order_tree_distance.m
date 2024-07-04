% gsummary_repo = order_tree_distance(path_to_rtree,rtree, gsummary_repo)
%
% DESCRIPTION: returns a summary structure from load_est_trees with the the
% followed information added: a tree number that indicates the distance from
% a referece tree and number of the block. 
%
% INPUT:
%
% gsummary_repo = as returned from gsummary_repo;
% path_to_rtree = path where to find the reference tree (.tree)
% rtree = integer that indicate the number of the reference tree
%
% OUTPUT:
%
% gsummary_repo = same structure of the input with the added information
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2024

function gsummary_repo = order_tree_distance(path_to_rtree,rtree, gsummary_repo)

[contexts, ~] = build_treePM ([path_to_rtree '/num' num2str(rtree) '.tree']);

% Getting the unique trees
unique_trees = {};
aux = 1;
    for a = 1:length(gsummary_repo) 
        tree_var = gsummary_repo(a).tree;
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

    for a=1:length(gsummary_repo)
        tree_var = gsummary_repo(a).tree;
        for b = 1:length(unique_trees)
            if treesequal(tree_var,unique_trees{b})
               gsummary_repo(a).tree_num = find(Ds_asc == b); 
            end
        end
    end
    
    blocks = [];
    for a = 1:length(gsummary_repo)
        blocks = [blocks; gsummary_repo(a).from gsummary_repo(a).to];  %#ok<AGROW>
    end
    blocks = unique(blocks, 'rows');
    aux_s = blocks(2,:);
    blocks = [blocks(1,:); blocks(3:end,:)];
    blocks = [blocks; aux_s];
    for a = 1:length(gsummary_repo)
       for b = 1:size(blocks,1)
           if (gsummary_repo(a).from == blocks(b,1)) && (gsummary_repo(a).to == blocks(b,2))
               gsummary_repo(a).block = b;
           end
       end
    end
    
end

