% gsummary_repo = load_est_trees(subjects, repo_path)
%
% DESCRIPTION: load a set of estimated trees in a variable.
%
% INPUT:
%
% subjects = a vector with the numbers of the subjects;
%
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2024

function gsummary_repo = load_est_trees(subjects, repo_path )

% Loading the estimated trees

for a = 1:length(subjects)
    subj = subjects(a);
    if subj > 9
       aux_str = 'subj';
    else
       aux_str = 'subj0';
    end
    file = [aux_str num2str(subj) '_EEGtrees_block_and_global.mat'];
    load([repo_path file])
    
    % Correcting for empty data in the repository
    aux = 1;
    while aux < length(summary_repo)
        if isempty(summary_repo(aux).subj_num)
            summary_repo(aux) = [];
        end
        aux = aux+1;
    end
    
    eval(['summary_repo' num2str(subj) '= summary_repo;'])
    if a == 1 
        eval(['gsummary_repo = summary_repo' num2str(subj) ';'])
    else
        eval(['gsummary_repo = [gsummary_repo ; summary_repo' num2str(subj) '];'])
    end
end




end