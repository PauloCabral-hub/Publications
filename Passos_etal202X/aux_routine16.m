% DESCRIPTION: Calculates how many no logical errors are done by the
% subjects

% Loading data and parameters
tree_file_address = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\files_for_reference\num7.tree';
data_adress = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X\sim_data\working_matrix.mat'; 
[contexts, PM] = build_treePM (tree_file_address);
load(data_adress,'total_data')
num_of_subjs = max( total_data(:, 6) );

%

blocks = [1 500; 501 1000; 1001 1500]; 
leave_out = [10 42];

big_score_ls = [];


for a = 1:num_of_subjs
   leave = 0;
   idata = total_data( total_data(:,6) == a , :);
   % checking if the participant should be discarded
   for b = 1:length(leave_out)
      if isequal(idata(1,15), leave_out(b))
        leave = 1;
      end
   end
   
   % processing data from the participant
   if leave == 0
       score_ls = [];
       for b = 1:size(blocks,1)
           bdata = idata(blocks(b,1):blocks(b,2),:);
           [ctx_posi, ctx_pose, ctx_count] = count_contexts(contexts, bdata(:,9)');
           legal_sclist = zeros(length(contexts),1);
           wlegal_score = 0;
           for c = 1:length(contexts)
               legal_ans = find(PM(c,:) > 0 ) - 1;
               legal_score = 0;
               nrep = find( ctx_pose(c,:) >  0, 1, 'last' );
               for d = 1: nrep
                    if (ctx_pose(c,d) + 1 ) <= size(idata,1)
                        ans = bdata( ctx_pose(c,d) + 1, 8);
                        if ismember(ans,legal_ans)
                           legal_score = legal_score + 1; 
                        end
                    end                
               end
               legal_score = legal_score/nrep;
               legal_sclist(c,1) = legal_score;
               wlegal_score = wlegal_score + (ctx_count(c)/sum(ctx_count))*legal_score;
           end
           score_ls = [score_ls wlegal_score]; 
       end
       big_score_ls = [big_score_ls; score_ls];
   end
end



