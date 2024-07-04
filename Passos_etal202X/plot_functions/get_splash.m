% splash = get_splash(EEG)
%
% DESCRIPTION: Given the EEG struct with channel locations, provides a
% matrix with the vectors corresponding projection of the 3D location of
% the channels with a slight modification in order to prevent channels of
% being too close to each other.
%
% INPUT:
%
% EEG = EEG struct from EEGlab
%
% OUTPUT:
%
% splash = matrix with the vectors in the description
% channels = cell with the name of the vectors.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 16/07/2024


function [channels, splash] = get_splash(EEG)

channels = {};
V = zeros(length(EEG.chanlocs),3);
Cz_coord = [EEG.chanlocs(32).X, EEG.chanlocs(32).Y, 0];
 
 % Centralizing in Cz
for a = 1:length(EEG.chanlocs)
    channels{a} = EEG.chanlocs(a).labels; 
    V(a,1) = EEG.chanlocs(a).X + (-1)*Cz_coord(1);
    V(a,2) = EEG.chanlocs(a).Y + (-1)*Cz_coord(2);
    V(a,3) = EEG.chanlocs(a).Z ;
end

% Making the minimum Z equal 0
V(:,3) = V(:,3)+abs(min(V(:,3)));

% Getting the maximum height
h_max = max(V(:,3));
    
    splash = zeros(size(V,1),2);
    for a = 1:length(EEG.chanlocs)
       v_p = V(a,1:2);
       if norm(v_p) ~= 0
            u_p = v_p./norm(v_p);
       else
            u_p = zeros(1,2);
       end
       splash(a,:) =  v_p + u_p*abs(h_max - V(a,3));
       splash(a,:) = rot90(splash(a,:));
    end    
    

end