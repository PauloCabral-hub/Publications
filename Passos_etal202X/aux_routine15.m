% Description: Generates the the empirical distribution of maximizers and
% emulators for a given tree

seq_len = 500;
dist_size = 5000;
tree_adress = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\files_for_reference\num7.tree';

max_results = zeros(dist_size,1);
emu_results = zeros(dist_size,1);


for a = 1:dist_size
   % maximizers
   [base_seq,fol_seq] = sim_rmod_resp(tree_adress,seq_len, 1); 
   max_results(a,1) = sum( base_seq == fol_seq )/seq_len;
   % emulators
   [base_seq,fol_seq] = sim_rmod_resp(tree_adress,seq_len, 0); 
   emu_results(a,1) = sum( base_seq == fol_seq )/seq_len;
end

load('C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\sim_data\legal_score.mat','big_score_ls')


figure

block_num = 3;

densitd = cell(3,block_num);

for b = 1: block_num
    
ls_lim = 0.6;
subplot(2,3, b)
step_size = 0.002;
histogram(max_results - (1 - median(big_score_ls(:,b))), 25, 'FaceColor', 'b', 'Normalization','probability')
hold on
histogram(emu_results - (1 - median(big_score_ls(:,b))), 25, 'FaceColor', 'r', 'Normalization','probability')
xlim([ls_lim 1])
xlabel('s')
ylabel('$\hat{P}_{emp}(S = s)$','Interpreter','latex')

subplot(2,3, b + 3)
[f_max,xi] = ksdensity(max_results - (1 - median(big_score_ls(:,b))),[0:step_size:1]);
f_max = f_max/trapz(f_max);
plot(xi, f_max,'Color','b')
hold on
[f_emu,xi] = ksdensity(emu_results - (1 - median(big_score_ls(:,b))),[0:step_size:1]);
f_emu = f_emu/trapz(f_emu);
xlabel('s')
ylabel('$\hat{P}_{ker}(S = s)$','Interpreter','latex')
plot(xi, f_emu,'Color','r')
xlim([ls_lim 1])

densitd{1,b} = xi;
densitd{2,b} = f_emu;
densitd{3,b} = f_max;
end

% Calculating the CDF for maximizers

for b = 1:block_num
    F_max = zeros(1,length(densitd{3,b}));
    for a = 1:length(densitd{3,b})
        F_max(1,a) = trapz(densitd{3,b}(1,1:a));
    end
    densitd{4,b} = F_max;
end


figure
for b = 1:block_num
    subplot(block_num,1,b)
    plot(xi,densitd{4,2})
end