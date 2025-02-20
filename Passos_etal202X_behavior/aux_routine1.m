% DESCRIPTION: Estimate the context trees and modes from the participants 
% data for each block

% HEADINGS
disp('Setting parameters...')
alphal = 3;
rtree = 7;
path_to_rtree = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X_behavior\files_for_reference';

% Loading the data matrix with behavioral information from all participants
data = jdata;

% Estimating a context tree for each block

blocks = [1 500; 501 1000; 1001 1500];

subjects = [1:26]';

tree_repo = cell(length(subjects),size(blocks,1));
dist_repo = cell(length(subjects),size(blocks,1));

% Recap: remember that the inputs to tauest_real must be a row vectors

disp('Estimating the context trees of the participants')
for s = 1:length(subjects)
   for b = 1:size(blocks,1)
      [chain, ~, real_chain] = get_seqandresp(data,rtree,s,blocks(b,1), blocks(b,2));
      tree_repo{s,b} = tauest_real(alphal, real_chain', chain');
   end
   disp(['Done with ' num2str(s/length(subjects)) ' of the subjects'])
end
disp('Context tree estimations done')

% Calculating the mode contest tree for each block

modes = cell(1,3);
mode_counts = cell(1,3);
alphal = 3;
from_height = 5;

disp('Estimating the mode context trees of the participants')
for a = 1:size(tree_repo,2)
    disp([ 'mode ' num2str(a) ' of ' num2str( size(tree_repo, 2) ) ]);
    tree_set = {};
    aux = 1;
   for b = 1:size(tree_repo,1)
       tree_set{1,aux} = tree_repo{b,a}; %#ok<SAGROW>
       aux = aux + 1;
   end
    [tau_mode, count_vec] = taumode_est(alphal, tree_set, from_height);
    modes{1,a} = tau_mode;
    mode_counts{1,a} = count_vec;
end

disp('Context tree estimations done')

% Writing the tex files with the tree diagram

for a = 1:length(modes)
cur_tree = modes{1,a};
string_seq = tikz_tree(cur_tree, [0 1 2], 1, 1);
standalone_tickztree('C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X_behavior\tex_output', string_seq, ['mode_tree_B' num2str(a) '.tex']);
end



