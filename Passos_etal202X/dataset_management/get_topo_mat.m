% [topo_mat, topo_vec] = get_topo_mat(gsummary_repo, subj_num, chan_desc_path)
%
% DESCRIPTION: returns a matrix for plotting using function staircase_plot.
%
% INPUT:
%
% gsummary_repo = as returned by order_tree_distance
% subj_num = the number of the subject in the set of gsummary_repo
% chan_desc = structure as provided by EEGlab
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

function [topo_mat, chan_desc] = get_topo_mat(gsummary_repo, subj_num, chan_desc_path)

load([chan_desc_path '/chan_description.mat'])

aux = length(chan_desc);
while aux ~= 0
    if isempty(chan_desc(aux).radius )
        chan_desc(aux) = [];
    end
    aux = aux-1;
end


bnum = max([gsummary_repo.block]);
topo_mat = zeros(length(chan_desc),bnum);


subj_rows = find([gsummary_repo.subj_num] == subj_num);
summary_repo = gsummary_repo(subj_rows); %#ok<FNDSB>

for b = 1:bnum
   block_rows =  find([summary_repo.block] == b);
   block_summary = summary_repo(block_rows); %#ok<FNDSB>
   for a = 1:length(block_summary)
      topo_mat(a,b) = block_summary(a).tree_num; 
   end
end

end