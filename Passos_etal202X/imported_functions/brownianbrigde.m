% B = brownianbrigde(N)
% 
% Generate a Brownian Bridge of dimension N
%
% INPUT:
%
% N = dimension of the Brownian bridge
%
% OUTPUT:
% 
% B = Brownian bridge
%
%
%
% Author(s) : Noslen Hernandez (noslenh@gmail.com),
%             Aline Duarte (alineduarte@usp.br)
%
% Date: 05/2019

function B = brownianbrigde(N)

% create Brownian Motion
W = zeros(1,N);
    for i = 2:N
        W(i) = W(i-1) + sqrt(1/(N-1)) * normrnd(0,1);
    end

% create Brownian Bridge
B = zeros(1,N);
    for i = 2:N
        B(i) = W(i) - (1/(N-1)) * (i-1) * W(N);
    end

end