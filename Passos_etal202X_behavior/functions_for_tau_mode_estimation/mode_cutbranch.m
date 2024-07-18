% mode_tree = mode_cutbranch(s, pos, mode_tree, ctx_set, ctx_count)
%
% Returns the <mode_tree> given the set of contexts in <ctx_set> and
% the counts in <ctx_count>.
%
% INPUT:
% 
% s         = row vector representing a sequence that induces a brach of
%           a tree.
% pos =     = row vector indicating in which positions  of  <mode_tree> se-
%           quences induced by <s> are found.
% mode_tree = cell in which each column presents a different context of the
%           mode_tree during a given step of the estimation procedure.
% ctx_set   = cell in which each column presents a context
% ctx_count = row vector containing counts associated to the  contexts  in 
%           ctx_count
%
% OUTPUT:
%
% mode_tree = cell in which each column presents a different context of the
%           mode_tree during a given step of the estimation procedure.
%
% AUTHOR: Paulo Roberto Cabral Passos Last MODIFIED: 09/08/2023

function mode_tree = mode_cutbranch(s, pos, mode_tree, ctx_set, ctx_count)

sind = cell(1,length(pos));
for a = 1:length(pos)
sind{1,a} = mode_tree{1,pos(1,a)};
end

[k, found] = caseforcut(mode_tree,pos , ctx_set, ctx_count);

% case 1: all induced strings occured 

if (sum(found) == length(pos))
    if k == 0
        if brother_suffofacontext(mode_tree, mode_tree{1,pos(1,1)}, 3)
            if find(found == 0)
                mode_tree = clean_nonest(mode_tree, pos, found);
            end
        else
            mode_tree = removing_branch_how(mode_tree,pos,s,0);
        end
    end
end

% case 2: no ocurrence of any induced strings

if isempty(find(found == 1)) %#ok<EFIND>
    mode_tree = removing_branch_how(mode_tree,pos,s,0);
end


% case 3: just one of the induced strings occurred

if sum(found) == 1 
posx =  pos(1,find(found ~= 0)); %#ok<FNDSB>
        if brother_suffofacontext(mode_tree, mode_tree{1,posx}, 3)
            if find(found == 0)
            mode_tree = clean_nonest(mode_tree, pos, found);
            end
        else
            mode_tree = removing_branch_how(mode_tree,pos,s,0);
        end
end

% case 4 : at least 2 of the induced strings occurred

if ( sum(found) >= 2 )&&( sum(found) < (length(pos)) )
    sind = cell(1,length(pos)); auxpos = [];
    for a = 1:length(pos)
        if found(1,a) == 0
        mode_tree{1,pos(1,a)} = [];
        else
        auxpos = [auxpos pos(1,a)]; sind{1,a} = mode_tree{1,pos(1,a)}; %#ok<AGROW>
        end
    end
    pos = auxpos;
    % choosing if it should be prunned
    % option 1
    jump = 0;
    for a = 1:length(pos)
        if brother_suffofacontext(mode_tree, mode_tree{1,pos(a)}, 3)
           jump = 1;
        end
    end
    if jump == 0
        if k == 0
        mode_tree = removing_branch_how(mode_tree,pos,s,0); 
        end        
    end
end
    

% cleaning empties
mode_tree = removing_branch_how(mode_tree,[],[], 1);

end


