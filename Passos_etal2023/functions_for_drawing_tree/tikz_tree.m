% string_seq = tikz_tree(tree, alphabet, label_leafs, vertices, vcounts, null_count, classes, null_class)
%
% Returns ...
%
% INPUT:
% tree            = cell in which each column represents a different leaf.
% alphabet        = row vector containing in each column a different number
%                 that composes the leafs.
% label_leafs = if set to 1, presents the respective labels of each leaf
% 
%
% OUTPUT:
% example = description
%
% author: Paulo Roberto Cabral Passos   date: 03/08/2023

function string_seq = tikz_tree(tree, alphabet, label_leafs, vertices, vcounts, null_count, classes, null_class)

height = 0;
    for k = 1:length(tree)
        if length(tree{1,k}) > height
           height = length(tree{1,k}); 
        end
    end

node_set = {}; aux = 1;
    for h = 1:height
    set_elements = permwithrep(alphabet, h);
        for e = 1:size(set_elements,1)
        node_set{1,aux} = set_elements(e,:);  %#ok<AGROW>
        aux = aux + 1;
        end
    end

vtree = vertice_tree(alphabet, tree);    
[string_seq, ~] = write_tree([], node_set, [], alphabet, vtree);

% building the headings
headings = ['\begin{tikzpicture}[thick, scale=0.15]' newline ];
    for k = 1:height
       headings = [headings '\tikzstyle{level ' num2str(k) '}=[level distance=6cm, sibling distance=9cm]'  newline]; %#ok<AGROW>
    end
string_seq = [headings '\coordinate' newline string_seq ';' newline]; %#ok<*NASGU>

%labeling contexts
if label_leafs == 1
   for a = 1:length(tree)
      w_string = [];
      w = tree{1,a};
      if length(w) == 1
          w_string = num2str(w);
      else
          for b = 1:length(w)
              w_string = [w_string num2str(w(b)) 'o'];
          end
          w_string = w_string(1:end-1);
      end
      string_seq = [string_seq '\node [ below of=' w_string ' ]{' replace(num2str(w),' ', '') '};' newline]; %#ok<AGROW>
   end
end

ctype = {'green', 'yellow'};
%inserting vertices count
    if ~isempty(vertices)
       for a = 1:length(vertices)
          w_string = [];
          w = vertices{1,a};
          if length(w) == 1
              w_string = num2str(w);
          else
              for b = 1:length(w)
                  w_string = [w_string num2str(w(b)) 'o'];
              end
              w_string = w_string(1:end-1);
          end
          string_seq = [string_seq '\node [black, fill=' ctype{1,classes(a)} ', circle, yshift=-1.2cm, xshift=0cm, above of=' w_string ' ]{' num2str(vcounts(a)) '};' newline]; %#ok<AGROW>
       end
       string_seq = [string_seq '\node [black, fill=' ctype{1, null_class} ', circle, yshift=0cm, xshift=0cm, above of=2 ]{' num2str(null_count) '};' newline];
    end


% closing
string_seq = [string_seq '\end{tikzpicture}'];

end