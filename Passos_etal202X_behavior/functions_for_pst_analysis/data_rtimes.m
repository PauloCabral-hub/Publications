% [datar] = data_rtimes(data);
%
% DESCRIPTION: This function receives the data matrix from the goalkeeper
% game and substitutes the response times by (r-r_min)/(r_max-r_min), where 
% indicates the response times
%
% INPUT:
% datar = data matrix from the goalkeeper game as used in
% Cabral-Passos(2024)
%
% OUTPUT:
% ranked_data = same data, however the response times were substituted by
% the relative response times.
%
% AUTHOR: Paulo Roberto Cabral Passos LAST MODIFICATION: 11/09/2024


function [datar] = data_rtimes(data)

datar = data;
num_of_subj = max(data(:,6));

    for a = 1:num_of_subj
        subj_lines = find(data(:,6) == a);
        x = data(subj_lines, 7);
        x_min = min(x);
        x_max = max(x);
        x = (x-x_min)/(x_max-x_min);
        datar(subj_lines,7) = x;
    end
end