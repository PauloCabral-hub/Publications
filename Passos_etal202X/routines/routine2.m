% DESCRIPTION: This routine is for calculating the distances between the
% penalty taker tree and the retrieved trees in the current experiment.
close all

%% Setting paths

working_folder = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X';
folder_path = 'C:\Users\Cabral\Documents\pos_doc\Coleta\windowed_data';
montage_folder = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\montage_info';
montage_name = 'montage_eeg32';
montage_version = '01';
assets_adress = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\assets';
gkg_matrix_file = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\sim_data\working_matrix.mat';

%% Loading path and reading files

% Loading paths
addpath(genpath(working_folder))

% Reading files
file_list = file_list_with_ext(folder_path, '.mat');

% Loading the goalkeeper matrix
load(gkg_matrix_file)
%% Opening all files

% Define the sample of subjects
subjs_sample = [[4:13] [41:58]];

% Define which subjects to leave out of the analysis
leave_out = [10 42];

% Clean data
clea_dat = 1;

del_list = [];
for a = 1:length(subjs_sample)
   for b = 1:length(leave_out)
      if isequal( subjs_sample(a), leave_out(b) )
         del_list = [del_list a]; %#ok<AGROW>
      end
   end
end

subjs_sample(del_list) = [];

clearvars summary_repo
for a = 1:length(subjs_sample)
    if ~exist('summary_repo','var')
       summary_repo = gather_vol_trees(folder_path, subjs_sample(a), 2);
    else
       new = gather_vol_trees(folder_path, subjs_sample(a), 2);
       summary_repo = [summary_repo ; new]; %#ok<AGROW>
    end
end
%% Cleaning data (time consuming, consider saving and loading the output)

summary_repo = remove_summary_repetitions(summary_repo);

% LOAD OUTPUT:
% load('C:\Users\Cabral\Documents\pos_doc\Coleta\summary_repo_file1.mat')


%% Calculating the distances

% Choosing the distance
d_chosen = 1;

% Choosing the penalty taker's tree
takers_tree = {0, [0 1], [1 1], [2 1], 2};

ds_vec = zeros( length(summary_repo), 1);
for a = 1:length(summary_repo)
   if d_chosen == 1
      d = balding_distancefull( summary_repo(a).tree, takers_tree);
   elseif d_chosen == 2
      d = duartes_index([0 1 2], summary_repo(a).tree);
   end
   summary_repo(a).dist = d;
   ds_vec(a) = d;
end

%% Getting the histogram parameters

bin_edges = hclasses(ds_vec);

%% Getting parameters data parameters for plotting

[electrodes, ~] = electrode_mapping(montage_folder, montage_name,montage_version);

window_1st = []; 
for a = 1:length(summary_repo)
   if isempty(window_1st)
      window_1st = summary_repo(a).from; 
   else
      window_1st = [ window_1st summary_repo(a).from ]; %#ok<AGROW>
   end
end
window_1st = sort( unique(window_1st) );

dat_vec_total = [];

%% Creating the histograms
% Comment: This code supports only three different histograms at a time,
% and 32 electrodes for now

color_str = 'bgr';

% Choosing which window to begin 
wb = 23;

figure
for a = 1:length(electrodes)
   dat_vec = zeros(2,length(summary_repo)); aux = 1;   
   for b = 1:length(summary_repo)
      if strcmp( summary_repo(b).chan, electrodes(1,a) )
         for c = wb:wb+2
            if summary_repo(b).from == window_1st(c) 
               dat_vec(1,aux) = summary_repo(b).dist; 
               dat_vec(2,aux) = c; aux = aux + 1;
            end
         end
      end
   end
   dat_vec = dat_vec(:,1:aux-1);
   
   subplot(4,8,a)
   hold on
   aux = 1;
   for b = wb:wb+2
        histogram( dat_vec(1, dat_vec(2,:) == b ), ...
            'DisplayStyle', 'stairs', 'EdgeColor', color_str(aux), ...
            'LineWidth', 1.5, 'BinEdges', bin_edges) 
        aux = aux+1;
   end
   
   lxlim = min(bin_edges) - ( max(bin_edges) - min(bin_edges) )*0.05;
   rxlim = max(bin_edges) + ( max(bin_edges) - min(bin_edges) )*0.05;
   xlim([lxlim rxlim]); title(electrodes(a)); axis square; ylim([0 26]);
   xlabel(['wb = ' num2str(window_1st(wb))])
end


%% Creating the scalp representations

[chan_and_val, min_v, max_v] = prep_scalp_maps(electrodes, window_1st, summary_repo);

% Setting parameters for subploting
rows = 2;
columns = 3;
shift = 0;

% Ploting scalp maps

figure
for a = 1:rows*columns
    subplot(rows,columns,a)
    scalp_heatmap(assets_adress, max_v, min_v - 1, chan_and_val(:,[1 (a+1+shift)]) , d_chosen-1)
    title(['wind=' num2str(window_1st(a+shift))])
end


%% Calculating the Success Rate 

for a = 1:length(summary_repo)
   subj_num = summary_repo(a).subj_num;
   frow = find(total_data(:,15) == subj_num,1);
   alt_id = total_data(frow, 6);
   summary_repo(a).suc_rate = success_rate(total_data, alt_id, summary_repo(a).from, summary_repo(a).to );
end

%% Calculating the Response time trees (REALLY time consuming, consider saving and loading the output)

window_len = 300;

for a = 1:length(subjs_sample)
   disp(['Calculating the response time trees ...' num2str(a/length(subjs_sample)) ])
   subj = subjs_sample(a);
   for w = 1:length(window_1st)
      b = window_1st(w);
      e = b + window_len -1;
      data = total_data( total_data(:,15) == subj ,:);
      rtree = tauest_real(3, data(b:e,7)', data(b:e,9)');
      for c = 1:length(summary_repo)
         if isequal( summary_repo(c).subj_num, subj)...
             && isequal( summary_repo(c).from, b )
         summary_repo(c).rtree = rtree;
         end
      end
   end
end

% LOAD OUTPUT:
load('C:\Users\Cabral\Documents\pos_doc\Coleta\summary_repo_file2b.mat')

%% Ploting pairs Success Rate and Distance 

figure
centroid_method = 1;
dofdata = 1;
if dofdata == 1
    par_axis = [0 2 0 1];  
else
    par_axis = [-2 2 0 1 ];
end

plot_pairs_dwindow(summary_repo, electrodes, window_1st, centroid_method, par_axis)
% plot_pairs(summary_repo, electrodes, window_1st, centroid_method,[0 1 0 2])

