% DESCRIPTION: This routine is for calculating the distances between the
% penalty taker tree and the retrieved trees in the current experiment.


% Adding the necessary folders

path2add = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X';
addpath(genpath(path2add))

% Opening the list of files

list_files = dir('C:\Users\Cabral\Documents\pos_doc\Coleta\joint_trees_data');


% Cleaning directories from the list of files

del_dir = [];

for a = 1:length(list_files)
    if list_files(a).isdir == 1
        del_dir = [del_dir a];
    end
end

list_files(del_dir) = [];

% Opening the list of files and calculating the distances


clearvars final_repo

for a = 1:length(list_files)
load([list_files(a).folder '\' list_files(a).name], 'summary_repo');
    for b = 1:length(summary_repo)
       d = balding_distance( summary_repo(b).tree, {[0], [0 1], [1 1], [2 1], [2]} );
       summary_repo(b).bdist = d;
    end
    if ~exist('final_repo')
        final_repo = summary_repo;
    else
        final_repo = [final_repo; summary_repo];
    end
end

% Get the list of channels

electrodes = {'Fp1', 'Fp2', 'F3', 'F4', 'F7', 'F8', 'Fz', 'FC1', 'FC2', ...
    'FC5', 'FC6', 'FT9', 'FT10', 'C3', 'C4', 'Cz', 'CP1', 'CP2', 'CP5','CP6', ... 
    'T7', 'T8', 'TP9', 'TP10', 'P3', 'P4', 'P7', 'P8', 'Pz', 'O1', 'O2', 'Oz'};

block_id = [1 501 1001];
dat_vec_total = [];
for a = 1:length(electrodes)
   dat_vec = [];
   gru_vec = [];
   for b = 1:length(final_repo)
      if strcmp( final_repo(b).chan, electrodes(1,a) )
         for c = 1:length(block_id)
            if final_repo(b).from == block_id(c)
               dat_vec_total = [dat_vec_total final_repo(b).bdist]; 
               dat_vec = [ dat_vec final_repo(b).bdist ];
               gru_vec = [ gru_vec c ];
            end
         end
      end
   end
   subplot(4,8,a)
   boxplot(dat_vec,gru_vec)
   ylim([0 1])
   title(electrodes(a))
   axis square
end

for a = 1:length(final_repo)
   if (final_repo(a).bdist - 0.7035) < 0.001
       this_one = a;
       break;
   end
end