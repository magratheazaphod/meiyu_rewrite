function [actualdiff,p,testmean,testdev,Zscore] = mybs_diff_blocks_2d(s1,s2,niter,blklen)

%edited April 2nd 2015 to allow for selection of data in blocks. In
%particular, the samples are now 2-dimensional (s1 and s2) where blocks are
%chosen along the time dimension, but not across the other dimension.

%mybs_diff.m. written by Jesse Day October 29th 2014. A complementary
%technique to myperm.m, which uses a permutation test (no replacement) to
%determine whether a shift in mean between two populations is statistically
%significant or not.

[m1 n1]=size(s1);
[m2 n2]=size(s2);
s1_avs=zeros(niter,1);
s2_avs=zeros(niter,1);
diffs=zeros(niter,1);

for i=1:niter
    
    bs1=zeros(m1,n1);
    bs2=zeros(m1,n1);
    
    for k=1:n1
    
        for j=1:blklen:m1

            jmax=j+blklen-1;

            if jmax>m1
                jmax=m1;
            end

            myblklen=jmax-j+1;
            mmax=m1-myblklen+1;
           
            r1=mod(round(rand*mmax),mmax)+1;
            r2=mod(round(rand*n1),n1)+1;
            bs1(j:jmax,k)=s1(r1:r1+myblklen-1,r2);

        end
     
    end
        
    for k=1:n2
    
        for j=1:blklen:m2

            jmax=j+blklen-1;

            if jmax>m2
                jmax=m2;
            end

            myblklen=jmax-j+1;
            mmax=m2-myblklen+1;
           
            r1=mod(round(rand*mmax),mmax)+1;
            r2=mod(round(rand*n2),n2)+1;
            bs2(j:jmax,k)=s2(r1:r1+myblklen-1,r2);

        end
     
    end
    
    s1_avs(i)=mean(mean(bs1));
    s2_avs(i)=mean(mean(bs2));
    diffs(i)=s2_avs(i)-s1_avs(i);
%     diffs(1:i)
%     pause
    
end

actualdiff=mean(mean(s2))-mean(mean(s1));
ndiff=sum(diffs>0);
p=(ndiff+1)/(niter+1); %obtains an unbiased estimator
testmean=mean(diffs);
testdev=std(diffs);
Zscore=testmean/testdev;

%extra verification module
% histogram(diffs);
% mean1=mean(s1_avs);
% dev1=std(s1_avs);
% mean2=mean(s2_avs);
% dev2=std(s2_avs);
% sampdev=(dev1^2/niter+dev2^2/niter)^(1/2);
% trudev=sampdev*niter^(1/2);
% pause
% testdev;
% pause
