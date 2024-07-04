% [topo_mat, topo_vec] = get_topo_mat(gsummary_repo, subj_num, chan_info_path)
%
% DESCRIPTION: returns a matrix for plotting using function staircase_plot.
%
% INPUT:
%
% gsummary_repo = as returned by order_tree_distance
% subj_num = the number of the subject in the set of gsummary_repo
% chan_info = structure as provided by EEGlab
%
% OUTPUT:
%
% topo_mat = matrix with tree numbers, rows corresponds to channels and
% columns correspond to blocks.
%
% topo_vec = same information of topo_mat, but in a linewise vector.
% chain_info_path = path to the file with channel configuration
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2024

function [topo_mat, chan_info] = get_topo_mat(gsummary_repo, subj_num, chan_info_path)

load([chan_info_path 'chan_info.mat'])

aux = length(chan_info);
while aux ~= 0
    if isempty(chan_info(aux).radius )
        chan_info(aux) = [];
    end
    aux = aux-1;
end


bnum = max([gsummary_repo.block]);
topo_mat = zeros(length(chan_info),bnum);


subj_rows = find([gsummary_repo.subj_num] == subj_num);
summary_repo = gsummary_repo(subj_rows);

for b = 1:bnum
   block_rows =  find([summary_repo.block] == b);
   block_summary = summary_repo(block_rows);
   for a = 1:length(block_summary)
      topo_mat(a,b) = block_summary(a).tree_num; 
   end
end

end