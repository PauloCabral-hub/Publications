% [alfa, beta,r, tcrit, tcalc, p] = slinearwithpear(predictor,predicted, alpha)
%
% Performs a simple linear regression, gives the pearson correlation
% coefficint and the parameters of the significance test.
% predictor = row vector with the data of the predictor
% predicted = row vector with the data that should be predicted
% alpha = level of significance for the t-test
% alfa = alfa coefficient of the linear regression (alfa + beta*predictor)
% beta = beta coefficient of the linear regression (alfa + beta*predictor)
% tcrit = t critical value for the t-test given the significance level
% cook = if 1, performs a Cook's test for excluding outliers.
% D = column vector with Cook's distance for each sample.
% alpha
% tcalc = t-value calculated for the correlation coefficient.
% p = p-value of the test.


function [alfa, beta,r, tcrit, tcalc, p, D] = slinearwithpear(predictor,predicted, alpha, cook)

xmean = mean(predictor);
ymean = mean(predicted);

num_a = predictor - xmean;
num_b = predicted - ymean;
num = sum(num_a*num_b');
den_a = sum(num_a.^(2));

beta = num/den_a;
alfa = ymean - beta*xmean;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

den_b = sum(num_b.^(2));
denr = sqrt(den_a*den_b);

r = num/denr;

[tcrit,tcalc, p] = testing_r(r, length(predictor),alpha);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if cook == 1

MSE = sum(  ( (alfa + beta.*predictor)-predicted ).^2  )/length(predictor);
k = 2;

D = zeros(length(predicted),1);
pos = [1:length(predictor)];
for o = 1:length(predictor)
    x = predictor(1, find(pos~=o) );
    y = predicted(1, find(pos~=o) );
    [b0, b1,r2, tcrit2, tcalc2, p2, something] = slinearwithpear(x,y, 0.05, 0);
    D(o,1) = sum(  ( (alfa + beta.*predictor) - (b0 + b1.*predictor) ).^2  )/k*MSE;
    
end

threshold = fcdf(0.95,2,(length(predictor)-2))*ones(length(predictor),1);
valid = find(D<threshold);
disp(['Only ' num2str(length(valid)) ' left!'])
[alfa, beta,r, tcrit, tcalc, p, ~] = slinearwithpear(predictor(valid),predicted(valid), 0.05, 0);

else
D = 0;
end

end