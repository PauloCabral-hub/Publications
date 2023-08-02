% [tau_est] = tauest_real(alphal, rt, chain)
%
% Returns <tau_est> the estimated tree from a conditioning sequence of sym-
% bols with alphabet A = {0,1,2} and the conditioned sequence of  real num-
% bers <rt>. In Passos_etal2023, <chain> corresponds to the goalkeeper  se-
% quence, while <rt> corresponds to a sequence of response times.
%
% INPUT:
% 
% alphal = positive integer that corresponds to the length of the alphabet.
% rt     = row vector containing the sequence of real numbers.
% chain  = row vector containing the conditioning sequence.
%
% OUTPUT:
%
% tau_est = cell in which each entry corresponds to a context of the  esti-
%           mated tree
%
% AUTHOR: Paulo Roberto Cabral Passos Last MODIFIED: 01/08/2023


function [tau_est] = tauest_real(alphal, rt, chain)

    % building the alphabet
    A = zeros(1,alphal);
    for a = 1:alphal
        A(1,a) = a-1;
    end
    L = floor(log10(length(chain))/log10(3));
    %

    perm = permwithrep(A,L);

    tau_est = cell(1,length(A)^L);

    for a = 1:size(perm,1)
    tau_est{1,a} = perm(a,:);
    end

    for h = 1:L
        if (L-h) == 0 % visiting root branch.
            perm = [];
            branchs = 1;
        else
            perm = permwithrep(A,L-h);
            branchs = size(perm,1);
        end
        % finding the leaft of the branch
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
                if isempty(perm) % root branch
                    tau_est = cut_branch(perm,tau_est, pos, chain, rt);
                else % Other branches
                    tau_est = cut_branch(perm(a,:),tau_est, pos, chain, rt);
                end
            end
        end
        %
    end

end
