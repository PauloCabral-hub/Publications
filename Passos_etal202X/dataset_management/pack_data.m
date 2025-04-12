% repo = pack_data(total_data, file_list, data_address, eeg_lab_address, low_cutoff, high_cutoff)
%
% DESCRIPTION: This function provides a single cell structure in which the
% the first column presents the subject's filtered* EEG signal, the second 
% presents the subject's corresponding goalkeeper game data, and the third
% and final column presents subjects data additional information.
%
% INPUT:
%
% total_data = subjects data following goalkeeper_lab format
% data_address = folder address containing the .fdt files associated with 
% total_data.
% eeg_lab_address** = eeglab folder address.
% low_cutoff = low frequency cutoff to be applied with a high-pass filter.
% high_cutoff = high frequency cutoff to be applied with a low-pass filter.
%
% OUTPUT:
%
% repo = cell structure described in the function description
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 09/04/2025
%
% *The filter used is a zero-phase butterworth filter of 4th order.
% ** This function make use of eeglab package. It was tested with Matlab
% 2018a and eeglab 2024 version. Its functioning is not guaranteed with
% other matlab and eeeglab versions.

function repo = pack_data(total_data, file_list, data_address, eeglab_address, low_cutoff, high_cutoff)

% PARAMETERS FOR TESTING THE FUNCTION
% data_address = 'C:\Users\Cabral\Documents\pos_doc\Coleta\clean_data';
% eeglab_address = 'C:\Users\Cabral\Documents\pos_doc\AuxiliaryPackages\eeglab2025.0.0';
% low_cutoff = 1;
% high_cutoff = 30;

addpath( genpath(eeglab_address) )

subjs_list = unique(total_data(:,15));  

repo = cell(length(subjs_list),2); 
aux_count = 1;
    for a = 1:length(subjs_list)
       for b = 1:length(file_list)
          if isequal( str2num( file_list(b).name(end-11:end-10) ), subjs_list(a) )
             [EEG] = pop_loadset( file_list(b).name, data_address); % file_list(b).folder );
             aux_select = total_data(:,15) == subjs_list(a);
             data = total_data( aux_select,: );
             data(:,10:14) = round( data(:,10:14) );
             fEEGsignals = filtEEGdata(EEG.data,EEG.srate,low_cutoff,high_cutoff, []);
             repo{a,1} = fEEGsignals;
             repo{a,2} = data;
             additional_info.name = EEG.filename;
             additional_info.orig_name = EEG.comments;
             additional_info.srate = EEG.srate;
             additional_info.chan_info = EEG.chanlocs;
             additional_info.low_cutoff = low_cutoff;
             additional_info.high_cutoff = high_cutoff;
             additional_info.colmap_num = [3,5,6,7,8,9,10,11,12,13,14,15]'; 
             additional_info.colmap_marker = {'trial_num';'tree';'alt_id';...
                 'rtime';'keeper_choice';'taker_choice'; 'Gx_taker'; 'G1';...
                 'D2_arrow';'D3_fbini'; 'D4_fbend'; 'file_id'}; 
             repo{a,3} = additional_info;
          end
       end

    end

end