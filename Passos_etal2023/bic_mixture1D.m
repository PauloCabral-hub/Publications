% [model_repo, bic_list, droped] = bic_mixture1D(X, maxcomp)
%
% This function returns the mixture model estimation for the univariate
% data in X.
%
% Input:
% X = vector containing the data to be modelled as a mixture
% maxcomp = maximum number of components
% 
% Output:
% model_repo = cell structure in which each line i corresponds to data for
% the mixture containing i components. The content of each column is the
% following:
% 1- Means of each component;
% 2- Variance of each component;
% 3- Mixture coefficients in the mixture;
% 4- Log likelihood;
% 5- number of iterations for the model estimation;
% 6- x values for graphing the density;
% 7- density function on x values;
% bic_list = list of the baysian information criterion for each of the
% number of components.
% droped = vector containing 1 for cases in which the modelling was not possible.
%
% Author: Paulo Roberto Cabral Passos Date: 09/06/2022

function  [model_repo, bic_list, dropped] = bic_mixture1D(X, maxcomp)

dropped = zeros(maxcomp,1);
model_repo = cell(maxcomp,7); 
bic_list = zeros(maxcomp,1);

% QUICK REFERENCE:
%   1- Means of each component;
%   2- Variance of each component;
%   3- Mixture coefficients in the mixture;
%   4- Log likelihood;
%   5- number of iterations for the model estimation;
%   6- x values for graphing the density;
%   7- density function on x values;


w_bar = waitbar(0,'Performing Calculations');

    for c = 1:maxcomp
        % Initial Guesses
        mu = zeros(1,c);
        Sig = zeros(1,c);
        % IN EVALUATION
        klusts = kmeans(X,c);  
        discard = zeros(length(X),1);
        for k = 1:c
            aux = sum(klusts == k);
            if aux <= 1
               discard(find(klusts == k)) = 1;  %#ok<FNDSB>
               dropped(c,1) = 1; 
            end
        end
        if dropped(c,1) == 1
            for the_rest = c:maxcomp
               dropped(the_rest) = 1; 
            end
            disp(['warning: unable to model data with ' num2str(c) ' components.'] )
            break;
        end
        % IN EVALUATION
        for k = 1:c
             mu(k) = mean(  X( find(klusts == k) )  ); %#ok<FNDSB>
             Sig(k) = std(  X( find(klusts == k) )  )^2; %#ok<FNDSB>
             mix(k) = sum(klusts == c)/length(klusts); %#ok<AGROW>
        end

        % Initializing other parameters
        K = length(mix);
        N = length(X);
        L = 10^6; it = 0;
        Gamma_znk = zeros(N,K);
    % Calcultions
        while (1)&&(it<5000)
            % Calculating the log-likelihood
            first_sum = 0;
            for n = 1:N
               second_sum = 0;
               for k = 1:K
                  second_sum = second_sum + mix(k)*pdf('Normal',X(n),mu(k), sqrt(Sig(k)) );
               end
               first_sum = first_sum + log(second_sum);
            end
            deltaL = abs(first_sum - L);
            if (deltaL < 0.0000001)||isnan(deltaL)
                L = first_sum; 
                break
            end
            L = first_sum;
        %   Calculating gamma(z_nk)
            for n = 1:N
               den_sum = 0;
               for j = 1:K
               den_sum = den_sum + mix(j)*pdf('Normal', X(n) , mu(j) , sqrt(Sig(j)) );
               end
               for k = 1:K
               Gamma_znk(n,k) = (  mix(k)*pdf( 'Normal', X(n) , mu(k),  sqrt(Sig(k)) ) )/den_sum;     
               end
            end
            % Calculating Nk
            Nk = sum(Gamma_znk,1);
            % Calculating Mu
            for k = 1:K
               munew_sum = 0;
               for n = 1:N
                  munew_sum = munew_sum + Gamma_znk(n,k)*X(n);
               end
               mu(k) = (1/Nk(k))*munew_sum;
            end
            % Calculating Sig
            for k = 1:K
                signew_sum = 0;
                for n =1:N
                   signew_sum = signew_sum + Gamma_znk(n,k)*( X(n)^2 - mu(k)^2 ); 
                end
                Sig(k) = ( 1/Nk(k) )*signew_sum;
                mix(k) = Nk(k)/N;
            end
            it = it+1;
        end

        ll = min(X)-std(X); rr = max(X)+std(X);
        x = [ll:0.01: rr]';
        fxk_est = zeros(length(x),K);
        for k = 1:K
           fxk_est(:,k) = mix(k)*normpdf(x,mu(k),sqrt(Sig(k))); 
        end
        fx_est = sum(fxk_est,2);

        bic = 2*L-log(n)*( length(mu) + length(Sig) + length(mix) ); % equation of the bic creterion for one dimension

        model_repo{c,1}=mu; model_repo{c,2}=Sig;
        model_repo{c,3}=mix; model_repo{c,4} = L;
        model_repo{c,5}=it; model_repo{c,6}=x;
        model_repo{c,7}=fx_est; 
        bic_list(c) = bic;
        waitbar(c/maxcomp,w_bar,'Performing Calculations')
    end
close(w_bar)
end
