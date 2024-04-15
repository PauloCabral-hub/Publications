% Date 29/02/2024
%
% Description: Generates all possible retrievable trees from a sequence
% sample generated from a probabilistic context tree model.

tic
% Setting Parameters

height = 5;
alphabet = [0 1 2];
trees_path = '/home/paulo-cabral/Documents/pos-doc/pd_paulo_passos_neuromat/Publications/Passos_etal202X/files_for_reference/';
tau = 7; seq_length = 100;
tree_file_address = [trees_path 'num' num2str(tau) '.tree' ];
[contexts, PM] = build_treePM (tree_file_address);
tree_seq = gen_tree_sequence(contexts, PM, seq_length);

% Constructing the full tree

full_tree = full_tree_with_vertices(alphabet, height);

% Detecting the branches

brothers = identifying_branches(full_tree, height);

% Getting the minimum admissible tree

to_discard = []; aux_add = 1;
for d = 2:height
    all_perm = permwithrep([0 1 2], d);
    for c = 1:size(all_perm,1)
        [~, ~, occurance_count] = count_contexts({all_perm(c,:)}, tree_seq);
        if occurance_count == 0
            to_discard{1,aux_add} = all_perm(c,:); %#ok<SAGROW>
            aux_add = aux_add + 1;
        end
    end
end
clear d c all_perm aux_add 

h = height; eliminate = [];
while 1
    for w = 1:length(full_tree) % visiting each element of the full_tree
        w_current = full_tree{1,w};
        disc = 0;
        if length(w_current) == h % from the greater to the smaller sequences
           for w_alt = 1:length(to_discard)
               v_current = to_discard{1,w_alt};
               if sufix_test(v_current,w_current) % obs.: it starts eliminating from top
                  brother_list = find(brothers == brothers(w)); brother_count = 0;
                  for br = 1:length(brother_list)
                      brother_count = brother_count ...
                          +sufix_test(v_current, full_tree{1,brother_list(br)});
                  end
                  disc = floor( brother_count/length(brother_list) );
                  if disc == 1; break; end
               end
           end
           if disc == 1
              eliminate = [eliminate brothers(w)]; %#ok<AGROW>
           end
        end
    end
h = h-1;
    if h < 3
       break; 
    end
end
clear w h w_current disc w_alt v_current br

eliminate = unique(eliminate);

% Resetting the tree and the associated index sequences

new_full_tree = {};
new_brothers = []; aux_add = 1;
for b = 1:length(brothers)
    if isempty(  find( eliminate == brothers(b) )  ) %#ok<EFIND>
       new_full_tree{1,aux_add} = full_tree{1,b}; %#ok<SAGROW>
       new_brothers(1,aux_add) = brothers(b); %#ok<SAGROW>
       aux_add = aux_add + 1;
    end
end
clear b aux_add


aux_rank = unique(new_brothers);
for b = 1:length(new_brothers)    
    new_brothers(b) = find(aux_rank == new_brothers(b)); %#ok<SAGROW>
end

full_tree = new_full_tree;
brothers = new_brothers;
clear new_brothers new_full_tree b

% Generate all combination of branches

[tree_list, elements] = generating_subtrees(brothers, full_tree);

% Performing corrections on the trees

wbar = waitbar(0, 'Rectifying trees (1)...');
for t = 1:size(tree_list,1)
    if tree_list(t,1) == 1
       % correction procedure
       if ~isempty(full_tree(find(elements(t,:) == 1))) %#ok<FNDSB>
           while 1
                 modified = 0;
                 tree_aux = full_tree(find(elements(t,:) == 1)); %#ok<FNDSB>
                 for w = 1:length(tree_aux)
                            w_current = tree_aux{1,w}; one_modification = 0;
                            while ~isempty(w_current)
                                   uncles = generating_uncles(w_current, alphabet);
                                   [elements_row, one_modification] = best_uncles_fit...
                                       (pinpoint_uncleslocation(full_tree, uncles), elements(t,:), full_tree); % find where the uncles are in the full tree
                                   if one_modification == 1
                                      elements(t,:) = elements_row; modified = 1;
                                   end
                                w_current = gen_imsufix(w_current);
                            end
                 end
                 if modified == 0
                    break
                 end
           end
       end  
    end
    waitbar(t/length(tree_list),wbar)
end
close(wbar)
clear t w modified w_current uncles

elements_full = elements;

% Rectifying trees

wbar = waitbar(0, 'Rectifying trees (2) ...');
for t = 1:length(tree_list)
    if tree_list(t,1) == 1
       for a = 1:size(elements,2)
           if elements(t,a) == 1
              [~, ~, occurance_count] = count_contexts(full_tree(a), tree_seq);
              if occurance_count == 0
                 elements(t,a) = 0; 
              end
           end
       end
    end
    waitbar(t/length(tree_list),wbar)
end
close(wbar)
clear t a

elements = elements( find(tree_list == 1),: ); %#ok<FNDSB>
elements = unique(elements, 'rows');


% Building the vertices trees representation

elements_vertices = zeros( size(elements,1), size(elements,2) );
wbar = waitbar(0, 'Getting the vertice tree representation...');
for t = 1:size(elements,1)
    for w = 1:size(elements,2)
        if elements(t,w) == 1
           w_current = full_tree{1,w};
           while ~isempty(w_current)
                  for s = 1:length(full_tree)
                      if isequal(full_tree{1,s},w_current)
                         elements_vertices(t,s) = 1;
                      end
                  end
                  w_current = gen_imsufix(w_current);
           end           
        end
    end
    waitbar(t/size(elements,1),wbar)
end
close(wbar)
clear t w

% Removing only childs

wbar = waitbar(0, 'Removing only childs...');
for t = 1:size(elements,1)
    while 1
        modified = 0;
        for w = 1:size(elements,2)
            if elements(t,w) == 1
               w_current = gen_imsufix(full_tree{1,w});
               occurance_count = 0; brother_list = [];
               for b = 1:size(alphabet,2)
                   brother = [alphabet(b) w_current]; brother_list = [brother_list; brother]; %#ok<AGROW>
                   for v = 1:size(elements,2)
                       if elements_vertices(t,v) == 1
                          if isequal(brother,full_tree{1,v}); occurance_count = occurance_count+1;end
                       end
                   end
               end
               if occurance_count < 2 % found a only child
                  elements(t,w) = 0; elements_vertices(t,w) = 0; modified = 1;
                  for v = 1:size(elements,2)
                      if isequal(full_tree{1,v},w_current)
                         elements(t,v) = 1; elements_vertices(t,v) = 1;
                      end
                  end
               end
            end
        end
        if modified == 0; break; end
    end
    waitbar(t/size(elements,1),wbar)
end
close(wbar)
clear t w b v

elements = unique(elements,'rows');


% Use following parameter to acess the trees
% obs.: must not surpass the number of lines in elements

ptrees = cell(size(elements,1),1);
for k = 1:size(elements,1)
    curr_tree = full_tree(elements(k,:) == 1);
    ptrees{k,1} = curr_tree;
end

toc