% [ar_lat_estimate] = est_arrow_latency(repo)
%
% DESCRIPTION: This function estimates the average arrow latency based on data from the given repository.
% It calculates the latency for each subject, computes the mean latency per subject, 
% and then calculates the overall average arrow latency for all subjects.
%
% INPUT:
%
% repo = A cell array where each row represents a subject's data. The second column contains
%        the data for each subject, with latency values stored in specific columns.
%
% OUTPUT:
%
% ar_lat_estimate = The rounded average of all subject latencies.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 12/04/2025

function [ar_lat_estimate] = est_arrow_latency(repo)

    % Initialize array for storing latencies for each subject
    ar_latencies = zeros( size(repo,1),1 );
    
    % Loop through each subject in the repo
    for a = 1:size(repo,1)
        bdata = repo{a,2};  % Extract the data for the current subject
        subj_ar_latencies = [];
        
        % Calculate latencies for each row in the subject's data
        for b = 1:size(bdata,1) -1
            lat = bdata(b+1,12) - bdata(b,14) + 1;
            if lat > 0
                subj_ar_latencies = [subj_ar_latencies ; lat]; 
            end
        end
        
        % Store the mean latency for the current subject
        ar_latencies(a) = mean(subj_ar_latencies);
    end

    % Calculate and round the overall average latency
    ar_lat_estimate = round(mean(ar_latencies));

end
