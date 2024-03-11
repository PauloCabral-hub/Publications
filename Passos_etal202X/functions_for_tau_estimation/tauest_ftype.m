% [tau_est] = tauest_ftype(alphal, real_chain, chain, sig_set, proj_num, sample_stretch)
%
% Returns <tau_est> the estimated tree from a conditioning sequence of sym-
% bols with alphabet A = {0,1,2} and the conditioned sequence of  real fun-
% ctionals <sig_set>. In Passos_etal202X, <chain> corresponds to the  goal-
% keeper  sequence, while <sig_set> corresponds to a sequence of EXG asso-
% ciated with the experiment.
%
% INPUT:
% 
% alphal     = positive integer that corresponds to the length of the al-
%              phabet.
% chain      = row vector containing the conditioning sequence.
% sig_set    = row cell containing the associated signals (EXG) associated
%              whith each entry of <chain>
% proj_num   = number of projections to make for the pruning criteria.
% sample_stretch = length in samples of the functional to be used in the 
%              the projection test.
%
% OUTPUT:
%
% tau_est    = cell in which each entry corresponds to a context of the es-
%              timated tree
%
% AUTHOR: Paulo Roberto Cabral Passos Last modified: 18/10/2023
%
% Obs.: ELIMINATE MOSAIC OUTPUT

function [tau_est, mosaic] = tauest_ftype(alphal, chain, sig_set, proj_num, sample_stretch)
    mosaic = [];
    p_times = 0;
    % building the alphabet
    A = zeros(1,alphal);
    for a = 1:alphal
        A(1,a) = a-1;
    end
    L = floor(log10(length(chain))/log10(3));

    perm = permwithrep(A,L);

    tau_est = cell(1,length(A)^L);

    for a = 1:size(perm,1)
    tau_est{1,a} = perm(a,:);
    end

    for h = 1:L
        fprintf('Processing...visiting height %d from the tree\n', L-h);
        if (L-h) == 0 % visiting root branch.
            perm = [];
            branchs = 1;
        else
            perm = permwithrep(A,L-h);
            branchs = size(perm,1);
        end
        % finding the leafs of the branch
        for a = 1:branchs
           pos = []; 
           for b = 1:length(tau_est)
                if (branchs == 1)&&(L-h == 0) % comment: visiting the root branch
                    if length(tau_est{1,b}) == 1 
                            pos = [pos b]; %#ok<AGROW> no test if equal
                    end                    
                else
                    if(length(tau_est{1,b}) == (length(perm(a,:))+1))
                        aux = sum(perm(a,:) == tau_est{1,b}(2:end),2)/length(perm(a,:)); % comment: test if equal
                        if  aux == 1
                            pos = [pos b]; %#ok<AGROW>
                        end
                    end    
                end
           end
        %  
        % pruning procedure
            if ~isempty(pos)
                fprintf('You are at the following branch: \n');
                for c = 1:length(pos)
                    fprintf([ num2str(tau_est{pos(c)}) '\n']);
                end
                if isempty(perm) % root branch
                    p_times = p_times+1;
                    if rem(p_times,10) == 0
                        fprintf('...performing pruning procedure for the %d-esimal time (root branch).\n', p_times)
                    end
                    [tau_est, mosaic] = cut_branch_ftype(perm,tau_est, pos, chain, sig_set, proj_num, sample_stretch, mosaic);
                else % other branches
                    p_times = p_times+1;
                    if rem(p_times,10) == 0                    
                        fprintf('...performing pruning procedure for the %d-esimal time. \n', p_times)
                    end
                    [tau_est, mosaic] = cut_branch_ftype(perm(a,:),tau_est, pos, chain, sig_set, proj_num, sample_stretch, mosaic);
                end
            end
        end
        %
    end
fprintf('End of procedure. \n');
end
