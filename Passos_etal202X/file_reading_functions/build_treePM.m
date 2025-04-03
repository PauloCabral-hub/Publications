% [contexts, PM] = build_treePM (tree_file_address)
%
% Description: Reads a text file with the context tree structure and
% returns contexts in a cell structure called 'contexts', the probability
% matrix in 'PM'.
%
% INPUT:
% tree_file_adress = file path with the tree structure*.
%
% OUTPUT:
% ctxs = contexts in the context tree model
% PM = probability matrix. The 1st line corresponds to the probability
% distribution of the first context of 'ctxs', the 2nd context to the
% second contexts, and this ways forward.
%
% *Example of the content in the file:
% ctx: {0; 01; 11; 2}
% pm: {(0,1,0); (0,0.25,0.75); (1,0,0); (1,0,0)}
%
% Author: Paulo Roberto Cabral Passos     Last modified = 29/02/2024


function [contexts, PM] = build_treePM (tree_file_address)

fid = fopen(tree_file_address);
des = fscanf(fid,'%s');
fclose(fid); 

% Parsing file
contexts = cell(1,count(des,'('));
PM = zeros(count(des,'('), count(des,',')/count(des,'(') +1);

data = split(des,'pm:');
ctx_des = data{1}; ctx_des = split(ctx_des,'ctx:');
ctx_des = ctx_des{2};
ctx_des = replace(ctx_des, '{','');ctx_des = replace(ctx_des, '}','');
ctx_des = split(ctx_des,';');

for a = 1:length(ctx_des)
    vec = zeros(1,length(ctx_des{a}));
    for b = 1:length(ctx_des{a})
    vec(1,b) = str2num(ctx_des{a}(1,b)); %#ok<ST2NM>
    end
    contexts{a} = vec;
end


pm_des = data{2};
pm_des = replace(pm_des, '{','');pm_des = replace(pm_des, '}','');
pm_des = split(pm_des,';');

for a = 1:length(contexts)
    aux1 = pm_des{a};
    aux1 = replace(aux1,'(',''); aux1 = replace(aux1,')','');
    aux2 = split(aux1,',');
    for b = 1:size(PM,2)
        PM(a,b) = str2num(aux2{b}); %#ok<ST2NM>
    end
end

end