% DESCRIPTION: This routine verifies linear correlations between distances
% obtained through response times and the effect seen in context 2


% Loading data
load('/home/paulo/Documents/Publications/Passos_etal202X_behavior/data/time_distance_trees.mat')
load('/home/paulo/Documents/Publications/Passos_etal202X_behavior/data/dif_mat')


vec_mean_dtimes = [];

for a = 1:size(dif_mat,1)
    vec_mean_dtimes = [vec_mean_dtimes; mean(dif_mat(a,:))]; 
end


x = vec_mean_dtimes';
y = dif_mat(:,1)';

[alfa, beta,r, tcrit, tcalc, p, D] = slinearwithpear(x, y, 0.05, 0);

scatter(x,y)

x_reg = linspace(min(x),max(x));
y_reg = alfa + beta*x_reg;

hold on

plot(x_reg,y_reg)