function [actualdiff,p,testmean,testdev] = myperm(s1,s2,niter)
    
%myperm.m, written by Jesse Day October 29th 2014. Uses a permutation test
%to determine the statistical significance of difference in means between
%two populations.

%s1 is sample 1, s2 is sample 2. ps refers to permuted sample

diffs=zeros(niter,1);
n1=length(s1);
n2=length(s2);
n=n1+n2; %total number of samples to rearrange
s=[s1 s2];

for i=1:niter
    
    order=randperm(n);
    ps1=s(order(1:n1));
    ps2=s(order(n1+1:n));
    diffs(i)=mean(ps2)-mean(ps1);
    
end

testmean=mean(diffs);
testdev=std(diffs);
actualdiff=mean(s2)-mean(s1);
ndiff=sum(actualdiff>diffs);
p=(ndiff+1)/(niter+1); %obtains an unbiased estimator

%histogram of means versus actual value
%histogram(diffs)