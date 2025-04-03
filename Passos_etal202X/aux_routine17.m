% DESCRIPTION: This routine is used for calculating the trees for the res-
% ponse times of the subjects and save them in the stored file.

% Adding the necessary folders

path2add = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X';
addpath(genpath(path2add))

% Opening the list of files

list_files = dir('C:\Users\Cabral\Documents\pos_doc\Coleta\joint_trees_data');

% insert 1
% Loading the master matrix
load([path2add '\sim_data\working_matrix' ],'total_data')
% insert 1

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

ds_vec = [];

blocks = [1 500; 501 1000; 1001 1500];

for a = 1:length(list_files)
    load([list_files(a).folder '\' list_files(a).name], 'summary_repo');
    subj_id = summary_repo(1).subj_num;
    idata = total_data( total_data(:,15) == subj_id, : );
    for b = 1:size(blocks,1)
        [realtau_est] = tauest_real(3, idata(blocks(b,1):blocks(b,2),7)', idata(blocks(b,1):blocks(b,2),9)' );
        for c = 1:length(summary_repo)
           if summary_repo(c).from == blocks(b,1)
              summary_repo(c).rtree = realtau_est; 
           end
        end
    end
    save([list_files(a).folder '\' list_files(a).name],'summary_repo')
end

