% [tcrit, tcalc, p] = testing_r(r, N, alpha)
%
% The function returns the probability of the correlation coefficent being
% significant.
% tcrit = critical value of the t-distribution given the alpha level of
% significance and the degrees of freedom.
% tcalc = the value of the t-distribution for the correlation coefficient
% and the degrees of freedom.
% p = p-value of the test
% alpha = the level of significance of the test.
% N the number of samples of the correlation.
% r = the correlation value.


function [tcrit, tcalc, p] = testing_r(r, N, alpha)
Tp = 1-alpha; 
df = N-2;

tcrit = tinv(Tp,df);
tcalc = abs(r)*sqrt(df/(1-r^2));
p = 1-tcdf(tcalc,df);


end