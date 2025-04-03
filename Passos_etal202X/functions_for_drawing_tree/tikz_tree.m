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

% table for defining the tikz tree parameters

tikz_dpars = [7.5, 33.75; 6.25 11.25; 5 3.75; 3.75 1.25; 2.5 0.475];



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
       headings = [headings '\tikzstyle{level ' num2str(k) '}=[line width=4pt, level distance=' num2str(tikz_dpars(k,1),2) 'cm, sibling distance=' num2str(tikz_dpars(k,2),3)  'cm]'  newline]; %#ok<AGROW>
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
        %testing
            rlabel = replace(num2str(w),' ', '');
            shift = 0.75;
            if str2num(rlabel(1)) == 1
                shift = shift - 1*0.35;
            elseif str2num(rlabel(1)) == 2
                shift = shift - 2*0.35;
            end
        %testing
      string_seq = [string_seq '\node [ below of=' w_string ', yshift=' num2str(shift) 'cm, rotate=45, text=black ]{ \footnotesize{' rlabel '} };' newline]; %#ok<AGROW>
   end
end


% closing
string_seq = [string_seq '\end{tikzpicture}'];

end