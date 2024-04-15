% [proj_vals, proj_labels] = get_projections(A, B, sample_stretch)
%
% Returns two vectors <proj_vals> and <proj_labels>. Each entry of <proj_
% vals> correponds to the projections of a functional in <A> or <B> in  a  
% brownian bridge. The labels in <proj_labels> indicate for that value in
% <proj_vals> from which set (cell) <A>:1 or <B>:2 the functional projected
% was picked. The same brownian bridge is used for all projections.
%
% INPUT:
%
% A = a cell containing in each row a different functional.
% B = a cell containing in each row a different functional.
% sample_stretch = size in samples of each functional to be used in the pro
% -jection. !ATTENTION! The functionals must have the same size of the sam-
% ple stretch.
%
% OUTPUT:
%
% proj_vals = a vector in wich each entry corresponds to a projection of a
% functional in the set <A> or <B>.
% proj_labels = a vector in wich each entry corresponds to 1 or 2. 1 indi-
% cates that the given projection was obtained from a functional in the set
% (cell) <A>. 2 indicates the set (cell) <B>.
% 
% Author: Paulo Roberto Cabral Passos       Last modified: 18/10/2023

function [proj_vals, proj_labels] = get_projections(A, B, sample_stretch)

bridge = brownianbrigde(sample_stretch);

proj_vals = zeros(2*length(A),1);
proj_labels = zeros(2*length(A),1);
aux = 1;
len_A = length(A);
    for k = 1:len_A
        if ~isempty(A{k,1})
            proj = dot( bridge, A{k,1} );
            proj_vals(aux,1) = proj;
            proj_labels(aux,1) = 1;
            aux = aux+1;
        end
    end
len_B = length(B);
    for k = 1:len_B
        if ~isempty(B{k,1})
            proj = dot( bridge, B{k,1} );
            proj_vals(aux,1) = proj;
            proj_labels(aux,1) = 2;
            aux = aux+1;
        end
    end
proj_vals = proj_vals(find(proj_labels > 0),1); %#ok<FNDSB>
proj_labels = proj_labels(1:length(proj_vals),1);

end