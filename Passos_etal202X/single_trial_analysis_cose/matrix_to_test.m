close all

repo_recE = [];

for b = 1:500
    
% Creating a draft of ERP
sig_amp = 1;
noise_amp = 3;
fs = 250;
erp_len = 1/2*fs;
x = [0:erp_len-1];

y = exp( sin( x*(1/fs)*2*pi ) ) -1 ;
y = [zeros(1,fs), y, zeros(1,fs)];
x = [0:length(y)-1];

electrodes_set = 32;

sig_E = zeros(size(y,2),electrodes_set);
for a = 1:electrodes_set
    sig_E(:,a) = y'*sig_amp;
end

sig_E = sig_E+normrnd(0,noise_amp,size(sig_E,1), size(sig_E,2) );

% Matrix projection method

% energy_threshold = 0.30; % 95% energy preservation
% singular_values = diag(S);
% energy_total = sum(singular_values.^2);
% 
% cumulative_energy = cumsum(singular_values.^2) / energy_total;
M = 10; % find(cumulative_energy >= energy_threshold, 1, 'first'); % Find M dynamically


Sbar = mean(sig_E,2);
Btilde = zeros( size(sig_E,1), size(sig_E,2) );
for a = 1:size(Btilde,2)
   Btilde(:,a) = sig_E(:,a) - Sbar;  
end

[U, S, V] = svd(Btilde);

[ ~ , I ] = sort( diag(S), 'ascend');

D = U( :, I(1:M) )';

recE = D*sig_E(:,1);

repo_recE = [ repo_recE recE ];

end


% Seeing the result of the application of the denoising matrix

plot(mean(repo_recE,2))

% Compute SVD
% [U, S, V] = svd(A);
%
% % Estimate noise level using median singular value
% sigma_noise = median(diag(S)) / sqrt(0.6745);
% 
% % Compute threshold tau using Donoho & Gavish formula
% tau = sigma_noise * (sqrt(size(A,1)) + sqrt(size(A,2)));
% 
% % Apply thresholding
% S_den = S .* (S >= tau); % Zero out singular values below threshold
% 
% % Reconstruct denoised matrix
% A_den = U * S_den * V';
% 
% 
% % Matrix Projection
% 
% 
% 
% 
% 
% 
% 
% subplot(1,2,1)
% plot(sig_M)
% 
% subplot(1,2,2)
% plot(M_den)
% 
