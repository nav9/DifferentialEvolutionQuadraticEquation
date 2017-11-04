function [fit] = quadMatFit(X, a,b,c)
fit = [];

for i = 1:size(X,2)
    r1= a*(X(1,i)^2)+b*X(1,i)+c;
    r2= a*(X(2,i)^2)+b*X(2,i)+c;
    sum = abs(r1)+abs(r2);
    fit = [fit sum];
end
