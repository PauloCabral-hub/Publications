% Graphic parameters

set(0,'defaultfigurecolor',[1 1 1])
set(0, 'defaultFigureRenderer', 'painters')

%% Loading prameters


repo_path = [pwd '/data_files/'];
path_to_rtree = [pwd '/files_for_reference/'];
from = 4;
to = 13;
rtree = 7;

% Loading data

gsummary_repo = load_est_trees(from, to, repo_path );

% Getting the the tree numbers

gsummary_repo = order_tree_distance(path_to_rtree,rtree, gsummary_repo);

%% Visualizing parameters

new_fig = 1;
chan_info_path = '/home/paulo/Documents/Publications/Passos_etal202X/data_files/';

% Getting the topomat
subjects = [from:to];
gtopo_mat = zeros(32,4,10);
for a = 1:length(subjects)
    subj_num = subjects(a);
    [topo_mat, chan_info] = get_topo_mat(gsummary_repo, subj_num, chan_info_path);
    gtopo_mat(:,:,a) = topo_mat;
end

mtopo_mat = zeros(31,4);
for a = 1:31
    for b = 1:4
       mtopo_mat(a,b) = round(  median( gtopo_mat(a,b,:) )  ); 
    end
end


% Plotting the topomat

staircase_plot(chan_info, topo_mat(:,1), new_fig)
