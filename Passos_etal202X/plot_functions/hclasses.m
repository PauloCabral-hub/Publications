% bin_edges = hclasses(vec)
%
% DESCRIPTION: Given a vector of values for a histogram, returns the edges
% of the histogram in such a way that different values will always be in
% different class intervals
%
% INPUT:
%
% vec = row vector with the values
%
% OUTPUT:
%
% bind_edges = class intervals to be used with histogram function
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2025

function  bin_edges = hclasses(vec)

smaller_dif = smaller_udif(vec);
uvec = unique(vec);


left_bed = min(uvec) - smaller_dif;
right_bed = max(uvec) - smaller_dif;

next_step = left_bed + smaller_dif;
bin_edges = [left_bed next_step];

    while next_step <= right_bed
       bin_edges = [ bin_edges next_step (next_step+smaller_dif) ]; %#ok<AGROW>
       next_step = bin_edges(end);
    end

end