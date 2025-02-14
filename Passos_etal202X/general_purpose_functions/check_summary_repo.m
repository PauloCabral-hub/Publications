% is_new = check_summary_repo(summary_repo, subj_num, b_trial, e_trial)
%
% Description: PENDING
%
% INPUT:
% ...
%
% OUTPUT:
% ...
% 
% Author: Paulo Roberto Cabral Passos Date: 08/03/2024


function is_new = check_summary_repo(summary_repo, subj_num, b_trial, e_trial, ch)
    is_new = 1;
    for k = 1:length(summary_repo)
        if summary_repo(k).subj_num == subj_num
            if summary_repo(k).from == b_trial
                if summary_repo(k).to == e_trial
                    if summary_repo(k).chan_num == ch
                       is_new = 0; 
                    end
                end
            end
        end
    end
end