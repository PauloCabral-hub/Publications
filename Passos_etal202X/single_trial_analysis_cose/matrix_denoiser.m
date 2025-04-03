%[A_den, U, S_den, V] = matrix_denoiser(A)
%
% DESCRIPTION: Given an input matrix, provides the denoised version of the
% matrix applying a threshold based in Donoho and Gavish 2014
%
% INPUT:
%
% A = input matrix
%
% OUTPUT:
%
% A_den = Denoised matrix
% U = matrix of left singular vectors
% S_den = matrix with the singular values
% V = matrix of the right singularo vectors
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 14/02/2025


function [A_den, U, S_den, V] = matrix_denoiser(A)

% To test
%A = [4 2 8; 1 5 6; 3 7 9]';
%A = A + normrnd(0, 0.5, size(A)); % Add Gaussian noise

% Compute SVD
[U, S, V] = svd(A);

% Estimate noise level using median singular value
sigma_noise = median(diag(S)) / sqrt(0.6745);

% Compute threshold tau using Donoho & Gavish formula
tau = sigma_noise * (sqrt(size(A,1)) + sqrt(size(A,2)));

% Apply thresholding
S_den = S .* (S >= tau); % Zero out singular values below threshold

% Reconstruct denoised matrix
A_den = U * S_den * V';

end