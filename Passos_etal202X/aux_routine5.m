% Graphic parameters

set(0,'defaultfigurecolor',[1 1 1])
set(0, 'defaultFigureRenderer', 'painters')

%% Loading prameters


repo_path = [pwd '/data_files/'];
path_to_rtree = [pwd '/files_for_reference/'];
subjects = [[4:13] 51];
rtree = 7;

% Loading data

gsummary_repo = load_est_trees(subjects, repo_path );

% Getting the the tree numbers

gsummary_repo = order_tree_distance(path_to_rtree,rtree, gsummary_repo);
gtopo_mat = zeros(32,3,length(subjects));
for a = 1:length(subjects)
    subj_num = subjects(a);
    [topo_mat, chan_info] = get_topo_mat(gsummary_repo, subj_num, 3, chan_info_path);
    gtopo_mat(:,:,a) = topo_mat;
end
%% Visualizing parameters

new_fig = 1;
chan_info_path = '/home/paulo/Documents/Publications/Passos_etal202X/data_files/';

% Getting the the tree numbers

gsummary_repo = order_tree_distance(path_to_rtree,rtree, gsummary_repo);
gtopo_mat = zeros(32,3,length(subjects));
for a = 1:length(subjects)
    subj_num = subjects(a);
    [topo_mat, chan_info] = get_topo_mat(gsummary_repo, subj_num, 3, chan_info_path);
    gtopo_mat(:,:,a) = topo_mat;
end

% mtopo_mat = zeros(32,4);
% for a = 1:32
%     for b = 1:4
%        mtopo_mat(a,b) = round(  median( gtopo_mat(a,b,:) )  ); 
%     end
% end


% Plotting the topomat
big_delta = zeros(length(chan_info),2);
for a = subjects
    [delta_topomat, rect_deltatopo] = get_deltatree(gsummary_repo, a, chan_info_path, 1, 3);
    big_delta = big_delta + rect_deltatopo;
end

staircase_plot(chan_info, big_delta, 2, 1)
