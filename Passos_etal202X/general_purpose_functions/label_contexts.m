% [data, contexts] = label_contexts(tree_file_address, data)
%
% DESCRIPTION: The function returns the matrix data with an additional
% column which labels in each trial the corresponding context in the 
% tree described in the file <tree_file_adress>
%
% INPUT:
%
% tree_file_address = complete path for the .tree file
% data = a data matrix on the form of Goalkeeper Lab
%
% OUTPUT:
%
% data = the same input data with an added column with the indication of
% trial-by-trial context
% contexts = the contexts used for labeling
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 03/04/2025

function [data, contexts] = label_contexts(tree_file_address, data)


% Parameters for testing the function
%tree_file_address = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\files_for_reference\num7.tree';

[contexts, ~] = build_treePM (tree_file_address);
height = get_treelength(contexts);
new_col_index = size( data, 2) + 1;
new_col = zeros( size( data,1), 1 );

for a = 1:size(data,1)
    for c = 1:length(contexts)
       ctx = contexts{1,c};
       ctx_len = length(ctx);
       if (a - ctx_len + 1) > 0
          past = data(a-ctx_len+1:a,9)';
          if isequal(ctx,past)
             new_col(a,1) = c; 
          end
       end
    end
end

data(:,new_col_index) = new_col;

end