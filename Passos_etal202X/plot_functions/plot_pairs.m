% plot_pairs(summary_repo, electrodes, window_1st, centroid_method, pars_axis)
%
% DESCRIPTION: Plot pairs of the measures in summary_repo.
%
% INPUT:
%
% summary_repo = Structure containing the data to process
% electrodes = cell in which each column corresponds to a different
% electrode label.
% window_1st = vector with initial trials
% centroid_method = centroid method used for plotting (1) median, (0) mean
% pars_axis = correponds to [xlim ylim].
%
% OUTPUT:
%
% NO OUTPUT
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 17/04/2025

function plot_pairs(summary_repo, electrodes, window_1st, centroid_method, pars_axis)

color_window = 0: 1/length(window_1st): 1;

    for c = 1:length(window_1st)
       blk = window_1st(c);
        for a = 1:length(electrodes)
            chan = electrodes{1,a};
            x = []; y = [];
            for b = 1:length(summary_repo)
                if isequal(chan,summary_repo(b).chan)
                   if isequal( blk, summary_repo(b).from )
                      x = [ x summary_repo(b).suc_rate ];
                      y = [ y summary_repo(b).dist ];
                   end
                end
            end
            subplot(4,8,a)
            hold on
            if centroid_method == 1
               x_par = median(x); 
               y_par = median(y);
            else
               x_par = mean(x);
               y_par = mean(y);
            end
            scatter(x_par, y_par, 80, 'MarkerFaceColor', [0 color_window(c) 0], ...
              'MarkerEdgeColor', [0 0 0], 'MarkerFaceAlpha', 0.5);
            h = gca; lim_ax = linspace(h.YLim(1),h.YLim(2));        
            title(chan)
            xlabel('suc. rate')
            ylabel('d')
            xlim(pars_axis(1:2))
            ylim(pars_axis(3:4))
        end
    end

end