% testing things

work_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X';
addpath(genpath(work_path))

load([work_path '/files_for_reference/num7possible_trees/num7possible_trees.mat'])

Ds = zeros(length(ptrees),1);
Ss = Ds;
[contexts, ~] = build_treePM ([work_path '/files_for_reference/num7.tree']);

for k = 1:length(ptrees)
  Ds(k,1) = balding_distance(contexts,ptrees{k,1});
  Ss(k,1) = get_rweight(ptrees{k,1}); 
end

% file_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X/files_for_reference/num7possible_trees/';
% file_name = 'num7variant3.png';
% [A,map] = imread([file_path file_name]);
% 
% 
% plot((1:10).^2)
% axes('pos',[.0 .0 .2 .4])
% imshow(A)