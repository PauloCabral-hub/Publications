% DESCRIPTION: Make the mode trees for each electrode

orig_path = 'C:\Users\Cabral\Documents\pos_doc\Coleta\joint_trees_data';
dest_path = 'C:\Users\Cabral\Documents\pos_doc\Coleta\mode_trees_data';

var_files = dir(orig_path);

% Cleaning directories entries

del_entries = [];
for a = 1:length(var_files)
    if var_files(a).isdir == 1
        del_entries = [del_entries a]; %#ok<AGROW>
    end
end
var_files(del_entries)=[];
var_files(12) = []; % this subject has a problem, volunteer 42

% loop: volunteers
clearvars global_repo
for v = 1:length(var_files)
    load([orig_path '\' var_files(v).name],'summary_repo')
    if exist('global_repo')
       global_repo = [global_repo; summary_repo]; 
    else
       global_repo = summary_repo;
    end
end

% getting the channel names
clearvars channels
aux = 1;
for a = 1:length(global_repo)
    if exist('channels')
       in_list = 0;
       for b = 1:length(channels)
          if strcmp(global_repo(a).chan, channels{b})
              in_list = 1;
              break
          end
       end
       if in_list == 0
           channels{aux} = global_repo(a).chan;
           aux = aux + 1;
       end
    else
       channels = {global_repo(a).chan};
       aux = aux +1; 
    end
end

% Getting the Modes per block

blocks = [1 501 1001];

clearvars trees_tmp mode_repo
aux2 = 1;
for c = 1:length(channels)
   chan = channels{c};
   for b = 1:length(blocks)
      aux = 1;
      for f = 1:length(global_repo)
         if strcmp(global_repo(f).chan, chan)
            if global_repo(f).from == blocks(b)
               if exist('trees_tmp')
                   trees_tmp{1, aux} = global_repo(f).tree;
%                    trees_tmp{2, aux} = global_repo(f).chan;
%                    trees_tmp{3, aux} = global_repo(f).subj_num;
                   aux = aux +1; 
               else
                   trees_tmp = {global_repo(f).tree}; %; global_repo(f).chan; global_repo(f).subj_num};
                   aux = aux + 1;
               end
            end
      end
   end
%
    [tau_mode, count_vec] = taumode_est(3, trees_tmp, 6);
    if exist('mode_repo')
        mode_repo{aux2,1} = tau_mode;
        mode_repo{aux2,2} = chan;
        mode_repo{aux2,3} = b;
        mode_repo{aux2,4} = count_vec;
        aux2 = aux2+1;
    else
        mode_repo = {tau_mode, chan, b, count_vec};
        aux2 = aux2+1;
    end
    end
%
end

for a =1:size(mode_repo,1)
   tree = mode_repo{a,1};
   counts = mode_repo{a,4};
   string_seq = tikz_tree(tree, [0 1 2], 1);
   standalone_tickztree(dest_path, string_seq, ['mode_' mode_repo{a,2} '_B' num2str(mode_repo{a,3})])
   str_to_text = '';
   for b = 1:length(tree)
      str_to_text = [ str_to_text '[' num2str(tree{b}) ']:' num2str(counts(b)) ' '];  %#ok<AGROW>
   end
   fid = fopen([dest_path '\mode_' mode_repo{a,2} '_B' num2str(mode_repo{a,3}) '_counts.txt'],'wt');
   fprintf(fid, str_to_text);
   fclose(fid);
end
