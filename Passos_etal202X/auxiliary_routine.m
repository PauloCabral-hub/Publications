
% Apply the following after oppening the eeglab if eeg channel locations
% are missing
% !do not forger to load chan_loc_and_info.mat!

for a = 1:31
    ALLEEG.chanlocs(a) = chanlocs(a);
    EEG.chanlocs(a) = chanlocs(a);
end
ALLEEG.chaininfo = chaninfo;
EEG.chaininfo = chaninfo;

% Criteria for IClabel removing:
% Criteria: get only those in which brain classification is above 10%
IC_matrix = ALLEEG.etc.ic_classification.ICLabel.classifications;

maintain_comp = zeros(size(IC_matrix,1),1);
for a = 1:size(IC_matrix,1)
    if IC_matrix(a,1) > 0.10 
       maintain_comp(a) = 1;
    end
end

remove_com = find(maintain_comp == 0);