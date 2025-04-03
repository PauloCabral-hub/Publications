% Description: This routine is used for calculating the ERP from the
% from the subjects data
% 
% Comment 1: column 12 (D2), 13(D3) and 14(D4) indicates the arrow, begin-
% ning and end of the feed-
% back

%% Setting adresses
data_address = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\sim_data\working_matrix.mat';
eeglab_address = 'C:\Users\Cabral\Documents\pos_doc\eeglab_current\eeglab2024.2';
eeg_data_address = 'C:\Users\Cabral\Documents\pos_doc\Coleta\clean_data';
tree_file_address = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\files_for_reference\num7.tree';
    
%% Loading files and paths

list_files = dir(eeg_data_address);
load(data_address,'total_data')
addpath(genpath(eeglab_address))

%% Cleaning directories from the list of files

del_list = [];

for a = 1:length(list_files)
    if (list_files(a).isdir == 1) 
        del_list = [del_list a];
    end
    if (length( list_files(a).name ) > 3)&& isequal( list_files(a).name(end-2:end), 'fdt' )
       del_list = [del_list a];  
    end
end

list_files(del_list) = [];

%% Listing and eliminating subjects

leave_out = [10 42];

for a = 1:length(leave_out)
    aux_select = total_data(:,15) == leave_out(a);
    total_data( aux_select , : ) = [];
end

list_subjs = unique(total_data(:,15));  

%% Loading EEG and behavioral data

fs = 256;
repo = cell(length(list_subjs),2); 
aux_count = 1;
for a = 1:length(list_subjs)
   for b = 1:length(list_files)
      if isequal( str2num( list_files(b).name(end-11:end-10) ), list_subjs(a) )
         [EEG] = pop_loadset( list_files(b).name, list_files(b).folder );
         aux_select = total_data(:,15) == list_subjs(a);
         data = total_data( aux_select,: );
         data(:,10:14) = round( data(:,10:14) );
         fEEGsignals = filtEEGdata(EEG.data,fs,1,30, []);
         repo{a,1} = fEEGsignals;
         repo{a,2} = data;
         additional_info.name = EEG.filename;
         additional_info.orig_name = EEG.comments;
         additional_info.srate = EEG.srate;
         additional_info.chan_info = EEG.chanlocs;
         additional_info.colmap_num = [3,5,6,7,8,9,10,11,12,13,14,15]'; 
         additional_info.colmap_marker = {'trial_num';'tree';'alt_id';...
             'rtime';'keeper_choice';'taker_choice'; 'Gx_taker'; 'G1';...
             'D2_arrow';'D3_fbini'; 'D4_fbend'; 'file_id'}; 
         repo{a,3} = additional_info;
      end
   end 
end

%% Checking integrity of the data

corrupted = zeros( size(repo,1), 1);
for a = 1:size(repo,1)
   eeg_data = repo{a,1};
   bdata = repo{a,2};
   for b = 1:5
      column = bdata(:,9+b);
      for c = 1:length(column)
         if column(c) > size(eeg_data,2)
            corrupted(a) = 1;
         end
      end
   end
end

%% Calculating ERPs

srate = 256;
basel_len = round(srate/5);
ap_base = 1;
erps_repo = {};
cerps_repo = {};

