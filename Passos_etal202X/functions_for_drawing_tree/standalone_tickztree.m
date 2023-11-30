% [string_seq, full_tree] = write_tree(node, full_tree, string_seq, alphabet, vtree)
%
% ATTENTION: should run from Passos_etal2023 folder. 
%
% Returns the .tex file with the corresponding standalone tree figure
% generated from tikz package.
%
% AUTHOR: Paulo Roberto Cabral Passos   MODIFIED: 28/11/2023

function standalone_tickztree(save_pathway, string_seq, name)

print_seq = ['\documentclass[tikz, border = 5pt]{standalone} \begin{document}' string_seq ' \end{document}'];
fid = fopen([save_pathway '/' name '.tex'],'wt');
fprintf(fid, '%s', print_seq);
fclose(fid);

end