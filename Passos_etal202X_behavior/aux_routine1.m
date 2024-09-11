% DESCRIPTION: Estimate the context trees from the participants data

% HEADINGS
alphal = 3;
tau = 7;
path_to_rtree = '/home/paulo/Documents/Publications/Passos_etal202X_behavior/files_for_reference';


% Loading data
load('/home/paulo/Documents/Publications/Passos_etal202X_behavior/data/data.mat')

% Estimating a context tree for each block

blocks = [1 500; 501 1000; 1001 1500];

subjects = [1:11]';

tree_repo = cell(length(subjects),size(blocks,1));
dist_repo = cell(length(subjects),size(blocks,1));

% Recap: remember that the inputs to tauest_real must be a row vectors

for s = 1:length(subjects)
   for b = 1:size(blocks,1)
      [chain, ~, real_chain] = get_seqandresp(data,tau, s, blocks(b,1), blocks(b,2) );
      tree_repo{s,b} = tauest_real(alphal, real_chain', chain');
   end
end

% Calculating the distances

vec_tree_repo = {};

aux = 1;
for a = 1:size(tree_repo,2)
   for b = 1:size(tree_repo,1)
       vec_tree_repo{aux,1} = tree_repo{b,a};
       aux = aux+1;
   end
end

dorder_tree_repo = order_distances(path_to_rtree, tau, vec_tree_repo);

new_dorder = zeros(size(tree_repo,1),size(tree_repo,2));

aux = 1;
for a = 1:size(tree_repo,2)
    for b = 1:size(tree_repo,1)
        new_dorder(b,a) = dorder_tree_repo(aux);
        aux = aux+1;
    end
end

dorder_tree_repo = new_dorder;

% Verifying decreasing distance

delta_mat = zeros(size(dorder_tree_repo,1), size(dorder_tree_repo,2) -1 );

for a = 1:(size(dorder_tree_repo,2)-1)
    delta_mat(:,a) = dorder_tree_repo(:,a+1)-dorder_tree_repo(:,a);
end
delta_mat = delta_mat > 0;


% Calculating the mode contest tree for each block

modes = cell(1,3);

for a = 1:size(tree_repo,2)
    tree_set = {};
    aux = 1;
   for b = 1:size(tree_repo,1)
       tree_set{1,aux} = tree_repo{b,a};
       aux = aux + 1;
   end
    [mode_tau] = taumode_est(alphal, tree_set, 5, 0);
    modes{1,a} = mode_tau;
end



