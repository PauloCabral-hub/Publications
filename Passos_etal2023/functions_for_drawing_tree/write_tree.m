% [string_seq, full_tree] = write_tree(node, full_tree, string_seq, alphabet, vtree)
%
% Returns the tikz structure that defines the drawing of a rooted andlabel-
% ed tree. Recursive Function.
%
% INPUT:
%
% node            = should be set to the empty vector []. Another  necessa-
%                 call are made recursively.
% full_tree       = full_vertice tree as defined in <<full_tree_with_verti-
%                 ces.m>>
% string_seq      = should be set to the empty vector []. Another  necessa-
%                 call are made recursively.
% alphabet        = row vector containing the symbols used in the tree.
% 
%
% OUTPUT:
%
% string_seq      = sequence of characters defining the tikz tree structure
% full_tree       = as defined in <full_tree> input.
%
% AUTHOR: Paulo Roberto Cabral Passos   MODIFIED: 03/08/2023

function [string_seq, full_tree] = write_tree(node, full_tree, string_seq, alphabet, vtree)

ispart = 0;
    if ~isempty(node)
        for k = 1:length(vtree)
            if isequal(node, vtree{1,k})
               ispart = 1;
               break;
            end
        end
    else
        ispart = 1;
    end
    

    if ispart == 1    
        node_add_pre = ' child{ [fill] circle (2pt) node (';
    else
        node_add_pre = ' child{ [fill, transparent, white] circle (2pt) node (';
    end
node_add_pos = ') {}';
node_close = '}';

if ~isempty(node)
    node_string = replace(num2str(node), ' ', ''); new_node_string = [];
    for k = 1:length(node_string)
        new_node_string = [new_node_string node_string(k) 'o']; %#ok<AGROW>
    end
    new_node_string = new_node_string(1:end-1);

    string_seq = [string_seq node_add_pre new_node_string node_add_pos];

    for e = 1:length(full_tree)
       if isequal(node, full_tree{1,e})
          aux_vec = zeros( 1, length(full_tree) );
          aux_vec(e) = 1;
          full_tree = full_tree( aux_vec == 0);
          break;
       end
    end    
end


for a = 1:length(alphabet)
    ch = [alphabet(a) node];
    aux = 1;
    while aux <= length(full_tree)
        if isequal(ch, full_tree{1,aux})
           node_aux = full_tree{1,aux};
           [string_seq, full_tree] = write_tree(node_aux, full_tree, string_seq, alphabet, vtree);
           break
        end
        aux = aux+1;
    end
end

if ~isempty(node)
    string_seq = [string_seq node_close];
end

end