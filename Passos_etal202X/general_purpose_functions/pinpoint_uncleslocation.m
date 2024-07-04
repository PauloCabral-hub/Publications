% pinpoint = pinpoint_uncleslocation(full_tree, uncles)
%
% Description: pinpoint the location in full_tree in which the uncles are 
% located.
%
% INPUT:
% candidate = cell line vector containing the possible tree
%
% OUTPUT:
% istree = 1 if the candidate is a tree, 0 otherwise
%
% Author: Paulo Roberto Cabral Passos Date: 10/04/23


function pinpoint = pinpoint_uncleslocation(full_tree, uncles)

pinpoint = zeros(1,length(full_tree));
for a = 1:size(uncles,1)
   uncle_aux = uncles(a,:);
   for b = 1:length(full_tree)
      if isequal(uncle_aux,full_tree{1,b}) 
         pinpoint(1,b) = 1; 
      end
   end
end

end