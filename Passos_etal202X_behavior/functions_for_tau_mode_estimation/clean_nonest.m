% mode_tree = clean_nonest(mode_tree, pos, found)
%
% Returns <mode_tree> after removing non-occuring contexts base  on  <pos> 
% and <found>
%
% INPUT:
%
% mode_tree = cell in which each column presents a different context of the
%           mode_tree during a given step of the estimation procedure.
% pos =     = row vector indicating in which positions  of  <mode_tree> se-
%           quences induced by <s> are found.
% found     = row vector that indicates the positions of sequences induced
%             by the same string and composing the elements  of  the  same   
%             branchs in <mode_tree>.
%
% OUTPUT:
%
% mode_tree = cell in which each column presents a different context of the
%           mode_tree during a given step of the estimation procedure.
%
% AUTHOR: Paulo Roberto Cabral Passos Last MODIFIED: 09/08/202


function mode_tree = clean_nonest(mode_tree, pos, found)

if find(found == 0)
pos0 =  pos(1,find(found == 0)); %#ok<FNDSB> 
holder = cell(1,length(mode_tree)-length(pos0));
aux0 = 1;
    for c = 1:length(mode_tree)
       aux = isempty(find(c == pos0,1));
       if aux == 1
       holder{1,aux0} = mode_tree{1,c};
       aux0=aux0+1;
       end
    end
mode_tree = holder;

end