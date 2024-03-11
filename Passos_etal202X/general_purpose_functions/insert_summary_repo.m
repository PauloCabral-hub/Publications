% summary_repo = insert_summary_repo(summary_repo,...
%         subj_num, ch, chan, tau_est, from, to)
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


function summary_repo = insert_summary_repo(summary_repo,...
        subj_num, ch, chan, tau_est, from, to)
        new_page = struct;
        new_page.subj_num = subj_num;
        new_page.chan_num = ch;
        new_page.chan = chan;
        new_page.tree = tau_est;
        new_page.from = from;
        new_page.to = to;
        summary_repo = [summary_repo; new_page];
end