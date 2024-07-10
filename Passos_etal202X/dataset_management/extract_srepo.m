% summary_repo = extract_srepo(gsummary_repo, subj_num)
%
% DESCRIPTION: Extracts the summary_repo from the gsummary_repo struct
%
% INPUT:
%
% gsummary_repo = struct containing information about trees estimated for
% each channel and block of the experiment
%
% OUTPUT:
%
% summary_repo = struct containing the information just for the subject
% identified by subj_num
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 10/07/2024

function summary_repo = extract_srepo(gsummary_repo, subj_num)

% preambule


summary_repo.subj_num = [];
summary_repo.chan_num = [];
summary_repo.chan = [];
summary_repo.tree = [];
summary_repo.tree_num = [];
summary_repo.block = [];

aux = 1;
for a = 1:size(gsummary_repo,1)
   if gsummary_repo(a).subj_num == subj_num
        summary_repo(aux).subj_num = gsummary_repo(a).subj_num;
        summary_repo(aux).chan_num = gsummary_repo(a).chan_num;
        summary_repo(aux).chan = gsummary_repo(a).chan;
        summary_repo(aux).tree = gsummary_repo(a).tree;
        summary_repo(aux).tree_num = gsummary_repo(a).tree_num;
        summary_repo(aux).block = gsummary_repo(a).block;
        aux = aux+1;
   end
end

end