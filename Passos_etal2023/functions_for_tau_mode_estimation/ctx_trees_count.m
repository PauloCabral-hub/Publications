% [ctx_set, ctx_count] = ctx_trees_count(trees_set, var_count)
%
% Returns from <trees_set> which contexts appear and how many  times  each
% occur.
%
% INPUT:
% 
% trees_set = cell in which each column presents a tree.
% var_count = row vector presenting the counts of each tree in <trees_set>.
%
% OUTPUT:
%
% ctx_set   = cell in which each column presents a context that appear  in
% <trees_set>
% ctx_count = row vector which indicates how many times  each  context  in    
% <ctx_set> appear.
%
% AUTHOR: Paulo Roberto Cabral Passos Last MODIFIED: 09/08/2023

function [ctx_set, ctx_count] = ctx_trees_count(trees_set, var_count)

ctx_set = cell(1,1); next = 1;
for a = 1:length(trees_set)
    for b = 1:length(trees_set{1,a})
    u = trees_set{1,a}{1,b};
    aux = 0;
        for c = 1:length(ctx_set)
            if isequal(u,ctx_set{1,c})
            aux = 1;
            break;
            end
        end
        if aux == 0
        ctx_set{1,next} = u;
        next = next+1;
        end
    end
end

ctx_count = zeros(1,length(ctx_set));
for a = 1:length(ctx_set)
u = ctx_set{1,a};
    for b = 1:length(trees_set)
        for c = 1:length(trees_set{1,b})
        v = trees_set{1,b}{1,c};
            if isequal(u,v)
            ctx_count(1,a) = ctx_count(1,a)+var_count(1,b);
            end
        end
    end
end

end