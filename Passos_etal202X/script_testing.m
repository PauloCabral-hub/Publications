fs = 1024; ntrials = 1500; alphal = 3; proj_num = 2500;
[data, channels, EEGtimes, EEGsignals] = EEG_data_matrix(ALLEEG, ntrials, fs, 1, 7, 1);
fEEGsignals = filtEEGdata(EEGsignals,fs,5,50);
EEG.data = fEEGsignals;
[valids, signals, sample_stretch] = valid_functionals(data, fs, 0.200, EEG);
sig_set = signals(:,8); chain = data(:,9)';
[tau_est] = tauest_ftype(alphal, chain, sig_set, proj_num, sample_stretch);
string_seq = tikz_tree(tau_est, [0 1 2], 1);


