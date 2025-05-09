% [chan_and_val, min_v, max_v] = prep_scalp_maps(electrodes, window_1st, summary_repo)
%
% DESCRIPTION: Returns <chan_and_val> necessary for performing a scalp
% plot.
%
% INPUT:
%
% electrodes =  column cell vector with the name of each electrode in the
% data.
% window_1st = row vector that indicates in asceding order the initial
% trial of each window in <summary_repo>
% summary_repo = a structure with the following fields:
% 'subj_num','chan_num', 'chan','tree','from','to','dist'
%
% OUTPUT:
%
% chan_and_val = cell structure with the first column indicating the
% electrode and the next columns indicating the value for the window k-1,
% where k is the column index
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2025

function [chan_and_val, min_v, max_v] = prep_scalp_maps(electrodes, window_1st, summary_repo)

chan_and_val = electrodes';
for a = 1:length(chan_and_val)
   for b = 1:length(window_1st)
       chan_and_val{a,1+b} = 0;
   end
end

for a = 1:size(chan_and_val,1)
   for b = 1:size(summary_repo,1)
      if isequal(chan_and_val{a,1},summary_repo(b).chan)
         for c = 1:length(window_1st)
            if isequal(window_1st(c),summary_repo(b).from)
               chan_and_val{a,c+1} = chan_and_val{a,c+1} + summary_repo(b).dist;  
            end
         end
      end
   end
end

min_v = 1000;
max_v = -1*min_v;

for b = 1:length(window_1st)
    for a = 1:size(chan_and_val,1)
        if chan_and_val{a,b+1} < min_v
           min_v = chan_and_val{a,b+1};
        end
        if chan_and_val{a,b+1} > max_v
           max_v = chan_and_val{a,b+1};
        end
    end    
end

end