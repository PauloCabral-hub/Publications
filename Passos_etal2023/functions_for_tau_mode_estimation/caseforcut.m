% [k, found] = caseforcut(mode_tree, pos , ctx_set, ctx_count)
%
% Returns the decision of keeping or not a branch in <mode_tree>  based  on
% <ctx_set> and <ctx_count>.
%
% INPUT:
% 
% mode_tree = cell in which each column presents a different context of the
%           mode_tree during a given step of the estimation procedure.
% pos =     = row vector indicating in which positions  of  <mode_tree> se-
%           quences induced by <s> are found.
% ctx_set   = cell in which each column presents a context
% ctx_count = row vector containing counts associated to the  contexts  in 
%           ctx_count
%
% OUTPUT:
%
% found     = row vector that indicates the positions of sequences induced
%             by the same string and composing the elements  of  the  same   
%             branchs in <mode_tree>.
% k         = returns 1 in case of keeping the branch decision.       
%
% AUTHOR: Paulo Roberto Cabral Passos Last MODIFIED: 09/08/2023


function [k, found] = caseforcut(mode_tree, pos , ctx_set, ctxcount)


% finding the positions in ctx_set
k = 0;
found = zeros(1,length(pos));
w_pos = zeros(1,length(pos));
for a = 1:length(pos)
    u = mode_tree{1,pos(a)};
     for b = 1:length(ctx_set)
         v = ctx_set{1,b}; 
        if isequal(u,v)
           found(1,a) = found(1,a)+1; 
           w_pos(1,a) = b;
        end
     end
end


if sum(found) == 0
   return 
end



keep = zeros(1,length(pos));
for a = 1:length(pos)
    suf_pos = []; % positions are associated with ctx_set
   if found(1,a) ~= 0
      w = mode_tree{1,pos(a)};
      % finding all sufixes
      for b = 1:length(ctx_set)
          v = ctx_set{1,b};
          if sufix_test(v,w)
             if length(v) ~= length(w)
                suf_pos = [suf_pos b]; %#ok<AGROW>
             end
          end
      end
      aux = 1;
      if ~isempty(suf_pos)
          for b = 1:length(suf_pos)
             if ctxcount(1,w_pos(1,a)) < ctxcount(1,suf_pos(1,b))
                aux = 0;
                break;
             end
          end         
      end
      if aux == 1; keep(1,a) = 1; end
   end
end

if ~isempty(find(keep ~= 0)) %#ok<EFIND>
k = 1;
end

end