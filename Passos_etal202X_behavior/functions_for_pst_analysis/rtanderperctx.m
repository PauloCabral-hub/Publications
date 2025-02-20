% [ctx_rtime, ctx_er, ctx_resp, contexts, ct_pos] = rtanderperctx(data, id, from, till, tree_file_address, tau) 
%
%
% DESCRIPTION: This function provides the response times, errors and
% responses per context given the parameters bellow
%
% INPUT:
% data = standardized matrix of the goalkeeper game expirement.
% id = alternative id of the participant
% from =  starting on trial
% till = ending on trial
% tree_file_address = complete address with the tree information
% tau = number that identifies the tree in the experiment
%
% OUTPUT:
% ctx_rtime = cells with the response times organized by context (cell type)
% ctx_er = cells with the error organized by context, error is indicated with 1 (cell type)
% ctx_resp = cells with the responses organized by context (cell type)
% contexts = contexts of the tree
% ct_pos = matrix in which each non-zero row indicates the positions of
% context occurrence in the sequence. 
%
% AUTHOR: Paulo Roberto Cabral Passos LAST MODIFIED: 10/09/2024

function [ctx_rtime, ctx_er, ctx_resp, contexts, ct_pos] = rtanderperctx(data, id, from, till, tree_file_address, tau) 

% Gathering Tree information

[contexts, ~] = build_treePM (tree_file_address);

start = 0;
for a = 1: size(data,1)
    if (data(a,3) == 1)&&((data(a,6) == id)&&(data(a,5) == tau))
        start = a;
    end
end

start = start + from -1;
%disp(['starting at:' num2str(start)])

if start == 0
   ctx_rtime = cell(length(contexts),1); 
   ctx_er = cell(length(contexts),1);
   ctx_resp = cell(length(contexts),1);
   ct_pos = [];
   return;
else
    over = start + (till-from); 
    %disp(['ending at:' num2str(over)])
    % Feeding count_contexts

    chain = data(start:over, 9);
    response = data(start:over, 8);
    time = data(start:over,7);

    [~,ct_pos, ] = count_contexts(contexts, chain');

    % Dividing response times per context

    ctx_rtime = cell(length(contexts),1); % for the storage of the response time per context
    ctx_er = cell(length(contexts),1); % for the storage of the error per context
    ctx_resp = cell(length(contexts),1); % for the storage of the response
    
    er = 0;
    for a = 1:length(contexts)
       auxr_ctx = [];
       auxe_ctx = [];
       auxresp_ctx = [];
       for b = 1:size(ct_pos,2)
           if (ct_pos(a,b) ~= 0)&&(ct_pos(a,b) ~= 102)
           auxr_ctx = [auxr_ctx; time(ct_pos(a,b)+1,1)]; %#ok<AGROW>
           auxresp_ctx = [auxresp_ctx; response(ct_pos(a,b)+1,1)]; %#ok<AGROW>
           er = response(ct_pos(a,b)+1,1)~= chain(ct_pos(a,b)+1,1);
           auxe_ctx = [auxe_ctx; er]; %#ok<AGROW>
           end
       end
       ctx_rtime{a,1} = auxr_ctx;
       ctx_er{a,1} = auxe_ctx;
       ctx_resp{a,1} = auxresp_ctx;
    end
end



end



