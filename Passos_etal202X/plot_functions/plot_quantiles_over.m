% [ ] = plot_quantiles_over(repo, pcts, only_bellow)
%
% DESCRIPTION: This function adds quantile text annotations over existing data in a 4x4 grid of subplots.
% The quantiles are calculated from the data in the <repo> from <pack_data>, and the annotations are added
% on top of the already plotted data.
%
% INPUT:
%
% repo = A cell array where each row represents a subject's data, with the second column containing data
%        from which quantiles will be extracted (the 7th column of each subject's data).
% pcts = A vector of percentiles (in decimal format, e.g., [0.25, 0.5, 0.75]) for which the quantiles
%        will be calculated and displayed in the subplots.
% only_bellow = remove values bellow this before quantile calculation 
%
% OUTPUT:
%
% The function does not return any output but adds quantile text annotations to the existing figure.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 12/04/2025

function [] = plot_quantiles_over(repo, pcts, only_bellow)

    % Extract the rts values from the repo data
    rts = [];
    for a = 1:size(repo,1) % subjects
       bdata = repo{a,2};
       rts = [rts; bdata(:,7)];
    end
    rts = rts(rts < only_bellow,1);

    % Calculate quantiles for the given percentiles
    vpcts = zeros(1,length(pcts));
    for a = 1:length(pcts)
        vpcts(a) = quantile(rts,pcts(a));
    end
    vpcts = -vpcts;  % Invert the quantiles to match the data direction
    vpcts = sort(vpcts);

    % Loop through each subplot and add the text annotations
    for a = 1:16
        subplot(4,4,a)
        
        % Calculate YLim and plot range for the current subplot
        h = gca;
        r = h.YLim(2) - h.YLim(1);

        % Add quantile text annotations to the subplot (do not overwrite the plot)
        for b = 1:length(vpcts)
            h_t = text(1 - vpcts(b),  h.YLim(1) + r*pcts(b), num2str( pcts(b),2 ) );
            set(h_t,'Rotation', 90) 
            set(h_t,'Color',[1, 0, 0, 0.3])  % Red color with transparency
            set(h_t,'FontSize',8)
        end
    end
end

