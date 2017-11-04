close all;clear;clc;
dim = 2;
pop = 20;
gen = 300;
beta = 1;
cr = 0.3;
minx = -70;
maxx = 70;
a=1;
b=-10;
c=24;
% a=-1;
% b=-21;
% c=72;
X=rand(dim, pop);
X
[fit] = quadMatFit(X, a,b,c);
fitTrack = [];
bestFitUntilNow = 100000;
timetracker = [];

for trial = 1:10
    tic    
for i = 1:gen
    U=[];
for p = 1:pop    
    
    randX= linspace(1,pop,pop);randX(p) = [];
    px1=ceil(rand(1,1)*numel(randX));x1=randX(px1);randX(px1)=[];
    px2=ceil(rand(1,1)*numel(randX));x2=randX(px2);randX(px2)=[];
    px3=ceil(rand(1,1)*numel(randX));x3=randX(px3);randX(px3)=[];
    M = X(:,x1) + beta .* (X(:,x2) - X(:,x3));
    
    %if x1 and x2 are same, perturb it
    if round(M(2)) == round(M(1)), M(1) = floor(2*rand(1,1));end
    if round(M(2)) == round(M(1)), M(1) = floor(2*rand(1,1));end             
    
    tcr = rand(dim,1);
    for t=1:numel(tcr)
        if tcr(t) > cr, M(t) = X(t,p);end
        %if M(t) > maxx, M(t) = maxx;end
        %if M(t) < minx, M(t) = minx;end
        if M(t) > maxx, M(t) = floor(minx+(maxx-minx)*rand(1,1));end
        if M(t) < minx, M(t) = floor(minx+(maxx-minx)*rand(1,1));end 
    end
    
    U=[U M];
    
end    
    [MutantFit] = quadMatFit(U, a,b,c);
   
    for t = 1:numel(MutantFit)
        if MutantFit(t) < fit(t) && MutantFit(t)>=0, 
            X(:,t) = U(:,t); 
            fit(t) = MutantFit(t);
        end
        if MutantFit(t) > fit(t) && MutantFit(t)<0, 
            X(:,t) = U(:,t);
            fit(t) = MutantFit(t);
        end
    end
    
    [bestFitness, loc] = min(fit);
    bestFitness
    loc
    
    beta = beta - 0.01;
    
%      [bestFit, loc] = min(fit);
%     if bestFit < bestFitUntilNow && bestFit >= 0,bestFitUntilNow = bestFit;end    
%     if bestFit > bestFitUntilNow && bestFit < 0,bestFitUntilNow = bestFit;end
%     
%     fitTrack = [fitTrack bestFitUntilNow];
     if trial ==1, fitTrack = [fitTrack;fit];end
    
end
tim = toc;
timetracker=[timetracker tim];
end

fprintf('expected answer %f, %f\n', -b+sqrt(b*b-4*a*c)/2*a, -b-sqrt(b*b-4*a*c)/2*a);
X
r1= a*(X(1,loc)^2)+b*X(1,loc)+c;
r2= a*(X(2,loc)^2)+b*X(2,loc)+c;
fprintf('x1=%f x2=%f. r1=%f r2=%f\n', X(1,loc), X(2,loc), r1, r2);
fprintf('mean of time = %f\n', mean(timetracker));
fprintf('standard deviation of time = %f\n', std(timetracker));

figure(1);clf;
plot(linspace(1,gen,gen),fitTrack(:,:));hold on;
xlabel('generations');
ylabel('fitness');
title('Fitness plot');


