% DESCRIPTION: This routine calculates the success rate of each participant
% in the sample

% Loading data
load('/home/paulo/Documents/Publications/Passos_etal202X_behavior/data/data.mat')

% Parameter definitions
tau = 7;
from = 1;
till = 1500;
num_of_subj = max(data(:,6));

% Processing

srate_repo = zeros(num_of_subj,1);
for a = 1: num_of_subj
    [chain_seq, resp_seq, rt_seq] = get_seqandresp(data,tau, a, from, till);
    srate = sum(chain_seq == resp_seq)/length(chain_seq);
    srate_repo(a,1) = srate;
end