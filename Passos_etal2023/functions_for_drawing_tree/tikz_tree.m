% string_seq = tikz_tree(tree, alphabet, label_leafs)
%
% Returns the tikz tree code sequence for drawing <tree> using Latex. 
%
% INPUT:
%
% tree         = cell in which each column represents a different leaf.
% alphabet     = row vector containing in each column  a  different  number
%              that composes the leafs.
% label_leafs  = insert leaf label if set to 1.
% 
%
% OUTPUT:
%
% string_seq   = code sequence to generate tree drawing using tikz package.
%
% AUTHOR: Paulo Roberto Cabral Passos   MODIFIED: 04/08/2023

function string_seq = tikz_tree(tree, alphabet, label_leafs)

height = 0;
    for k = 1:length(tree)
        if length(tree{1,k}) > height
           height = length(tree{1,k}); 
        end
    end

full_tree = full_tree_with_vertices(alphabet, height);


% building the body
[~, ~, vtree] = build_verticetree(alphabet, tree);
[string_seq, ~] = write_tree([], full_tree, [], alphabet, vtree);

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
              w_string = [w_string num2str(w(b)) 'o']; %#ok<AGROW>
          end
          w_string = w_string(1:end-1);
      end
      string_seq = [string_seq '\node [ below of=' w_string ', yshift=0.75cm ]{' replace(num2str(w),' ', '') '};' newline]; %#ok<AGROW>
   end
end


% closing
string_seq = [string_seq '\end{tikzpicture}'];

end