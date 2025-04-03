% rate = success_rate(data, subj_num, from, to)
%
% DESCRIPTION: returns the success rate from a given subject from a data
% matrix following <EEG_data_matrix> quicksheet: 
%
% INPUT:
%
% data  = data matrix following <EEG_data_matrix>
% subj_num = indicates the subject number in the data matrix
% from = the leftmost trial to consider in the calculation
% to = indicates the rightmost trial to consider in the calculation
%
% OUTPUT:
%
% rate = success rate for the subject
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 05/02/2025

function rate = success_rate(data, subj_num, from, to)

total = max(data(:,3));
    if to > total
       disp('Warning: requested interval exceeds the number of trials')
       return
    end
    if isempty( find(data(:,6) == subj_num) ) 
       disp('Warning: provided data do not contain the subject') 
       return
    end

dat_from = find(data(:,6) == subj_num,1);
    if data(dat_from + to -1, 6) == subj_num
       dat_to = dat_from + to -1;
    else
       disp('Warning: subject without the requested number of trials')
       return
    end

interval_length = length( data(dat_from:dat_to,8) ); 
rate = sum( data(dat_from:dat_to,8) == data(dat_from:dat_to,9) );
rate = rate/(  interval_length );

end