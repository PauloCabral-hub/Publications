% tau_est = cut_branch(s,tau_est, pos, chain, rt)
%
% Returns the estimated tree after deciding if a terminal brach should
% be prunned or not.
%
% INPUT:
%
% s       = string that induces the terminal branch
% tau_est = cell in which each entry corresponds to a context of the 
%           estimated tree.
% pos     = positions in the estimated tree of the strings induced by s
% chain   = conditioning sequence follwowing tau_real function
% rt      = conditioned sequence of real numbers
%
% OUTPUT:
%
% tau_est = the estimated tree after a prunning procedure
%
% AUTHOR: Paulo Passos     MODIFIED: 01/08/2023


function tau_est = cut_branch(s, tau_est, pos, chain, rt)


sind = cell(1,length(pos));
for a = 1:length(pos)
sind{1,a} = tau_est{1,pos(1,a)};        
end

[~, ~, count] = count_contexts(sind, chain);

nh = find(count == 0);
sit = length(pos)-length(nh);

% case 1: all induced strings occured

if (isempty(nh))&&(length(pos) ~= 1)
% disp('Case 1')
ncut = prun_criteria(sind,chain, rt);
    if ncut ~= 1
        if brother_suffofacontext(tau_est, tau_est{1,pos(1,1)}, 3)
            % disp('subcase 3.1')
            % Cleaning zero counts
            if find(count == 0)
            tau_est = clean_zerocounts(tau_est, pos, count);
            end
        else
            % disp('subcase 3.2')
            tau_est = removing_branch_how(tau_est,pos,s,0);
        end
    end
end

% case 2: any of the induced strings occured

if length(pos) == length(nh)
% disp('Case 2')
    tau_est = removing_branch_how(tau_est,pos,s,0);
end


% case 3: a single string occurred

if sit == 1 
% disp('Case 3')    
posx =  pos(1,find(count ~= 0)); %#ok<FNDSB>
    if brother_suffofacontext(tau_est, tau_est{1,posx}, 3)
        % disp('subcase 3.1')
        % cleaning zero counts
        if find(count == 0)
        tau_est = clean_zerocounts(tau_est, pos, count);
        end
    else
        % disp('subcase 3.2')
        tau_est = removing_branch_how(tau_est,pos,s,0);
    end
end

% case 4 : 2 or more induced strings occurred

if ( sit >= 2 )&&( sit < (length(pos)) )
% disp('Case 4')
    % replacing non-occurring contexts by empty strings
    sind = cell(1,length(pos)); auxpos = [];
    for a = 1:length(pos)
        if count(a,1) == 0
        tau_est{1,pos(1,a)} = [];
        else
        auxpos = [auxpos pos(1,a)]; sind{1,a} = tau_est{1,pos(1,a)}; %#ok<AGROW>
        end
    end
    pos = auxpos;
    % choosing if it should be prunned
    % option 1
    jump = 0;
    for a = 1:length(pos)
        if brother_suffofacontext(tau_est, tau_est{1,pos(a)}, 3)
           jump = 1;
        end
    end
    if jump == 0
    ncut = prun_criteria(sind,chain, rt);
        if ncut ~= 1
        tau_est = removing_branch_how(tau_est,pos,s,0); 
        end        
    end
end
    

% cleaning
tau_est = removing_branch_how(tau_est,[],[], 1);

end


