function [actualdiff,p,testmean,testdev,Zscore] = mybs_diff(s1,s2,niter)

%mybs_diff.m. written by Jesse Day October 29th 2014. A complementary
%technique to myperm.m, which uses a permutation test (no replacement) to
%determine whether a shift in mean between two populations is statistically
%significant or not.

n1=length(s1);
n2=length(s2);
s1_avs=zeros(niter,1);
s2_avs=zeros(niter,1);
diffs=zeros(niter,1);

for i=1:niter
    
    bs1=zeros(size(s1));
    bs2=zeros(size(s2));
    
    for j=1:n1
        
        myr=mod(round(rand*n1),n1)+1;
        bs1(j)=s1(myr);
        
    end    
        
    for j=1:n2
        
        myr=mod(round(rand*n2),n2)+1;
        bs2(j)=s2(myr);
        
    end
    
    s1_avs(i)=mean(bs1);
    s2_avs(i)=mean(bs2);
    diffs(i)=s2_avs(i)-s1_avs(i);
%     diffs(1:i)
%     pause
    
end

actualdiff=mean(s2)-mean(s1);
ndiff=sum(diffs>0);
p=(ndiff+1)/(niter+1); %obtains an unbiased estimator
testmean=mean(diffs);
testdev=std(diffs);
Zscore=testmean/testdev;

%extra verification module
%histogram(diffs);
%mean1=mean(s1_avs);
%dev1=std(s1_avs);
%mean2=mean(s2_avs);
%dev2=std(s2_avs);
%sampdev=(dev1^2/niter+dev2^2/niter)^(1/2);
%trudev=sampdev*niter^(1/2);
%pause
%testdev;
%pause