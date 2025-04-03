% [] = writting_trees(origin_dir, output_dir, alphabet, label_leafs)
%
% DESCRIPTION: given the directory containing trees in the format
% <trees_volXX.mat>, writes the tex files with the tikz trees to the output
% directory.
%
% INPUT:
%
% origin_dir = folder containing the files trees_volXX.mat.
%
% OUTPUT:
%
% output_folder = destination of the files containing the .tex for the tikz
% trees with identified channels and trials.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 29/01/2025

function [] = writting_trees(origin_dir, output_dir, alphabet, label_leafs)

% Getting the filenames in the folder 

all_files = dir(origin_dir);

not_files = [];
for r = 1:length(all_files)
   if strcmp(all_files(r).name(1),'.')
      not_files = [not_files r];  %#ok<AGROW>
   end
end

all_files(not_files) = [];

% Loading and writting the tex files

for f = 1:length(all_files)
    load([origin_dir '\' all_files(f).name], 'summary_repo')

    for t = 1:length(summary_repo)
        string_seq = tikz_tree(summary_repo(t).tree, alphabet, label_leafs);
        vol_num = summary_repo(t).subj_num;
        if vol_num < 10
           vol_num = ['0' num2str(vol_num)];
        else
           vol_num = num2str(vol_num); 
        end
        name = [ 'tikz_vol' vol_num '_chan' summary_repo(t).chan '_from' num2str(summary_repo(t).from) '_to' num2str(summary_repo(t).to) ]; 
        standalone_tickztree(output_dir, string_seq, name)
    end
end

end