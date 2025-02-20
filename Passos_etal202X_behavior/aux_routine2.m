% DESCRIPTION: This routine calculates the success rate of each participant
% in the sample

% Loading data
data = jdata;

% Parameter definitions
tau = 7;
num_of_subj = length(unique(data(:,6)));
blocks = [1 500; 501 1000; 1001 1500];

% Calculating the success rate per block

srate_repo = zeros(num_of_subj,size(blocks,2));
for b = 1:size(blocks,1)
    for a = 1:num_of_subj
        [chain_seq, resp_seq, rt_seq] = get_seqandresp(data,tau, a, blocks(b,1), blocks(b,2));
        srate = sum(chain_seq == resp_seq)/length(chain_seq);
        srate_repo(a,b) = srate;
    end
end

% Calculating the success rate per context

from = 1;
till = 1500;
clearvars srate_per_context
for a = 1:num_of_subj
    tree_file_address = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X_behavior\files_for_reference\num7.tree';
    [ctx_rtime, ctx_er, ctx_resp, contexts, ct_pos] = rtanderperctx(jdata, a, from, till, tree_file_address, 7);
    if ~exist('srate_per_context') %#ok<EXIST>
        srate_per_context = zeros(num_of_subj,length(ctx_rtime));
    end
    for b = 1:length(ctx_rtime)
       cor_pred = ctx_er{b,1} == 0;
       srate = sum(cor_pred)/length(cor_pred);
       srate_per_context(a,b) = srate;
    end
end

% Calculating the predictions in the context that varies
% NOT GENERIC, CONTEXT TREE SPECIFIC

ctx_2_01_repo = zeros(num_of_subj,2);
for a= 1:num_of_subj
    count_2 = 0; count_2t = 0;
    count_01 = 0; count_01t = 0;
    [ctx_rtime, ctx_er, ctx_resp, contexts, ct_pos] = rtanderperctx(jdata, a, from, till, tree_file_address, 7);
    [chain_seq, resp_seq, rt_seq] = get_seqandresp(jdata,7, a, from, till);
    num_0s = sum(ct_pos(1,:) ~= 0);
    for b = 1:num_0s
       if chain_seq(ct_pos(1,b)+1) == 2
          if chain_seq(ct_pos(1,b)+1) == resp_seq(ct_pos(1,b)+1)
             count_2 = count_2 + 1;
          end
          count_2t = count_2t + 1;
       else
          if chain_seq(ct_pos(1,b)+1) == resp_seq(ct_pos(1,b)+1)
             count_01 = count_01 + 1;
          end
           count_01t = count_01t + 1;
       end
    end
    ctx_2_01_repo(a,1) = count_2/count_2t;
    ctx_2_01_repo(a,2) = count_01/count_01t;
end

% Graphical representations

dvec = [];
gvec = [];
for b = 1:size(srate_per_context,2)
    for a = 1:size(srate_per_context,1)
        dvec = [dvec; srate_per_context(a,b)];
        gvec = [gvec; b];
    end
end

figure
sbox_varsize(gvec, dvec,  'contexts (w)', 'success rate', [], {'0'; '01'; '11'; '21'; '2'}, 0.05, 0, [])
axis square

gvec = [];
dvec = [];
ctx_2_01_repo = [ctx_2_01_repo(:,2) ctx_2_01_repo(:,1) ];
for c = 1:size(ctx_2_01_repo,2)
   for a = 1:size(ctx_2_01_repo,1)
        dvec = [dvec; ctx_2_01_repo(a,c)];
        gvec = [gvec; c];
   end
end

figure
sbox_varsize(gvec, dvec,  'a', '$I (w \rightarrow a)$', [], {'1'; '2'}, 0.05, 0, [])
axis square
