% Date: 11/03/2024
%
% Description: Pending

% Loading the estimated trees
file_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/data_repository_09032024/';
file = 'subj04_EEGtrees_block_and_global.mat';
load([file_path file])

% Correcting for empty data in the repository
if isempty(summary_repo(1).subj_num)
   summary_repo = summary_repo(2:length(summary_repo));
end
subj_num = summary_repo(1).subj_num;

% Getting the unique trees
unique_trees = {};
aux = 1;
for a = 1:length(summary_repo) 
    tree_var = summary_repo(a).tree;
    if isempty(unique_trees)
       unique_trees{aux} = tree_var;
       aux = aux+1;
    else
        checker = 1;
        for b = 1:length(unique_trees)
            if treesequal(tree_var,unique_trees{b})
                checker = 0;
            end
        end
        if checker == 1
           unique_trees{aux} = tree_var;
           aux = aux+1;            
        end
    end
end

% Calculating the distances for each tree (this must be done with all trees of all subjects)
file_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X/files_for_reference';
Dists = zeros(length(unique_trees),1);
[contexts, ~] = build_treePM ([file_path '/num7.tree']);

for a = 1:length(unique_trees)
  Dists(a,1) = balding_distance(contexts,unique_trees{a}); 
end
[~, Ds_asc] = sort(Dists);

% Getting the number in ascending order

for a=1:length(summary_repo)
    tree_var = summary_repo(a).tree;
    for b = 1:length(unique_trees)
        if treesequal(tree_var,unique_trees{b})
           summary_repo(a).tree_num = find(Ds_asc == b); 
        end
    end
end

% Getting unique channels

unique_channels = {};
aux = 1;
for a = 1:length(summary_repo) 
    chan_var = summary_repo(a).chan;
    if isempty(unique_channels)
       unique_channels{aux} = chan_var;
       aux = aux+1;
    else
        checker = 1;
        for b = 1:length(unique_channels)
            if isequal(chan_var,unique_channels{b})
                checker = 0;
            end
        end
        if checker == 1
           unique_channels{aux} = chan_var;
           aux = aux+1;            
        end
    end
end

% Getting the results

resume_subj = zeros(length(unique_channels),4);

for a = 1:length(unique_channels)
   chan_var = unique_channels{a};
   for b = 1:length(summary_repo)
      if isequal(chan_var, summary_repo(b).chan) 
         if (summary_repo(b).from == 1) && (summary_repo(b).to == 500)
             resume_subj(a,1) = summary_repo(b).tree_num;
         end
         if (summary_repo(b).from == 501) && (summary_repo(b).to == 1000)
             resume_subj(a,2) = summary_repo(b).tree_num;             
         end
         if (summary_repo(b).from == 1001) && (summary_repo(b).to == 1500)
             resume_subj(a,3) = summary_repo(b).tree_num;             
         end
         if (summary_repo(b).from == 1) && (summary_repo(b).to == 1500)
             resume_subj(a,4) = summary_repo(b).tree_num;             
         end         
      end
   end
end

% Plotting the results

aux_plot = 1;
subplot(1,4,aux_plot)
ChLabels = {};
for a = 0:size(resume_subj,1)-1
    aux = rem(a,8)+1;
    if (rem(a,8) == 0)&&(a ~= 0)
       aux_plot = aux_plot +1;
       h = gca;
       h.YTickLabel = ChLabels;
       h.XTickLabel = {};
       xlim([0 4])
       ChLabels = {};
       box off
       plot(3.5*ones(8,1),[1:8],'r','LineWidth',5) 
       subplot(1,4,aux_plot)
    end    
    ChLabels{aux} = unique_channels{a+1};
    plot([1:4],aux*ones(1,4),'-o','Color','k','MarkerSize',20,'MarkerFaceColor',[0.75 1 1]);
    for b = 1:4
       text(b-0.1,aux,num2str(resume_subj(a+1,b)),'FontSize',12)
    end
    hold on
end
h = gca;
h.YTickLabel = ChLabels;
h.XTickLabel = {};
xlim([0 4])
ChLabels = {};
box off
plot(3.5*ones(7,1),[1:7],'r','LineWidth',5) 
h2 = gcf;
set(h2,'Position',[675 688 1861 274])
saveas(h2,['/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X/estimations/subj_num'...
    num2str(subj_num) '_trails.png'])


