% [unique, count, whichtree] = unique_trees(estimated_trees)

% This function takes a cell of cells (estimated_trees) in which each cell 
% has a tree estimated from the response times of one of the volunteers and
% returns the unique trees (unique), the number of times that each of uni-
% que tree  was recovered (count), and from each volunteer, which one was
% recovered. 


function [unique, count, whichtree] = unique_trees(estimated_trees)


un = 0; emptie = 0; count = []; wichtree = zeros(1,length(estimated_trees));
for a = 1:length(estimated_trees)
    tree = estimated_trees{1,a}; add = 1;
    if un == 0
        unique = cell(1,1);
        add = 1;
    else
        for b = 1:un
            utree = unique{1,b};
            if length(tree) == length(utree) % Case that can be the same tree
                if isempty(tree)
                    if emptie == 0
                    emptie = 1;
                    add = 1;
                    break;
                    else
                    add = 0; count(1,empix) = count(1,empix)+1; whichtree(1,a) = empix;
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
                    add = 0; count(1,b) = count(1,b)+1; whichtree(1,a) = b;
                    break;
                    end
                end
            end
        end
    end
    if add == 1 % Adding the tree to the unique list
        if isempty(tree)
           emptie = 1;
           empix = un+1;
        end
        un = un+1;
        unique{1,un} = tree; count(1,un) = 1; whichtree(1,a) = un;
    end
end


end

