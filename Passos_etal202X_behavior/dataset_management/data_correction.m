% workwith_corrected = data_correction(workwith)
%
% The function corrects the events in ALLEEG structure according to
% previous used labels.
%
% INPUT:
% workwith = corresponds to ALLEEG.event struct
%
% OUTPUT:
% workwith_corrected = corresponds to the same structure after correction
%
% Author: Paulo Roberto Cabral Passos     Last modified = 17/10/2022


function workwith_corrected = data_correction(workwith)

workwith_corrected = workwith([]); % struct with the same format but empty

aux = 0; flag = 0;
    for a = 1:length(workwith)-1
        if workwith(a).code(1) == 'G' 
           aux = aux +1;
           workwith_corrected(aux) = workwith(a);
        end
        if workwith(a).code(1) == 'D'
              if workwith(a).latency == workwith(a+1).latency
                 flag = 1;
              else
                if flag == 1
                   aux = aux +1;
                   workwith_corrected(aux) = workwith(a);
                   workwith_corrected(aux).code = 'D3';
                   flag = 0;
                else
                   if (workwith(a).code(2) == '1')||(workwith(a).code(2) == '2')
                      aux = aux +1;
                      workwith_corrected(aux) = workwith(a);
                   else
                      aux = aux +1;
                      workwith_corrected(aux) = workwith(a);
                      workwith_corrected(aux).code = 'D4';      
                   end
                end
              end
        end
    end
    
for a = 1:length(workwith_corrected)

    if strcmp(workwith_corrected(a).code,'D1')
       workwith_corrected(a).code = 'D  1';
       workwith_corrected(a).type = workwith_corrected(a).code; 
    end
    if strcmp(workwith_corrected(a).code,'D2')
       workwith_corrected(a).code = 'D  2';
       workwith_corrected(a).type = workwith_corrected(a).code;
    end
    if strcmp(workwith_corrected(a).code,'D3')
       workwith_corrected(a).code = 'D  3'; 
       workwith_corrected(a).type = workwith_corrected(a).code;
    end
    if strcmp(workwith_corrected(a).code,'D4')
       workwith_corrected(a).code = 'D  4'; 
       workwith_corrected(a).type = workwith_corrected(a).code;
    end
    if strcmp(workwith_corrected(a).code,'G1')
       workwith_corrected(a).code = 'G  1';
       workwith_corrected(a).type = workwith_corrected(a).code;
    end
    if strcmp(workwith_corrected(a).code,'G2')
       workwith_corrected(a).code = 'G  2'; 
       workwith_corrected(a).type = workwith_corrected(a).code;
    end
    if strcmp(workwith_corrected(a).code,'G3')
       workwith_corrected(a).code = 'G  4';
       workwith_corrected(a).type = workwith_corrected(a).code;
    end
    if strcmp(workwith_corrected(a).code,'G4')
       workwith_corrected(a).code = 'G  8'; 
       workwith_corrected(a).type = workwith_corrected(a).code;
    end
end
   

end


