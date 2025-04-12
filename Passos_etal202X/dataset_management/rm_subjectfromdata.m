% total_data = rm_subjectfromdata(total_data, leave_out)
%
% DESCRIPTION: Given a matrix with the goalkeeper_lab configuration, remove
% data from the subjects in the vector <leave_out>
%
% INPUT:
%
% total_data = matrix with the goalkeeper_lab configuration.
% leave_out = vector with the numbers of the subjects to remove from
% <total_data>.
%
% OUTPUT:
%
% total_data = matrix with the goalkeeper_lab configuration.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 09/04/2025

function total_data = rm_subjectfromdata(total_data, leave_out)

% PARAMETERS TO TEST THE FUNCTION
% leave_out = [10 42];

for a = 1:length(leave_out)
    aux_select = total_data(:,15) == leave_out(a);
    total_data( aux_select , : ) = [];
end

end
