% standalone_tickztree(string_seq, name)
%
% ATTENTION: should run from Passos_etal2023 folder. 
%
% Returns the .tex file with the corresponding standalone tree figure
% generated from tikz package.
%
% AUTHOR: Paulo Roberto Cabral Passos   MODIFIED: 04/08/2023

function standalone_tickztree(string_seq, name)

print_seq = ['\documentclass[tikz, border = 5pt]{standalone} \begin{document}' string_seq ' \end{document}'];
fid = fopen([pwd '/functions_for_drawing_tree/figures/' name '.tex'],'wt');
fprintf(fid, '%s', print_seq);
fclose(fid);

end