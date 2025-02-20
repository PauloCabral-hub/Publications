% scalp_heatmap(assets_adress, max_value, min_value, chan_and_val)
%
% DESCRIPTION: Produces a heat map of the scalp acording to the values
% provided in <chan_and_val> structure. 
%
% INPUT:
%
% assets_adress = adress containing some assets for enabling plot on the
% scalp (see function body for a tip).
% max_val = maximum value, will correspond to the greener in the map
% min_val = minimum value, will correspond to the less green in the map
% chan_and_val = cell structure containing the name of channel in the first
% column and a value for it in the next 
% column.
% invert = if set to 1 inverts the color bar (smaller values on top).
%
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 20/02/2025


function scalp_heatmap(assets_adress, max_val, min_val, chan_and_val, invert)

set(0,'defaultfigurecolor',[1 1 1])
% PARAMETERS FOR TESTING THE FUNCTION
%assets_adress = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\assets';
%max_val = 1;
%min_val = 0;


load([assets_adress '\' 'scalp_plot_info32_SI1020.mat'])
load([assets_adress '\' 'channel_order32_SI1020.mat'])


% Calculating the range
vrange = max_val - min_val;

% Given <vrange> the value is ( (x-min)/vrange )*256, where 256 is the
% maximum value of the green channel of the RGB

% Convert to double for blending
scalp = im2double(scalp);
eplacements = im2double(eplacements);

alpha = 0.50; % Blending factor (0 to 1)
overlayed_img = (1 - alpha) * scalp + alpha * eplacements;

r_def = 15;

gchan_vec = [];
raw_vec = [];
for a = 1:size(chan_and_val,1)
   lup_chan = chan_and_val{a,1};
   gchan = ((chan_and_val{a,2} - min_val)/vrange );
   for b = 1:size(chan_order,2)
      if isequal(chan_order{1,b},lup_chan)
         center_x = chan_imsites(b,1);
         center_y = chan_imsites(b,2);
           for c =  (center_x-r_def):(center_x+r_def)
              for d = (center_y-r_def):(center_y+r_def)             
                  overlayed_img(d,c,1) = 0;
                  if invert == 1
                     overlayed_img(d,c,2) = 1 - gchan; 
                  else
                     overlayed_img(d,c,2) = gchan; 
                  end
                  overlayed_img(d,c,3) = 0; 
              end
           end
      end
   end
end

imshow(overlayed_img)

% Adding the colormap

% Define the range of green values (from 20 to 200)
green_values = linspace(0, 256, 256); % 256 levels of green

% Create the colormap (R = 0, B = 0, varying only G)
colormap_rgb = [zeros(256,1), green_values', zeros(256,1)] / 256;

% Display the colorbar
colormap(colormap_rgb);
h = colorbar;  % Handle for colorbar

% Set color limits to match green intensity values
caxis([0 256]);

% Define custom tick labels mapping green values to x-axis values
tick_positions = linspace(0, 256, 4); % Select tick positions in green scale
if invert == 1
    tick_labels = linspace(max_val, min_val, 4); % Map to x-axis range
else
    tick_labels = linspace(min_val, max_val, 4); % Map to x-axis range
end


% Apply the custom labels to the colorbar
h.Ticks = tick_positions;  
h.TickLabels = arrayfun(@(x) sprintf('%.2f', x), tick_labels, 'UniformOutput', false);

end