% Subjects loop
for a = 1:size(repo,1)
   eeg_data = repo{a,1};
   bdata = repo{a,2};
   %new: line
   [bdata, contexts] = label_contexts(tree_file_address, bdata);
   %new: line
   % Channel loop
   for b = 1:size(eeg_data,1)
       eeg_sig = eeg_data(b,:);
       ump_tsig_repo = {};
       t_sig_len = zeros( size(bdata,1)-1, 1 );
       % new: line
       labels_track = zeros( size(bdata,1)-1, 1 );
       % new: line
       % Trial loop
       for c = 1:size(bdata,1)-1
           ump_tsig = eeg_sig( bdata(c,14): bdata(c+1,13) );
           t_sig_len(c) = length(ump_tsig);
           ump_tsig_repo{c,1} = ump_tsig; % unpadded and uncuted signal
           ump_tsig_repo{c,2} = eeg_sig( bdata(c,14) - basel_len:bdata(c,14)); % baseline
           labels_track(c) = bdata( c, size(bdata,2) );
       end
       flen = round( quantile(t_sig_len,0.75) ); 
       tsig_repo = zeros( length(ump_tsig_repo), flen );
       for c = 1:length(ump_tsig_repo)
           % zero padding
           if t_sig_len(c) < flen
              pzeros = zeros( 1, flen - t_sig_len(c) );
              tsig = [ ump_tsig_repo{c,1} pzeros ]; % zero pad right side
           else
              tsig = ump_tsig_repo{c,1};
              tsig = tsig(1:flen);
           end
           % Appling or not baseline
           if ap_base == 1
              tsig = tsig - mean(ump_tsig_repo{c,2});
           end
           tsig_repo(c,:) = tsig; % final signal
       end
       erps_repo{b,a} = mean(tsig_repo,1);
       for d = 1:length(contexts)
          selection = labels_track == d;
          erp_selection = tsig_repo(selection,:);
          cerps_repo{b,a,d} = mean(erp_selection,1);
       end
   end
end

%% Estimating the arrow latencies

ar_latencies = zeros( size(repo,1),1 );
for a = 1:size(repo,1)
    bdata = repo{a,2};
    subj_ar_latencies = [];
    for b = 1:size(bdata,1) -1
       lat = bdata(b+1,12) - bdata(b,14)+1;
       if lat > 0
            subj_ar_latencies = [subj_ar_latencies ; lat]; 
       end
    end
    ar_latencies(a) = mean(subj_ar_latencies);
end

ar_lat_estimate = round( mean(ar_latencies) );
%% Calculating the grand-average:

ERP_method = 0; % for the mean use (0) and for the median use (1);

gerps_repo = cell( size(erps_repo,1) , 3 );
min_size = 10^10;

for a = 1:size(erps_repo,1)
    for b = 1:size(erps_repo,2)
       if length(erps_repo{a,b}) < min_size
          min_size = length(erps_repo{a,b});
       end
    end
end

for a = 1:size(erps_repo,1)
    gerp = zeros(1,min_size);
    sig_erp_set = zeros( size( erps_repo, 2 ) , min_size );
    for b = 1:size(erps_repo,2)
        sig = erps_repo{a,b};
        sig = sig(1:min_size);
        erps_repo{a,b} = sig;
        sig_erp_set(b,:) = sig;
    end
    if ERP_method == 0
       gerp = mean(sig_erp_set,1);
    else
       gerp = median(sig_erp_set,1);
    end

    [sig_erp_ref, no_correction] = erp_benjyuke(sig_erp_set, 0.05);
    gerps_repo{a,1} = gerp;
    gerps_repo{a,2} = sig_erp_ref;
    gerps_repo{a,3} = sig_erp_set;
end

%% Calculating the grand-average per context:

gcerps_repo = cell( size(erps_repo,1) , 3, size(cerps_repo,3) );
% new:
for d = 1:size(cerps_repo,3)
    for a = 1:size(cerps_repo,1)
        gcerp = zeros(1,min_size);
        sig_cerp_set = zeros( size( erps_repo, 2 ) , min_size );
        for b = 1:size(cerps_repo,2)
            sig = cerps_repo{a,b,d};
            sig = sig(1:min_size);
            cerps_repo{a,b,d} = sig;
            sig_cerp_set(b,:) = sig;
        end
        if ERP_method == 0
           gcerp = mean(sig_cerp_set,1);
        else
           gcerp = median(sig_cerp_set,1);
        end

        [sig_cerp_ref, no_correction] = erp_benjyuke(sig_cerp_set, 0.05);
        gcerps_repo{a,1,d} = gcerp;
        gcerps_repo{a,2,d} = sig_cerp_ref;
        gcerps_repo{a,3,d} = sig_cerp_set;
    end     
end
% new:


%% Visualizing the data group data

% Settings
add = 0; % 0 for the first half electrodes, 16 for the other half 

fs = 256;

electrodes = {'Fp1', 'Fp2', 'F3', 'F4', 'F7', 'F8', 'Fz', 'FC1', 'FC2', ...
    'FC5', 'FC6', 'FT9', 'FT10', 'C3', 'C4', 'Cz', 'CP1', 'CP2', 'CP5','CP6', ... 
    'T7', 'T8', 'TP9', 'TP10', 'P3', 'P4', 'P7', 'P8', 'Pz', 'O1', 'O2', 'Oz'};

