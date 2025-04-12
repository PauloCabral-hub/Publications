% [electrodes, emap] = electrode_mapping(montage_name,montage_version)
%
% DESCRIPTION: Given <montage_name> and <montage_version> that indicates
% files within the folder 'montage_info', provides a mapping that allows to
% subplot signals in a given order.
%
% INPUT:
%
% montage_name = string in the form 'montage_eegXX' where XX indicates the
% number of electrodes and along montage_version indicates a '.arr' file.
% montage version = string in the form 'XX' where XX indicates a two digits
% that indicates an arrangement of electrodes. 
%
% OUTPUT:
%
% electrodes = cell row vector in which each column present a different
% channel name.
% emap = indicates in an EEG matrix of (row - electrode, column - samples)
% which order plots the electrodes according to the '.arr' arrangement.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 12/04/2025


function [electrodes, emap] = electrode_mapping(montage_folder, montage_name,montage_version)

% PARAMETERS FOR TESTING THE FUNCTION
% montage_folder = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\montage_info';
% montage_name = 'montage_eeg32';
% montage_version = '01';

fileID = fopen([montage_folder '\' montage_name '_arrangement' montage_version '.arr'], 'r'); % Replace with your file path if necessary

% Check if the file opened successfully
if fileID == -1
    error('Could not open the file.');
end

% Initialize an empty cell array to store the electrode names
electrodes = {};

% Read the file line by line
tline = fgetl(fileID);
while ischar(tline)
    % Store the electrode name in the cell array
    electrodes{end+1} = tline;
    
    % Get the next line
    tline = fgetl(fileID);
end

% Close the file
fclose(fileID);

% Loading montage info to map

load([montage_folder '\' montage_name '_chan_info' montage_version '.mat'],'chan_info')

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

end