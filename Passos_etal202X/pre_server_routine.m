
% For USP data
for vol = 4:13
    if vol > 9
       aux = num2str(vol); 
    else
       aux = ['0' num2str(vol)];
    end    
    EEG.etc.eeglabvers = '2023.1'; % this tracks which version of EEGLAB is being used, you may ignore it
    EEG = pop_loadbv(['C:\Users\PauloCabral\Documents\pos-doc\code_and_data\data_eeg\usp_data_1st_run\vol' num2str(vol) '_files\'], ['PDPaulPassos1022_00' aux '.vhdr'], [], [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33]);
    EEG.setname=['PDPauloPassos_vol' aux];
    EEG=pop_chanedit(EEG, {'lookup','C:\\Users\\PauloCabral\\Documents\\pos-doc\\code_and_data\\eeglab2023\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc'},'append',33,'changefield',{34,'labels','Cz'},'lookup','C:\\Users\\PauloCabral\\Documents\\pos-doc\\code_and_data\\eeglab2023\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc','setref',{'1:35',ref});
    EEG = pop_reref( EEG, [],'refloc',struct('labels',{'Cz'},'type',{''},'theta',{177.4959},'radius',{0.029055},'X',{-9.167},'Y',{-0.4009},'Z',{100.244},'sph_theta',{-177.4959},'sph_phi',{84.77},'sph_radius',{100.6631},'urchan',{34},'ref',{'Cz'},'datachan',{0}));    
    EEG = pop_chanedit(EEG, 'append',33,'changefield',{34,'labels','Fz'},'lookup','C:\\Users\\PauloCabral\\Documents\\pos-doc\\code_and_data\\eeglab2023\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc','setref',{'1:35','Cz'}); 
    EEG.setname=['PDPauloPassos_vol' aux '_avg'];
    EEG = pop_eegfiltnew(EEG, 'locutoff',1,'channels',{'Fp1','Fz','F3','F7','FT9','FC5','FC1','C3','T7','TP9','CP5','CP1','Pz','P3','P7','O1','Oz','O2','P4','P8','TP10','CP6','CP2','C4','T8','FT10','FC6','FC2','F4','F8','Fp2','Cz'});
    EEG = pop_resample( EEG, 1024);
    EEG.setname=['PDPauloPassos_vol' aux '_avg_rs'];
    EEG = pop_saveset( EEG, 'filename',['PDPauloPassos_vol' aux '_pre_ica.set'],'filepath','C:\\Users\\PauloCabral\\Documents\\pos-doc\\code_and_data\\data_eeg\\usp_processed\\');
    clear all
end

% For UFRJ data (Fz)
for vol = 55:56
    if vol > 9
       aux = num2str(vol); 
    else
       aux = ['0' num2str(vol)];
    end    
    EEG.etc.eeglabvers = '2023.1'; % this tracks which version of EEGLAB is being used, you may ignore it
    path_to_data = ['C:\Users\PauloCabral\Documents\pos-doc\code_and_data\data_eeg\ufrj_data_1st_run\vol' num2str(vol-50) '_files\'];
    vol_id = ls(path_to_data);
    vol_id = vol_id(4,:);
    EEG = pop_loadbv(path_to_data, vol_id, [], [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33]);
    EEG.setname=['PDPauloPassos_vol' aux '_avg'];
    EEG=pop_chanedit(EEG, 'append',33,'changefield',{34,'labels','Fz'},'lookup','C:\\Users\\PauloCabral\\Documents\\pos-doc\\code_and_data\\eeglab2023\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc','setref',{'1:35','Fz'});
    EEG = pop_reref( EEG, [],'refloc',struct('labels',{'Fz'},'type',{''},'theta',{0.30571},'radius',{0.22978},'X',{58.512},'Y',{-0.3122},'Z',{66.462},'sph_theta',{-0.30571},'sph_phi',{48.6395},'sph_radius',{88.5491},'urchan',{34},'ref',{'Fz'},'datachan',{0}));
    EEG = pop_eegfiltnew(EEG, 'locutoff',1);
    EEG = pop_resample( EEG, 1024);
    EEG.setname=['PDPauloPassos_vol' aux '_avg_rs'];
    EEG = pop_saveset( EEG, 'filename',['PDPauloPassos_vol' aux '_pre_ica.set'],'filepath','C:\\Users\\PauloCabral\\Documents\\pos-doc\\code_and_data\\data_eeg\\usp_processed\\');
    clear all
end