% [delta_topomat, rect_deltatopo] = get_deltatree(gsummary_repo, subj_num, chan_info_path, from, to)
%
% DESCRIPTION: return the delta of tree number for the subject identified
% by subj_num in gsummary_repo.
%
% INPUT:
%
% gsummary_repo = as returned by order_tree_distance
% subj_num = the number of the subject in the set of gsummary_repo
% chan_info_path = path to the structure with channel information comming
% from EEGlab
% from = indicates from which block the delta should start to be calculated
% to = indicates in which block the delta should stop being calculated.
%
% OUTPUT:
%
% delta_topomat = matrix in which the lines indicates different channels
% following the order of chan_info in chan_info_path and columns wich
% indicate the difference in the tree number from the block m to block m+1
% if the difference is positive, indicates that the tree number reduced.
% rect_deltatopo = matrix with zeros and ones with the same ordering as 
% delta_topomat. 1 indicates a reduction in tree number from block m to
% block m + 1
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 10/07/2024

function [delta_topomat, rect_deltatopo] = get_deltatree(gsummary_repo, subj_num, chan_info_path, from, to)

[topo_mat, ~ ] = get_topo_mat(gsummary_repo, subj_num, chan_info_path);
    
    delta_topomat = [];
    for a = (from+1):to
        delta_topomat = [delta_topomat, (topo_mat(:,a)-topo_mat(:,a-1))];
    end
    rect_deltatopo = delta_topomat >= 0;

end

