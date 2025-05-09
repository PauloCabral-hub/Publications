% file_list = file_list_with_ext(folder_path, ext)
%
% DESCRIPTION: Reads the files from a folder and returns only those with
% the informed extension <ext>
%
% INPUT:
%
% folder_path = folder containing the files
% ext = file extension (include the dot) 
%
% OUTPUT:
%
% file_list = cell structure with a file in each row
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2025

function file_list = file_list_with_ext(folder_path, ext)

% PARAMETERS FOR TESTING THE FUNCTION
% folder_path = 'C:\Users\Cabral\Documents\pos_doc\Coleta\clean_data';
% ext = '.fdt';

if ~isfolder(folder_path)
   disp('Message: the adress does not corresponds to a folder.')
   file_list = -1;
   return
end

file_list = dir(folder_path);

del_list = [];

for a = 1:length(file_list)
    if (length( file_list(a).name ) > length(ext) ) 
       if ~isequal( file_list(a).name(end-length(ext)+1:end), ext )
          del_list = [del_list a];   %#ok<AGROW>
       end
    else
        del_list = [del_list a]; %#ok<AGROW>
    end
end

file_list(del_list) = [];

new_file_list = cell( length(file_list) , 1 );
for a = 1:length(file_list)
   new_file_list{a,1} = file_list(a).name;
end
file_list = new_file_list;

end