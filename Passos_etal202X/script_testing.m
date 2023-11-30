% Uploading channel information
load('/home/paulocabral/Documents/data_sets/usp_set/chan_loc_and_info.mat')

% Adding local pathways
addpath('/home/paulocabral/Documents/matlab_packages/eeglab2023.1')
addpath(genpath('/home/paulocabral/Documents/matlab_packages/Publications/Passos_etal202X'))

vol = 4;

% Filtering
fs = 1024; ntrials = 1500; alphal = 3; proj_num = 5000; low_cut = 1; high_cut = 45;
[data, channels, EEGtimes, EEGsignals] = EEG_data_matrix(ALLEEG, ntrials, fs, 1, 7, 1);
fEEGsignals = filtEEGdata(EEGsignals,fs,low_cut,high_cut);
EEG.data = fEEGsignals;

for ch = 1:31
eval (['diary /home/paulocabral/Documents/fortesting/vol' num2str(vol) '_chanel' num2str(ch) '_output.log'])
% Setting minimum response time
[valids, signals, sample_stretch] = valid_functionals(data, fs, 0.300, EEG, 0, 0);

% Defining channel
% ch = #;
s = 1;
e = 500;
sig_set = cell(e-s+1,1); aux = 1;
for a = s:e
    sig_set{aux,1} = signals{a,ch};
    aux = aux + 1;
end
chain = data(s:e,9)';

% Testing the algorithm
% for a = 2:200
%     if isequal([chain(1,a) chain(1,a-1)], [0 1])
%         sig_set{a+1,1} = cos([0:203]*10*(1/fs)*2*pi); 
%     elseif isequal([chain(1,a) chain(1,a-1)], [1 1])
%         sig_set{a+1,1} = cos([0:203]*20*(1/fs)*2*pi); 
%     elseif isequal([chain(1,a) chain(1,a-1)], [2 1])
%         sig_set{a+1,1} = cos([0:203]*30*(1/fs)*2*pi); 
%     elseif isequal(chain(1,a), 0)
%         sig_set{a+1,1} = cos([0:203]*40*(1/fs)*2*pi); 
%     else
%         sig_set{a+1,1} = cos([0:203]*50*(1/fs)*2*pi); 
%     end
% end


% Estimating tree
[tau_est, mosaic] = tauest_ftype(alphal, chain, sig_set, proj_num, sample_stretch);
string_seq = tikz_tree(tau_est, [0 1 2], 1);

% Writting structure to file
standalone_tickztree('/home/paulocabral/Documents/fortesting', string_seq, ['ch' num2str(ch) '_ sample_tree_' num2str(s) 't' num2str(e) '_filt' num2str(low_cut) 't' num2str(high_cut) ])

diary off
end
% % For inspection
% y = signals{4,1};
% Fs = 1024;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = length(y);        % Length of signal
% t = (0:L-1)*T;        % Time vector
% 
% Y = fft(y);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs/L*(0:(L/2));
% 
% plot(f,P1,"LineWidth",3) 
% title("Single-Sided Amplitude Spectrum of S(t)")
% xlabel("f (Hz)")
% ylabel("|P1(f)|")
% xlim([0 50])


% hold on 
% for a = 1:length(sig_set)
%     plot(sig_set{a,1});
% end