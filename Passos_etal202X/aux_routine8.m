% Description: takes the EEG from the list of subjects, build the data
% matrices and save them in a sigle struct

% HEADINGS
ntrials = 1500;
tree_num = 7;

path_to_files = '/home/paulo/Documents/Publications/Passos_etal202X/data_files/';

subjects = [[4:13] 51];
group_data = {};

aux = 1;
for s = subjects
    if s < 10
       aux_num = ['0' num2str(s) ];
    else
       aux_num = num2str(s);
    end
    if s > 50
        correction = 0;
    else
        correction = 1;
    end
    fname = ['EEG_subj' aux_num '_clean.mat'];
    load ([path_to_files fname], 'EEG')
    [data, ~, ~, ~] = EEG_data_matrix(EEG, ntrials, EEG.srate, aux, tree_num, correction);
    if size(data,1) > ntrials
       disregard = size(data,1) - ntrials +1;
       data = data(disregard:end,:);
    end
    group_data{aux,1} = data; 
    aux = aux+1;    
end

save('/home/paulo/Documents/Publications/Passos_etal2023/data/data_1strun', 'group_data')