% corrupted = check_corruption(repo) 
%
% DESCRIPTION: given a repo from <pack_data>, perform a simple check of
% integrity to see if the eeg and behavioral data correspond.
%
% INPUT:
%
% repo = structure from <pack_data>
%
% OUTPUT:
%
% corrupted = column vector in which 1 indicates that the participant in that
% row has signs of data corruption 
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 09/04/2025

function corrupted = check_corruption(repo)
 
corrupted = zeros( size(repo,1), 1);
    for a = 1:size(repo,1)
       eeg_data = repo{a,1};
       bdata = repo{a,2};
       for b = 1:5
          column = bdata(:,9+b);
          for c = 1:length(column)
             if column(c) > size(eeg_data,2)
                    corrupted(a) = 1;
             end
          end
       end
    end

    if sum(corrupted) == 0
       disp('Data check: OK') 
    end
end