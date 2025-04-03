% DESCRIPTION: this routine calculates the pos-error slowing in the same
% fashion described in Cabral-Passos 2024

% Loading data
data = jdata;

% Defining paramenters
tau = 7;
tree_file_address = 'C:\Users\Cabral\Documents\pos_doc\Publications\Passos_etal202X_behavior\files_for_reference\num7.tree';
num_of_subj = max(data(:,6));
tau_cardinal = 5;
from = 1;
till = 1500;

ctx_step = [3 1 2 2 1];

% Getting the response times in case of success and failure

suc_repo = cell(num_of_subj,tau_cardinal);
fail_repo = cell(num_of_subj,tau_cardinal);
for id = 1:num_of_subj
    % for response time analysis
%     [ctx_rtime, ctx_er, ctx_resp, contexts, ct_pos] = rtanderperctx(data, id, from, till, tree_file_address, tau);
%     [chain_seq, resp_seq, rt_seq] = get_seqandresp(data,tau, id, from, till);
    % for ranked time analysis
    datar = data_rtimes(data);
    [ctx_rtime, ctx_er, ctx_resp, contexts, ct_pos] = rtanderperctx(datar, id, from, till, tree_file_address, tau);
    [chain_seq, resp_seq, rt_seq] = get_seqandresp(datar,tau, id, from, till);    
    for nctx = 1:tau_cardinal
        [ctx_fer,ct_poscell] = lastwas_error(ct_pos, ctx_er, contexts, chain_seq, resp_seq, ctx_step(nctx));
        suc_rts = [];
        fail_rts = [];
        for a = 1:length(ctx_rtime{nctx,1})
            if ctx_fer{nctx,1}(a,1) == 0
               suc_rts = [suc_rts; ctx_rtime{nctx,1}(a,1)];
            else
               fail_rts = [fail_rts; ctx_rtime{nctx,1}(a,1)];
            end
        end
        suc_repo{id,nctx} = suc_rts;
        fail_repo{id,nctx} = fail_rts;
    end
end

% Getting the trimmed mean and difference

suc_mat = zeros(num_of_subj,tau_cardinal);
fail_mat = zeros(num_of_subj,tau_cardinal);
dif_mat = zeros(num_of_subj,tau_cardinal);


for a = 1:num_of_subj
    for b =1:tau_cardinal
        suc_mat(a,b) = trimmean(suc_repo{a,b},5);
        fail_mat(a,b) = trimmean(fail_repo{a,b},5);
        dif_mat(a,b) = fail_mat(a,b)-suc_mat(a,b);
    end
end

% Getting the boxplot representation

order_ctxs = [5 4 1 2 3];

info_data = [];
group_data = [];
for a = 1: length(order_ctxs)
    gvec_size = length( dif_mat(:,order_ctxs(a)) );
    info_data = [ info_data; dif_mat(:,order_ctxs(a))] ;
    group_data = [ group_data; a*ones(gvec_size,1) ]; 
end

figure
sbox_varsize(group_data, info_data,  'contexts(w)', '$T_{w,f}-T_{w,s}$', [], {'2'; '21'; '0'; '01'; '11'}, 0.05, 0, [])
axis square

% Getting the statistics

stats_sum = zeros(1,tau_cardinal);
for a = 1:tau_cardinal
   [p, h] = signrank( dif_mat(:,a) );
   stats_sum(a) = p;
end


