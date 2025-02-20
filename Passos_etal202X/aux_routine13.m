% DESCRIPTION: 

% Adding paths for EEGlab scripts
eeglab_dir = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/eeglab2023/';
addpath(genpath(eeglab_dir));

% Getting the available volunteer files

file_list = dir('C:\Users\Cabral\Downloads\drive-download-20250212T141731Z-001');

% Removing directories from the file_list and fdts

rm_these = [];
for a = 1:length(file_list)
    if file_list(a).isdir == 1
       rm_these = [rm_these a]; 
    end
    if ( length(file_list(a).name) > 3 ) && strcmp( file_list(a).name(end-2:end), 'fdt')
       rm_these = [rm_these a]; 
    end
    
end
file_list(rm_these) = [];

% Creating the master matrix

ntrials = 1500;
tree_num = 7;
subj_nref = [];
data = [];

for s = 1:length(file_list)
    EEG = pop_loadset('filename',file_list(s).name,'filepath',file_list(s).folder);
    num_ref = file_list(s).name(end-11:end-10);
    subj_nref = [subj_nref; num_ref];
    if str2num(num_ref) > 40
        correction = 0;
    else
        correction = 1;
    end
    [new_data, channels, EEGtimes, EEGsignals] = EEG_data_matrix(EEG, ntrials, EEG.srate, s, tree_num, correction);
    data = [data; new_data];
end


blocks = [1 500; 501 1000; 1001 1500];

rate_dist = zeros( length(file_list), size(blocks,1) );

for b = 1:size(blocks,1)
   for s = 1:length(file_list)
       rate = success_rate(data, s, blocks(b,1), blocks(b,2) );
       rate_dist(s,b)= rate;
   end
end


boxplot(rate_dist)

