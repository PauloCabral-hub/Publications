% summary_repo = new_summary_repo ()
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


function summary_repo = new_summary_repo()
    sumarry_repo = struct; %#ok<NASGU>
    summary_repo.subj_num = [];
    summary_repo.chan_num = [];
    summary_repo.chan = [];
    summary_repo.tree = [];
    summary_repo.from = [];
    summary_repo.to = [];  
end