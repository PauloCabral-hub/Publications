% staircase_plot(chan_info, topo_mat, new_fig)
%
% DESCRIPTION: plots a topographical map of the head where boxes appear in
% the position of each channel. Inside each box, a number appears
% referenced to a tree. Each box in a given channel position indicates the
% tree retrieved for that block. Boxes at the bottom indicates the first
% block, and at the top, last block.
%
% INPUT:
%
% chan_inf = channel information structure in the form of EEGlab
% topo_mat = a matrix with the numbers referenced to the trees.
% Different lines indicates different channels. Difference collumns
% indicates different blocks.
% new_fig = if set to 1, creates a figure for the plot.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/04/2024

function staircase_plot(chan_info, topo_mat, new_fig)
    % Calculating the projections for the plot
    last_ch = length(chan_info);
    proj_coord = zeros(size(topo_mat,1),2);
    for a = 1:last_ch
        Vec3D = [ chan_info(a).X chan_info(a).Y chan_info(a).Z ];
        proj_coord(a,:) = [ dot(Vec3D,[1 0 0]) dot(Vec3D,[0 1 0])];
    end
    
    % Preparing for plot
    topo_vec = reshape(topo_mat',size(topo_mat,1)...
    *size(topo_mat,2),1);
    
    % Plotting parameters
    spread = 8; % increase to undo merging
    w = 0.2;    % determine the size of the blocks
    l = size(topo_mat,2);
    
    if new_fig == 1
       figure('units','normalized','outerposition',[0 0 1 1]);
    end
    hold on
    
    aux = 1;
    for a = 1:size(proj_coord,1)
       for b = 1:l+1
          Cx = proj_coord(a,1)*(1+spread);
          Cy = proj_coord(a,2)*(1+spread);
          l_side = (Cx-w);
          r_side = (Cx+w);      
          h_line = linspace(l_side,r_side);
          v_width = 2*w;
          level = (Cy -(v_width*l/2) + (b-1)*v_width);
          plot(  h_line, ones( 1,length(h_line) )*level, 'k'  );
          if b == l+1
             v_line = linspace(Cy-(v_width*l/2),Cy+(v_width*l/2));
              plot(  ones( 1,length(v_line) )*l_side,v_line, 'k'  )
              plot(  ones( 1,length(v_line) )*r_side,v_line, 'k'  )
          end
          if b < l+1
              if topo_vec(aux) < 5
                text(l_side,level+v_width/3,num2str(topo_vec(aux)),'FontSize',8, 'Color', 'b')
              else
                text(l_side,level+v_width/3,num2str(topo_vec(aux)),'FontSize',8, 'Color', 'k')
              end
              if b == 1
                text(l_side,level-v_width, num2str(chan_info(a).labels),'FontSize',8, 'Color', 'g')
              end
          aux = aux+1;
          end
       end
    end    
    axis off
end

