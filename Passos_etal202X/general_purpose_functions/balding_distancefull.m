% d = balding_distancefull(tree_a,tree_b)
%
% This function computes the distance between to trees according to Balding
% et al. Limit theorems for sequences of random trees. 2009 (with vertices).
%
% INPUT:
% tree_a = row cell containing the contexts of tree A.
% tree_b = row cell containing the contexts of tree B.
% alphabet = row vector containing the alphabet of the trees.
%
% OUTPUT:
% d = balding distance.
%
% Author: Paulo Roberto Cabral Passos   Date: 05/03/2024

function d = balding_distancefull(tree_a,tree_b)

if isempty(tree_a) && isempty(tree_b)
   d = 0;
   return
end

al = get_treelength(tree_a);
bl = get_treelength(tree_b);
if al > bl
    alphabet = tree_alphabet(tree_a);
    full_tree = full_tree_with_vertices(alphabet, get_treelength(tree_a));
else
    alphabet = tree_alphabet(tree_b);
    full_tree = full_tree_with_vertices(alphabet, get_treelength(tree_b));
end

% Adding all suffixes
tree_a = add_all_suffixes(tree_a);
tree_b = add_all_suffixes(tree_b);

% Getting elements vector

% ..for tree_a
elements_a = zeros(1,length(full_tree));
elements_b = elements_a;
for k = 1:length(tree_a)
    a_elem = tree_a{k};
    for k2 = 1:length(full_tree)
       if isequal(a_elem, full_tree{k2})
          elements_a(k2) = 1; 
       end
    end
end

% ..for tree_b
for k = 1:length(tree_b)
    b_elem = tree_b{k};
    for k2 = 1:length(full_tree)
       if isequal(b_elem, full_tree{k2})
          elements_b(k2) = 1; 
       end
    end
end

z = 0.5;
% z = round(length(alphabet)^(-3/2),3);

d = 0;
for k = 1:length(full_tree)
    d = d + abs( elements_a(k)-elements_b(k) )*z^( length(full_tree{k}) );
end

end