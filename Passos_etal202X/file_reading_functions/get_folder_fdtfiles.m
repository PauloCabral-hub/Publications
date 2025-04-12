% file_list = get_folder_fdtfiles(address)
%
% DESCRIPTION: given the folder adress, return the list of all files with
% extension .fdt 
%
% INPUT:
%
% address = folder address.
%
% OUTPUT:
%
% file_list = a structure with the file names.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 09/04/2025

function file_list = get_folder_fdtfiles(address)

% PARAMETERS FOR TESTING THE FUNCTION
% address = 'C:\Users\Cabral\Documents\pos_doc\Coleta\clean_data';

if ~isfolder(address)
   disp('Message: the adress does not corresponds to a folder.')
   file_list = -1;
   return
end

file_list = dir(address);

del_list = [];

for a = 1:length(file_list)
    if (file_list(a).isdir == 1) 
        del_list = [del_list a]; %#ok<AGROW>
    end
    if (length( file_list(a).name ) > 3) 
       if ~isequal( file_list(a).name(end-2:end), 'set' )
          del_list = [del_list a];   %#ok<AGROW>
       end       
    end
end

file_list(del_list) = [];

file_list = rmfield(file_list,{'folder','date','bytes','isdir','datenum'});


end
