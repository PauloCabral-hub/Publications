% sbox_varsize(group_id, data,  x_name, y_name, tit, box_names, sig_dif, test, acsis)
%
% DESCRIPTION: draw a boxplot identifierwise. Also use komolgorov-smirnov test to verify
% differences between the distributions. If there are diferences between
% the distributions it shows a horizontal bar connecting the two
% distributions.
%
% INPUT:
% group_id = vecotor identifying which sample is from which data
% data = the data vector
% x_name = to name the xlabel
% y_name = to name the ylabel
% tit = to name the title
% box_names = cell structure to name the Ticks
% sig_dif = adjust for betther appearence of the significance identifier
% test = set 1 to test the distributions
% acsis = change axis to the corresponding vector
%
% Author: Paulo Roberto Cabral Passos
% Last Modified: 07/08/2020
% Checked:

function sbox_varsize(group_id, data,  x_name, y_name, tit, box_names, sig_dif, test, acsis)

set(0,'defaultfigurecolor',[1 1 1])
set(0, 'DefaultFigureRenderer', 'painters');

auxdata = []; auxgroup = [];
groups = max(group_id);
for a = 1:groups
   auxd = data(find(group_id == a),1);
   auxd = auxd(find(isoutlier(auxd) == 0),1); %DISABLED FOR MATLAB2015
   %VERSION
   auxdata = [auxdata; auxd];
   auxgroup = [auxgroup; a*ones(length(auxd),1)];
end

%figure('units','normalized','outerposition',[0 0 1 1])

lw = 2;
for a = 1:max(auxgroup)
    hold on
    % Drawing the quartils
    q1 = prctile(auxdata( find(auxgroup == a) ),25); %#ok<FNDSB>
    q3 = prctile(auxdata( find(auxgroup == a) ),75); %#ok<FNDSB>
    x = linspace(a - 0.265,a + 0.265); %x = linspace(a - 0.25,a + 0.25);
    y1 = q1*ones(1,length(x)); %y1 = q1*ones(1,length(x));
    y2 = q3*ones(1,length(x)); %y2 = q3*ones(1,length(x));
    plot(x,y1,'k','LineWidth',4)
    plot(x,y2,'k','LineWidth',4)
    w = linspace(q1,q3);
    x1 = (a-0.25)*ones(1,length(w));
    x2 = (a+0.25)*ones(1,length(w));
    plot(x1,w, 'k','LineWidth',4)
    plot(x2,w, 'k','LineWidth',4)
    % Drawing the Median
    y3 = prctile(auxdata( find(auxgroup == a) ),50)*ones(1,length(x)); %#ok<FNDSB>
    plot(x,y3, 'r','LineWidth',4)
    % Drawing upper whisker
    y = linspace(prctile(auxdata( find(auxgroup == a) ),75),max(auxdata( find(auxgroup == a) ))); %#ok<FNDSB>
    x = a*ones(1,length(y));
    plot(x,y, 'k','LineWidth',4)
    x = linspace(a - 0.125,a + 0.125);
    y = max(auxdata( find(auxgroup == a) ))*ones(1,length(x)); %#ok<FNDSB>
    plot(x,y, 'k','LineWidth',4)
    % Drawing lower whisker
    y = linspace(prctile(auxdata( find(auxgroup == a) ),25),min(auxdata( find(auxgroup == a) ))); %#ok<FNDSB>
    x = a*ones(1,length(y));
    plot(x,y, 'k','LineWidth',4)
    x = linspace(a - 0.125,a + 0.125);
    y = min(auxdata( find(auxgroup == a) ))*ones(1,length(x)); %#ok<FNDSB>
    plot(x,y, 'k','LineWidth',4)
    plot((a + 0.025*randn(1,length(find(group_id == a)))), data( find(group_id == a) ), 'ob', 'MarkerSize', 10, 'MarkerFaceColor', 'b') %#ok<FNDSB>
end

if test ==1
    compare = combnk(1:max(group_id),2);
    results = size(compare,1);

    for a = 1:size(compare,1)
       results(a) = kstest2( data( find(group_id == compare(a,1)) ), data( find(group_id == compare(a,2)) )  ,'Alpha',0.05);
    end

    n_bars = sum(results);

    border =  max(data)+sig_dif;
    for a = 1:length(results)
       if results(a) == 1
          x = linspace(compare(a,1),compare(a,2));
          y = border*ones(1,length(x));
          plot(x,y,'k','LineWidth',2)
          y = linspace(border-sig_dif/2, border);
          x = compare(a,1)*ones(1,length(y));
          plot(x,y,'k','LineWidth',2)
          x = compare(a,2)*ones(1,length(y));
          plot(x,y,'k','LineWidth',2)
          border = border + sig_dif;
       end
    end
end
ax = gca;
ax.XTick = 1:max(group_id);

% DISABLED FOR MATLAB 2015 VERSION
for t = 1:length(ax.XTick)
    ax.XTickLabel{t,1} = box_names{t,1};
end

xlabel(x_name, 'FontSize',14, 'Interpreter', 'Latex')
ylabel(y_name, 'FontSize', 14, 'Interpreter', 'Latex')
title(tit, 'FontSize', 14)
ax.FontSize = 14;

if  length(acsis)> 1
axis([acsis])    
end

end