% gsummary_repo = load_est_trees(from, to, repo_path)
%
% DESCRIPTION: load a set of estimated trees in a variable.
%
% INPUT:
%
% from = from the subject (check repository);
% to = to the subject (check repository);
%
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2024

function gsummary_repo = load_est_trees(from, to, repo_path )

% Loading the estimated trees

for a = from:to
    if a > 9
       aux_str = 'subj';
    else
       aux_str = 'subj0';
    end
    file = [aux_str num2str(a) '_EEGtrees_block_and_global.mat'];
    load([repo_path file])
    % Correcting for empty data in the repository
    aux = 1;
    while aux < length(summary_repo)
        if isempty(summary_repo(aux).subj_num)
            summary_repo(aux) = [];
        end
        aux = aux+1;
    end
    
    eval(['summary_repo' num2str(a) '= summary_repo;'])
    if a == from 
        eval(['gsummary_repo = summary_repo' num2str(a) ';'])
    else
        eval(['gsummary_repo = [gsummary_repo ; summary_repo' num2str(a) '];'])
    end
end




end