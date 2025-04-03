% Date: 06/03/2024
%
% Description: This script plot all possible trees till size 5 in order of
% distance from the tree of the stimuli
%
% 1. Calculate the distance from the tree of stimuli
% 2. Plot the trees in ascending order of distance


close all
set(0,'defaultfigurecolor',[1 1 1])
work_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X';
addpath(genpath(work_path))

load([work_path '/files_for_reference/num7_possibletrees/num7_possibletrees.mat'])

Ds = zeros(length(ptrees),1);
Ss = Ds;
[contexts, ~] = build_treePM ([work_path '/files_for_reference/num7.tree']);

for k = 1:length(ptrees)
  Ds(k,1) = balding_distance(contexts,ptrees{k,1}); 
end
[~, Ds_asc] = sort(Ds);

figure
path_comp = '/files_for_reference/num7_possibletrees';
tree_xdim = 0.175; tree_ydim = 0.30;
y_pos = 0.75;
shift = 0.05;
for k = 0:length(ptrees)-1
   file_name = ['/num7variant' num2str(Ds_asc(k+1)) '.png'];
   tree_img = imread([work_path path_comp file_name]);
   delta_x = 0.01;
   aux = rem(k,5)+1;
   x_pos = shift + (aux-1)*(tree_xdim + delta_x);
   if (aux == 1) && (k ~=0)
      y_pos = y_pos - 0.25; 
   end
   axes('pos',[ x_pos y_pos tree_xdim tree_ydim ])
   imshow(tree_img)
   text(0,0.,num2str(k),'FontSize', 20,'Color', 'b')
end

