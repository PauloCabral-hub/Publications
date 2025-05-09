% summary_repo = gather_vol_trees(folder_path, vol, digits)
%
% DESCRIPTION: Reads the files from containing the <summary_repo> of
% subject in a folder and returns it in a single-structure
%
% INPUT:
%
% folder_path = folder containing the files
% vol =  integer that idenfies the volunteer
% digits = number of digits in the string identification of the files.
%
% OUTPUT:
%
% summary_repo = concatenated summary_repos
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2025

function summary_repo = gather_vol_trees(folder_path, vol, digits)

%PARAMETERS FOR TESTING THE FUNCTION
% folder_path = 'C:\Users\Cabral\Documents\pos_doc\Coleta\tree_data';
% vol = 4;
% digits = 2;

% Reading

vol_str = num2str(vol);
    while length(vol_str) < digits
        vol_str = ['0' vol_str];     
    end

file_list = file_list_with_ext(folder_path,'.mat');

del_list = [];

    for a = 1:length(file_list)
        if ~contains(file_list{a}, ['vol' vol_str])
           del_list = [del_list a]; %#ok<*AGROW>
        end
    end

file_list(del_list) = [];


% Loading

    for a = 1:length(file_list)
    load([folder_path '\' file_list{a}], 'summary_repo')
        if ~exist('new_summary_repo','var')
            new_summary_repo = summary_repo; %#ok<NODEF>
        else
            new_summary_repo = [new_summary_repo; summary_repo];  %#ok<NODEF>
        end
    end

    
del_list = [];    
for a = 1:length(new_summary_repo)
    if isempty( new_summary_repo(a).subj_num )
       del_list = [del_list a];  
    end
end

new_summary_repo([del_list]) = [];

summary_repo = new_summary_repo;

end