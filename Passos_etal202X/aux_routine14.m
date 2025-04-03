% DESCRIPTION: This routine is for calculating the distances between the
% penalty taker tree and the retrieved trees in the current experiment.
close all

% Adding the necessary folders

path2add = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X';
addpath(genpath(path2add))

% Opening the list of files

list_files = dir('C:\Users\Cabral\Documents\pos_doc\Coleta\joint_trees_data');

% Cleaning directories from the list of files

del_dir = [];

for a = 1:length(list_files)
    if list_files(a).isdir == 1
        del_dir = [del_dir a];
    end
end

list_files(del_dir) = [];

% Opening the list of files and calculating the distances

clearvars final_repo

ds_vec = [];

% Choose which distance you are going to use
d_chosen = 3;
med_or_mean = 2;

for a = 1:length(list_files)
load([list_files(a).folder '\' list_files(a).name], 'summary_repo');
    for b = 1:length(summary_repo)
       if d_chosen == 1
         d = balding_distance( summary_repo(b).tree, {[0], [0 1], [1 1], [2 1], [2]} );
         rd = balding_distance( summary_repo(b).rtree, {[0], [0 1], [1 1], [2 1], [2]} );
       elseif d_chosen == 2
         d = balding_distancefull( summary_repo(b).tree, {[0], [0 1], [1 1], [2 1], [2]} );
         rd = balding_distancefull( summary_repo(b).rtree, {[0], [0 1], [1 1], [2 1], [2]} );     
       else
         d = duartes_index([0 1 2], summary_repo(b).tree);
         rd = duartes_index([0 1 2], summary_repo(b).rtree);
       end
       summary_repo(b).dist = d;
       summary_repo(b).rdist = rd;
       ds_vec = [ds_vec d];
    end
    if ~exist('final_repo')
        final_repo = summary_repo;
    else
        final_repo = [final_repo; summary_repo];
    end
end

% Getting the unique distances for the class of intervals

uds = unique(ds_vec);

smaller_dif = 10^10;
for a = 1:length(uds)
    for b = 1:length(uds)
       if abs(uds(a) - uds(b))> 0.001
          pair_dif = abs(uds(a)-uds(b));
          if pair_dif < smaller_dif
             smaller_dif = pair_dif; 
          end
       end
    end
end

left_bed = min(uds) - smaller_dif;
right_bed = max(uds) - smaller_dif;

next_step = left_bed + smaller_dif;
bin_edges = [left_bed next_step];

while next_step <= right_bed
   bin_edges = [ bin_edges next_step (next_step+smaller_dif) ]; %#ok<AGROW>
   next_step = bin_edges(end);
end

% Removing Participants with problems

leave_out = [10 42];
mark_del = [];
for a = 1:length(final_repo)
    subj_num = final_repo(a).subj_num;
    for b = 1:length(leave_out)
       if isequal( subj_num,leave_out(b) ) 
          mark_del = [mark_del a];
          break;
       end
    end
end

final_repo(mark_del) = [];


% Get the list of channels

electrodes = {'Fp1', 'Fp2', 'F3', 'F4', 'F7', 'F8', 'Fz', 'FC1', 'FC2', ...
    'FC5', 'FC6', 'FT9', 'FT10', 'C3', 'C4', 'Cz', 'CP1', 'CP2', 'CP5','CP6', ... 
    'T7', 'T8', 'TP9', 'TP10', 'P3', 'P4', 'P7', 'P8', 'Pz', 'O1', 'O2', 'Oz'};


max_d = max(ds_vec);
min_d = min(ds_vec);
prange =  [ (min_d - (max_d - min_d)*0.10) (max_d + (max_d - min_d)*0.10) ];

block_id = [1 501 1001];
dat_vec_total = [];

% Creating the histograms

color_str = 'bgr';

figure
for a = 1:length(electrodes)
   dat_vec = [];
   gru_vec = [];
   for b = 1:length(final_repo)
      if strcmp( final_repo(b).chan, electrodes(1,a) )
         for c = 1:length(block_id)
            if final_repo(b).from == block_id(c)
               dat_vec_total = [dat_vec_total final_repo(b).dist]; 
               dat_vec = [ dat_vec final_repo(b).dist ];
               gru_vec = [ gru_vec c ];
            end
         end
      end
   end
   subplot(4,8,a)
   hold on
   for b = 1:length(block_id)
        histogram( dat_vec(gru_vec == b) ,25, 'DisplayStyle', 'stairs', 'EdgeColor', color_str(b),'LineWidth', 1.5, 'BinEdges', bin_edges)     
   end
   %sbox_varsize(gru_vec', dat_vec',  'block', 'd', '', {'';'';''}, 0.05, 0, [])
   ylim([0 12])
   xlim([left_bed right_bed])
   title(electrodes(a))
   axis square
end

% Creating the scalp representations

chan_and_val = electrodes';
for a = 1:length(chan_and_val)
   chan_and_val{a,2} = 0;
   chan_and_val{a,3} = 0;
   chan_and_val{a,4} = 0;
end

for a = 1:size(chan_and_val,1)
   for b = 1:size(final_repo,1)
      if isequal(chan_and_val{a,1},final_repo(b).chan)
         for c = 1:length(block_id)
            if isequal(block_id(c),final_repo(b).from)
               chan_and_val{a,c+1} = chan_and_val{a,c+1} + final_repo(b).dist;  
            end
         end
      end
   end
end

min_v = 1000;
max_v = -1*min_v;

for b = 1:length(block_id)
    for a = 1:size(chan_and_val,1)
        if chan_and_val{a,b+1} < min_v
           min_v = chan_and_val{a,b+1};
        end
        if chan_and_val{a,b+1} > max_v
           max_v = chan_and_val{a,b+1};
        end
    end    
end

% Ploting scalp maps

assets_adress = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\assets';

figure
for a = 1:length(block_id)
    subplot(1,length(block_id),a)
    scalp_heatmap(assets_adress, max_v, min_v - 1, chan_and_val(:,[1 (a+1)]) , 1)
end


% Success Rate / Electrode plots


load('C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\sim_data\working_matrix.mat');
load('C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\sim_data\pdfs.mat');

% Finding the limiar to classify subjects as maximizers

lim_max = zeros(1,length(block_id));
for b = 1:length(block_id)
    F_max = densitd{4,b};
    xi = densitd{1,b};
    for a = 1:length(F_max)
       if F_max(a) > 0.05
          lim_max(b) = xi(a);
          break;
       end
    end
end


% Filling repository with the success rates

for a = 1:length(final_repo)
   subj_num = final_repo(a).subj_num;
   frow = find(total_data(:,15) == subj_num,1);
   alt_id = total_data(frow, 6);
   final_repo(a).suc_rate = success_rate(total_data, alt_id, final_repo(a).from, final_repo(a).to );
end

% producing the pairs with success rate

figure

color_block = 'bgr';
for c = 1:length(block_id)
   blk = block_id(c);
    for a = 1:length(electrodes)
        chan = electrodes{1,a};
        x = [];
        y = [];
        for b = 1:length(final_repo)
            if isequal(chan,final_repo(b).chan)
               if isequal( blk, final_repo(b).from )
                  x = [ x final_repo(b).suc_rate ];
                  y = [ y final_repo(b).dist ];
               end
            end
        end
        subplot(4,8,a)
        plot(x,y,'.', 'MarkerSize',4,'MarkerEdgeColor',color_block(c))
        hold on
        if d_chosen == 2
           ylim([0 2])
        else
           ylim([-2 2])
        end
        if med_or_mean == 1
           x_par = median(x);
           y_par = median(y);
        else
           x_par = mean(x);
           y_par = mean(y);            
        end
        plot(x_par,y_par,'o', 'MarkerSize',6,'MarkerFaceColor',color_block(c))
        h = gca; lim_ax = linspace(h.YLim(1),h.YLim(2));        
        plot(lim_max(c)*ones( length(lim_ax), 1 ),lim_ax, 'Color', color_block(c))
        title(chan)
        xlabel('suc. rate')
        ylabel('d')
        xlim([0 1])
    end
end

% producing the pairs with distance from response times

figure

color_block = 'bgr';
for c = 1:length(block_id)
   blk = block_id(c);
    for a = 1:length(electrodes)
        chan = electrodes{1,a};
        x = [];
        y = [];
        for b = 1:length(final_repo)
            if isequal(chan,final_repo(b).chan)
               if isequal( blk, final_repo(b).from )
                  x = [ x final_repo(b).rdist ];
                  y = [ y final_repo(b).dist ];
               end
            end
        end
        subplot(4,8,a)
        plot(x,y,'.', 'MarkerSize',4,'MarkerEdgeColor',color_block(c))
        hold on
        if d_chosen == 2
           ylim([0 2])
        else
           ylim([-2 2])
        end
        if med_or_mean == 1
           x_par = median(x);
           y_par = median(y);
        else
           x_par = mean(x);
           y_par = mean(y);            
        end
        plot(x_par,y_par,'o', 'MarkerSize',6,'MarkerFaceColor',color_block(c))
        title(chan)
        xlabel('d(r.times)')
        ylabel('d(EEG)')
    end
end