chan_info = repo{1,3}.chan_info;
emap = zeros( 1, length(electrodes) );

for a = 1:length(electrodes)
   achan = electrodes{1,a};
   for b = 1:length(chan_info)
      bchan = chan_info(b).labels;
      if isequal( achan, bchan )
         emap(1,a) = b; 
      end
   end
end

figure

for a = 1:16
   sig = gerps_repo{emap(a+add),1};
   test_res = gerps_repo{emap(a+add),2};
   lab = electrodes{1,a+add};
   t = [0:length(sig)-1]*(1/fs);
   subplot(4,4,a)
   yyaxis left
   hold on
   back_lines = gerps_repo{emap(a+add),3};
   for b = 1:size(back_lines,1)
       plot(t, back_lines(b,:) ,'-', 'Color', [0.75 0.75 0.75]);
   end
   ylim([-10 10])
   yyaxis right
   plot(t,sig,'-b','LineWidth',1.5)
   hold on
   plot(t(ar_lat_estimate)*ones(100,1),linspace(-2,2),'-k')
   h = gca;
   tres_sig = test_res;
   tres_nsig = test_res == 0;
   base_nsig = min(h.YLim); base_sig = max(h.YLim);
   tres_final = tres_sig.*base_sig + tres_nsig.*base_nsig;
   threshold = base_nsig;
   % Fill the area below the curve where the values are smaller than the threshold
   fill([t, fliplr(t)], [tres_final, min(tres_final)*ones(size(tres_final))], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
   xlim([0 0.7])
   ylim([-2 2]) % for presenting the in the same scale
   title(lab)
   xlabel('t(s)')
   ylabel('\muV')
end

%% Visualizing the data group data context-by-context

% Settings
add = 16; % 0 for the first half electrodes, 16 for the other half 

fs = 256;

electrodes = {'Fp1', 'Fp2', 'F3', 'F4', 'F7', 'F8', 'Fz', 'FC1', 'FC2', ...
    'FC5', 'FC6', 'FT9', 'FT10', 'C3', 'C4', 'Cz', 'CP1', 'CP2', 'CP5','CP6', ... 
    'T7', 'T8', 'TP9', 'TP10', 'P3', 'P4', 'P7', 'P8', 'Pz', 'O1', 'O2', 'Oz'};

chan_info = repo{1,3}.chan_info;
emap = zeros( 1, length(electrodes) );

for a = 1:length(electrodes)
   achan = electrodes{1,a};
   for b = 1:length(chan_info)
      bchan = chan_info(b).labels;
      if isequal( achan, bchan )
         emap(1,a) = b; 
      end
   end
end

figure

for a = 1:16
   subplot(4,4,a)
   colors = 'bgr';
   for b = 2:4
       sig = gcerps_repo{emap(a+add),1,b};
       test_res = gcerps_repo{emap(a+add),2,b};
       lab = electrodes{1,a+add};
       t = [0:length(sig)-1]*(1/fs);
       plot(t,sig,'-','Color', colors(b-1),'LineWidth',1.5)
       if b == 2
           hold on
       end
       plot(t,test_res*(1/(b*1.5))-2,'-', 'Color', colors(b-1))
   end
   plot(t(ar_lat_estimate)*ones(100,1),linspace(-2,2),'-k')
   h = gca;
   xlim([0 0.7])
   ylim([-2 2]) % for presenting the in the same scale
   title(lab)
   xlabel('t(s)')
   ylabel('\muV')
end

%% Visualizing single-subject data

% Setting the subject
subj = 1;
add = 0; % 0 for the first half electrodes, 16 for the other half 

figure

for a = 1:16
   sig = erps_repo{emap(a+add),subj};
   lab = electrodes{1,a+add};
   t = [0:length(sig)-1]*(1/fs);
   subplot(4,4,a)
   plot(t,sig,'-b','LineWidth',1.5)
   hold on 
   xlim([0 0.7])
   %ylim([-200 200]) % for presenting the in the same scale
   title(lab)
   xlabel('t(s)')
   ylabel('\muV')
end