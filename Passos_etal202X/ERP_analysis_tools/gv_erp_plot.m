% [ ] = gv_erp_plot(gerp, ierp_easy_access, gerp_test_ref, electrodes,
% emap, shift, align_method, srate, vert_line,  xlimits, ylimits)
%
% DESCRIPTION: This function generates ERP (Event-Related Potential) 
% plots for the given data. It generates plots for 16 electrodes. The left
% y-axis indicates the amplitudes for the subject's ERPs and the right 
% y-axis indicates the amplitudes for the grand-average.
% The plot is aligned according to the specified method ('left' or 'right').
% which defines the time frame orientation. Additionally, the function 
% highlights areas where the test results are significant, using shading.
%
% INPUT:
%
% gerp             = Matrix containing the ERP signals(column) for each 
% electrode(row).
% ierp_easy_access  = Cell array containing in each row the individual erps
% for all subjects.
% gerp_test_ref    = Matrix following <gerp> arrangement with ones
% indicating the signicant amplitudes.
% electrodes       = Cell array of electrode names.
% emap             = Mapping array to reorder electrodes.
% shift            = Offset to align the data with the electrode positions.
% align_method     = String indicating alignment method ('left' or 'right').
% srate            = Sampling rate of the EEG data.
% vert_line  = indicates where (sample) to draw a vertical line on the 
% plots. Provide an empty vector if no line should be drawed
% xlimits    = vector with the limits for the xaxis
% ylimits    = vector with the limits for the yaxis;
%
% OUTPUT:
%
% The function does not return any output, but generates a series of ERP plots with labeled axes.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 12/04/2025

function [] = gv_erp_plot(gerp, ierp_easy_access, gerp_test_ref, electrodes, emap, shift, align_method, srate, vert_line, xlimits, ylimits)

    % Loop through each electrode to generate individual plots
    for a = 1:16
       sig = gerp(emap(a+shift),:);  % Signal for current electrode
       test_res = gerp_test_ref(emap(a+shift),:);  % Test reference for current electrode
       lab = electrodes{1,a+shift};  % Electrode label
       t = [0:length(sig)-1]*(1/srate);  % Time vector

       % Align time axis based on the specified method
       if isequal(align_method,'right')
           t = -t;
           t = sort(t);
       end

       % Create a subplot for each electrode
       subplot(4,4,a)
       yyaxis left
       ax = gca;  
       ax.YColor = [0.75 0.75 0.75];  % Set the left y-axis color to grey
       hold on

       % Plot background lines (e.g., previous trials or references)
       back_lines = ierp_easy_access{emap(a+shift),1};
       for b = 1:size(back_lines,1)
           plot(t, back_lines(b,:) ,'-', 'Color', [0.75 0.75 0.75]);
       end
       ylim([-10 10])

       % Plot the main ERP signal on the right y-axis
       yyaxis right
       ax = gca;  
       ax.YColor = 'b';  % Set the right y-axis color to blue
       plot(t,sig,'-b','LineWidth',1.5)
       hold on
       if ~isempty(vert_line)
          plot(t(vert_line)*ones(100,1),linspace(-2,2),'-k')  % Plot the estimated latency    
       end

       % Set plot limits and labels
       if isequal(align_method,'right')
          xlimits = -xlimits;
          sort(xlimits);
       else
          xlim(xlimits);   
       end
       ylim(ylimits)  % Keep the y-axis in the same scale for all plots

       % Generate the shaded area to represent areas under threshold
       h = gca;
       tres_sig = test_res;
       tres_nsig = test_res == 0;
       base_nsig = min(h.YLim); 
       base_sig = max(h.YLim);
       tres_final = tres_sig.*base_sig + tres_nsig.*base_nsig;
       threshold = base_nsig;

       % Fill the area below the curve where values are smaller than the threshold
       fill([t, fliplr(t)], [tres_final, min(tres_final)*ones(size(tres_final))], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
       title(lab)
       xlabel('t(s)')
       ylabel('\muV')
    end

end
