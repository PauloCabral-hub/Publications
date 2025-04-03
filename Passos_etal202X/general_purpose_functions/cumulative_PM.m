% cPM = cumulative_PM(PM)
%
% DESCRIPTION: Create a cumulative probability matrix from the provided
% probability matrix 
%
% INPUT:
%
% PM = Provided probability matrix in which each row is a different
% state (or context) and each column is the corresponding probability
% distribution
%
% OUTPUT:
%
% cPM = corresponding probability distribution matrix
%
% COMMENT: You will find example parameters in the body of the function
% that you can use as input to understand function functionality
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 24/02/2025

function cPM = cumulative_PM(PM)

% EXAMPLE PARAMETERS FOR TESTING THE FUNCTION
% PM = [0 1 0; 0 0.3 0.7];

cPM = zeros( size(PM,1), size(PM,2) );

    for a = 1:size(PM,1)
       cP = 0;
       for b = 1:size(PM,2)
           cP = cP + PM(a,b);
           cPM(a,b) = cP;
       end
    end
    
end