function [av,l2s,u2s]=mybs_blocks(sample,subsampsize,niter,blklen)

%uses bootstrapping with replacement to nonparametrically determine the standard deviation
%of the means of samples. In addition, allows for MOVING BLOCK
%functionality where random samples are drawn in units of blklen.

%one issue that should be fixed - the increment for finding the cumulative
%distribution is set to .001, whereas in reality it should be some fraction
%of the average (like 1/1000 or 1/10000). however, not relevant to my
%purposes

%case-tested for a binary probability distribution, in which case it
%reproduces the analytic solution correctly.

sampsize=length(sample);
avs=zeros(niter,1);

for i=1:niter
    
    mysamp=zeros(subsampsize,1);
    
    for j=1:blklen:subsampsize
        
        jmax=j+blklen-1;
        
        if jmax>subsampsize
            
            jmax=subsampsize;
            
        end
        
        myblklen=jmax-j+1;
        sampmax=sampsize-myblklen+1;
   
        myr=mod(round(rand*sampmax),sampmax)+1;
        mysamp(j:jmax)=sample(myr:myr+myblklen-1);
    
    end
    
    avs(i)=mean(mysamp);
    
end
    
av=mean(avs);


%2 sigma:
st=av;
frac=sum(avs<st)/niter;


while frac>.025
    
    st=st-.001;
    frac=sum(avs<st)/niter;

end

l2s=st;

st=av;
frac=sum(avs<st)/niter;

while frac<.975
    
    st=st+.001;
    frac=sum(avs<st)/niter;

end

u2s=st;