% [tau_mode, count_vec] = taumode_est(alphal, trees_list, from_height)
%
% Returns the mode tree <tau_mode> estimated from the set of trees in <tre-
% es_set>. This algorithm is designed to work with the  following  alphabet 
% A = {0, 1, 2}.
%
% INPUT:
% 
% alphal      = positive integer that corresponds to the length of the  al-
%             phabet.
% trees_list   = cell containing at each column a tree.
% from_height = integer that idicates from which height the algorithm
%             should start the prunning procedure. 
%
% OUTPUT:
%
% tau_mode   = cell in which each entry corresponds to a context of the
%            mode tree
% count_vec  = returns the number of times a given context appeared in
% <tree_list>
%
% AUTHOR: Paulo Roberto Cabral Passos Last MODIFIED: 04/02/2025

function [mode_tau, count_vec] = taumode_est(alphal, trees_list, from_height)
    
    holder = cell(1,1); aux_add = 1;
    for a = 1:length(trees_list) 
        if ~isempty(trees_list{1,a})
           holder{1,aux_add} = trees_list{1,a};
           aux_add = aux_add+1;
        end
    end
    trees_list = holder;
    
    [trees_set, var_count, ~] = unique_trees(trees_list);
    [ctx_set, ctx_count] = ctx_trees_count(trees_set, var_count);

    A = zeros(1,alphal);
    for a = 1:alphal
        A(1,a) = a-1;
    end

    perm = permwithrep(A,from_height);

    mode_tau = cell(1,length(A)^from_height);

    for a = 1:size(perm,1)
    mode_tau{1,a} = perm(a,:);
    end
    
    for h = 1:from_height
        if (from_height-h) == 0 % comment: visiting the root branch.
            perm = [];
            branchs = 1;
        else
            perm = permwithrep(A,from_height-h);
            branchs = size(perm,1);
        end
        % comment: finding the leafs of the branch
        for a = 1:branchs
           pos = []; 
           for b = 1:length(mode_tau)
                if (branchs == 1)&&(from_height-h == 0) % comment: visiting the root branch
                    if length(mode_tau{1,b}) == 1 
                            pos = [pos b]; %#ok<AGROW>
                    end                    
                else
                    if(length(mode_tau{1,b}) == (length(perm(a,:))+1))
                        aux = sum(perm(a,:) == mode_tau{1,b}(2:end),2)/length(perm(a,:)); % comment: test if it belongs to the branch
                        if  aux == 1
                            pos = [pos b]; %#ok<AGROW>
                        end
                    end    
                end
           end
        % Pruning Procedure
            if ~isempty(pos)
                if isempty(perm) % comment: on root branch
                    mode_tau = mode_cutbranch(perm,pos, mode_tau, ctx_set, ctx_count); 
                else % comment: on other branches
                    mode_tau = mode_cutbranch(perm(a,:),pos, mode_tau, ctx_set, ctx_count);
                end
            end
        end
    end
    
    count_vec = zeros(1, length(mode_tau));
    for a = 1:length(mode_tau)
       count = 0;
       cur_ctx = mode_tau{1,a};
       for b = 1:length(trees_list)
          cur_tree = trees_list{1,b};
          for l = 1:length(cur_tree)
              other_ctx = cur_tree{1,l};
              if ( length(other_ctx) == length(cur_ctx) ) && all( other_ctx == cur_ctx )
                 count = count + 1;
              end
          end
       end
       count_vec(a) = count;
    end
    
end