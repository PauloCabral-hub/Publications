% plot_pairs_dwindow(summary_repo, electrodes, window_1st, centroid_method, pars_axis)
%
% DESCRIPTION: Plot pairs of the measures in summary_repo disregarding 
% window information
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

function plot_pairs_dwindow(summary_repo, electrodes, window_1st, centroid_method, pars_axis)

centroid_repo = cell(length(electrodes), 2);
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
            hold on
            if centroid_method == 1
               x_par = median(x); 
               y_par = median(y);
            else
               x_par = mean(x);
               y_par = mean(y);
            end
            centroid_repo{a,1} = [centroid_repo{a,1}; x_par];
            centroid_repo{a,2} = [centroid_repo{a,2}; y_par];
        end
    end
    
    for a = 1:length(electrodes)
       subplot(4,8,a)
       x = centroid_repo{a,2};
       y = centroid_repo{a,1};
       scatter( x, y, 4, 'b','filled');
       hold on
       %title(electrodes{1,a})
       ylabel('suc. rate')
       xlabel('d')
       
       % Graphing a line
       [alfa, beta,r, ~, ~, p, ~] = slinear_with_pear(x',y', 0.05, 0); %#ok<ASGLU>
       
       % Optimizing axis for visualization
       x_range = max(x)-min(x);
       y_range = max(y)-min(y);
       x_b = min(x) - 0.05*x_range; y_b = min(y) - 0.05*y_range;
       x_e = max(x) + 0.05*x_range; y_e = max(y) + 0.05*y_range;
       xf = linspace(x_b,x_e);
       fx = alfa + beta*xf; 
       plot(xf, fx, 'r', 'LineWidth', 2)
       title([ electrodes{1,a} ' r = ' num2str(r,'%.2f') ] )
       xlim([x_b x_e])
       ylim([y_b y_e])
    end

end