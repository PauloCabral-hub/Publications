% staircase_plot(chan_info, topo_mat, new_fig)
%
% DESCRIPTION: plots a topographical map of the head where boxes appear in
% the position of each channel. Inside each box, a number appears
% referenced to a tree. Each box in a given channel position indicates the
% tree retrieved for that block. Boxes at the bottom indicates the first
% block, and at the top, last block.
%
% INPUT:
%
% chan_inf = channel information structure in the form of EEGlab
% topo_mat = a matrix with the numbers referenced to the trees.
% Different lines indicates different channels. Difference collumns
% indicates different blocks.
% new_fig = if set to 1, creates a figure for the plot.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2024

function staircase_plot(chan_info, topo_mat, column, new_fig)

if new_fig == 1
   figure 
end

[channels, splash] = get_splash(chan_info);

hold on
for a = 1:length(channels)
    plot(splash(a,1),splash(a,2), 'o', 'color', [topo_mat(a,column)/max(topo_mat(:, column)) 0.5 0],...
        'MarkerSize',  25, 'LineWidth', 2);
    text(splash(a,1)-7,splash(a,2), num2str(topo_mat(a,column)), 'color', [topo_mat(a,column)/max(topo_mat(:, column)) 0.5 0]);
    text(splash(a,1)+15,splash(a,2)-5, chan_info(a).labels, 'color', [topo_mat(a,column)/max(topo_mat(:, column)) 0.5 0]);
end
axis square
axis off    
end

