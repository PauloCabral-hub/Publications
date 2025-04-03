% [sig_times, no_correction] = erp_benjyuke(sig_set, alpha)
%
% DESCRIPTION: Using one-sample t-tests, the Benjamini-Yekutieli (2001)
% false discovery rate and a significance level alpha, the function
% indicates the samples in which the event-related potentials deviate
% significantly from zero.
%
% INPUT:
%
% sigset = A matrix with the corresponding ERPs. Each row of the matrix
% presents a different ERP and each line a diferent time sample.
%
% alpha = significance level (0.05 is recommended)
%
% OUTPUT:
%
% sig_times = a vector with the same number of columns of sig_set which
% indicates in which time samples the EPR is signficantly different from
% zero.
% no_correction = those who are significant without multiple correction;
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 26/03/2025


function [sig_times, no_correction] = erp_benjyuke(sig_set, alpha)

% Global Parameters
n = size(sig_set,1);
mu = 0;

s = 10^10;

for b = 1:size(sig_set,2)
   if std(sig_set(:,b)) < s
      s = std(sig_set(:,b));
   end
end


p_vec = zeros(1, size(sig_set,2) );
no_correction = zeros(1, size(sig_set,2) ); 
for a = 1:size(sig_set,2)
    x_bar = mean(sig_set(:,a));
    p = cdf('T',(x_bar-mu)/(s/sqrt(n)),n-1);
    p_vec(1,a) = p;
    if p < alpha
       no_correction(1,a) = 1; 
    end
end

[p_sorted, arrangement] = sort(p_vec);

m = size(sig_set,2);
c_m = log(m)+2.718281+(1/2*m);

threshold_check = zeros( 1, length(p_vec) );
for k = 1:length(p_sorted)
    if p_sorted(k) <= (k*alpha)/(m*c_m)
       threshold_check(1,k) = 1; 
    end
end

sig_times = zeros( 1, length(p_vec) );
for a = 1:length(threshold_check)
   if threshold_check(1,a) == 1
      sig_times( arrangement(a) ) = 1;
   end
end
