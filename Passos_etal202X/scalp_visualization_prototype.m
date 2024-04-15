proj_coord = [];
for a = 1:31
    coord = [ chan_info(a).X chan_info(a).Y chan_info(a).Z ];
    proj = zeros(1,2);
    proj(1) = dot(coord,[1 0 0]);
    proj(2) = dot(coord,[0 1 0]);
    proj_coord = [proj_coord; proj];
end


w = 0.09;
l = 3;
spread = 1.1;
figure
hold on
for a = 1:size(proj_coord)
   %plot(proj_coord(a,1),proj_coord(a,2),'k.')
   for b = 1:l+1
      Cx = proj_coord(a,1)*(1+spread);
      Cy = proj_coord(a,2)*(1+spread);
      l_side = (Cx-w/2);
      r_side = (Cx+w/2);      
      h_line = linspace(Cx-w/2,Cx+w/2);
      level = (Cy -(w*l/2) + (b-1)*w);
      plot(  h_line, ones( 1,length(h_line) )*level, 'k'  );
      if b == l+1
         v_line = linspace(Cy-(w*l/2),Cy+(w*l/2));
         plot(  ones( 1,length(v_line) )*l_side,v_line, 'k'  )
         plot(  ones( 1,length(v_line) )*r_side,v_line, 'k'  )
      end
      if b < l+1
      text(l_side,level+0.035,'10','FontSize',8)
      end
   end
end
axis square
xlim([-2.5 2.5])