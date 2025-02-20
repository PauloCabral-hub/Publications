% DESCRIPTION: This routine verifies linear correlations between distances
% obtained through response times and choices.

% Loading data
load('/home/paulo/Documents/Publications/Passos_etal202X_behavior/data/time_distance_trees.mat')
load('/home/paulo/Documents/Publications/Passos_etal202X_behavior/data/choice_distance_trees.mat')

vec_distchoices = [];
vec_disttimes = [];
for a = 1:size(dorder_tree_repo,1)
   for b = 1:size(dorder_tree_repo,2)
       vec_distchoices = [vec_distchoices; cdorder_tree_repo(a,b) ];
       vec_disttimes = [vec_disttimes; dorder_tree_repo(a,b) ];
   end
end

x = vec_distchoices';
y = vec_disttimes';

[alfa, beta,r, tcrit, tcalc, p, D] = slinearwithpear(vec_distchoices', vec_disttimes', 0.05, 0);

scatter(x,y)

x_reg = linspace(min(x),max(x));
y_reg = alfa + beta*x_reg;

hold on

plot(x_reg,y_reg)