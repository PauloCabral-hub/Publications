% output_dif = smaller_udif(vec)
%
% DESCRIPTION: Given a vector, returns the smallest difference between the
% unique values of the vector
%
% INPUT:
%
% vec = row vector with the values
%
% OUTPUT:
%
% ouput_dif = smallest difference
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2025

function  output_dif = smaller_udif(vec)

uvec = unique(vec);

output_dif = max(uvec) - min(uvec);
    for a = 1:length(uvec)
        for b = 1:length(uvec)
           if abs(uvec(a) - uvec(b))> 0.001
              pair_dif = abs(uvec(a)-uvec(b));
              if pair_dif < output_dif
                 output_dif = pair_dif; 
              end
           end
        end
    end

end