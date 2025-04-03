% [x_aux, hat_fn] = kernel_density(X,range_vec)
%
% DESCRIPTION: % This function estimates the density function by the kernel
% method using a gaussian kernel. X provides the sample from which the den-
% sity will be estimated and range_vec 
%
% INPUT:
%
% X = provides the sample from which the density will be estimated
%
% OUTPUT:
%
% range_vec = contains the datapoints in which the
% function values will be calculated.
%
% AUTHOR: Paulo Roberto Cabral Passos  DATE: 24/02/2025


function [x_aux, hat_fn] = kernel_density(X,range_vec)

x_aux = range_vec; 
x = X;

h_eval = 0.1:0.05:1;
VC_list = zeros(length(h_eval),1);

for a = 1:length(h_eval)
    hn = h_eval(a);
    n = length(x);
    hat_fn = zeros(length(x_aux),1);
    for k = 1:length(x_aux) 
        k_sum = 0;
        for xi = 1:length(x)
        u = (x_aux(k)-x(xi))/hn;
        k_sum = k_sum + (1/sqrt(2*pi))*exp((-u^2)/2);
        end
        hat_fn(k) = (1/(n*hn))*k_sum;
    end
    
    VC_1st_term = trapz(x_aux,hat_fn.^2);
    
    fn_isum = 0;
    for i_dex = 1:length(x)
        fn_minusi = 0;
        for j_dex = 1:length(x)
            if i_dex ~= j_dex
               u = (x(j_dex)-x(i_dex))/hn;
               fn_minusi = fn_minusi +  (1/((n-1)*hn))*(1/sqrt(2*pi))*exp((-u^2)/2);
            end
        end
        fn_isum = fn_isum + fn_minusi;
    end
    VC_2nd_term = (2/n)*fn_isum;
    VC = VC_1st_term - VC_2nd_term;
    VC_list(a,1) = VC;  
end

% So the best representation is:

hn = h_eval(find(VC_list == min(VC_list))); %#ok<FNDSB>
n = length(x);
hat_fn = zeros(length(x_aux),1);
for k = 1:length(x_aux) 
    k_sum = 0;
    for xi = 1:length(x)
    u = (x_aux(k)-x(xi))/hn;
    k_sum = k_sum + (1/sqrt(2*pi))*exp((-u^2)/2);
    end
    hat_fn(k) = (1/(n*hn))*k_sum;
end


end