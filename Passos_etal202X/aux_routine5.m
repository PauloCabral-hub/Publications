% Graphic parameters

set(0,'defaultfigurecolor',[1 1 1])
set(0, 'defaultFigureRenderer', 'painters')

%% Loading prameters


repo_path = 'C:\Users\PauloCabral\Documents\pos-doc\code_and_data\Publications\Passos_etal202X\estimations/';
path_to_rtree = 'C:\Users\PauloCabral\Documents\pos-doc\code_and_data\Publications\Passos_etal202X\files_for_reference\';
from = 4;
to = 13;
rtree = 7;

% Loading data

gsummary_repo = load_est_trees(from, to, repo_path );

% Getting the the tree numbers

gsummary_repo = order_tree_distance(path_to_rtree,rtree, gsummary_repo);

%% Visualizing parameters
%subj_num = 13;
new_fig = 1;
chan_info_path = 'C:\Users\PauloCabral\Documents\pos-doc\code_and_data\Publications\Passos_etal202X\dataset_for_testing\';

% Getting the topomat

gtopo_mat = zeros(31,4,10);
for a = 1:10
    subj_num = 3+a;
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

staircase_plot(chan_info, topo_mat(:,3), new_fig)
subplot(1,2,1)
plot(p,logit)
title('$ln \frac{p}{1-p} $','Interpreter','Latex','FontSize',15)
subplot(1,2,2)
plot(logit,p)
title('Inversa','FontSize',15)