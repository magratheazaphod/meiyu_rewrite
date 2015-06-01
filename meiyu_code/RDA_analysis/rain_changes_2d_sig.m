%rain_changes_2d_sig.m

%written by Jesse Day, April 6th 2015. evaluates statistical significance
%in space of rainfall changes.

clear all

P_year=ncread('APHRO_eastasia_yr.nc','P_YR');

P_prem1=ncread('a1.nc','A');
P_prem2=ncread('a2.nc','A');
P_prem3=ncread('a3.nc','A');
P_postm1=ncread('b1.nc','B');
P_postm2=ncread('b2.nc','B');
P_postm3=ncread('b3.nc','B');


P_prem=zeros(168,112,57);
P_postm=zeros(168,112,57);

P_prem(:,:,1:19)=P_prem1;
P_prem(:,:,20:38)=P_prem2;
P_prem(:,:,39:57)=P_prem3;

P_postm(:,:,1:19)=P_postm1;
P_postm(:,:,20:38)=P_postm2;
P_postm(:,:,39:57)=P_postm3;

P_year_5879=P_year(:,:,8:29);
P_year_8001=P_year(:,:,30:51);

P_prem_5879=P_prem(:,:,8:29);
P_prem_8001=P_prem(:,:,30:51);

P_postm_5879=P_postm(:,:,8:29);
P_postm_8001=P_postm(:,:,30:51);

pval_perm_full=zeros(size(P_year,1),size(P_year,2));
pval_bs_full=zeros(size(P_year,1),size(P_year,2));

pval_perm_prem=zeros(size(P_year,1),size(P_year,2));
pval_bs_prem=zeros(size(P_year,1),size(P_year,2));

pval_perm_postm=zeros(size(P_year,1),size(P_year,2));
pval_bs_postm=zeros(size(P_year,1),size(P_year,2));


niter=1000

%significance calculation
for i=1:size(P_year,1)
        
    for j=1:size(P_year,2)
        
        i
        j
        
        s11=P_year_5879(i,j,:);
        s22=P_year_8001(i,j,:);
        
        s1=permute(s11,[3 1 2]);
        s2=permute(s22,[3 1 2]);
       
        
        [a,p1,c,d]=myperm(s1',s2',niter);
        [a,p2,c,d,e]=mybs_diff(s1,s2,niter);

        pval_perm_full(i,j)=p1;
        pval_bs_full(i,j)=p2;
        
    end
    
end

%significance calculation
for i=1:size(P_year,1)
    
    for j=1:size(P_year,2)
        
        i
        j
        
        s11=P_prem_5879(i,j,:);
        s22=P_prem_8001(i,j,:);
        
        s1=permute(s11,[3 1 2]);
        s2=permute(s22,[3 1 2]);
       
        [a,p1,c,d]=myperm(s1',s2',niter);
        [a,p2,c,d,e]=mybs_diff(s1,s2,niter);

        pval_perm_prem(i,j)=p1;
        pval_bs_prem(i,j)=p2;
        
    end
    
end

%significance calculation
for i=1:size(P_year,1)
    
    for j=1:size(P_year,2)
        
        i
        j
        
        s11=P_postm_5879(i,j,:);
        s22=P_postm_8001(i,j,:);
        
        s1=permute(s11,[3 1 2]);
        s2=permute(s22,[3 1 2]);
       
        
        [a,p1,c,d]=myperm(s1',s2',niter);
        [a,p2,c,d,e]=mybs_diff(s1,s2,niter);

        pval_perm_postm(i,j)=p1;
        pval_bs_postm(i,j)=p2;
        
    end
    
end

%save results
savefile='rain_changes_2d_sig.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

nccreate(savefile,'pval_perm_full','Dimensions',{'X',168,'Y',112})
nccreate(savefile,'pval_perm_prem','Dimensions',{'X',168,'Y',112})
nccreate(savefile,'pval_perm_postm','Dimensions',{'X',168,'Y',112})
nccreate(savefile,'pval_bs_full','Dimensions',{'X',168,'Y',112})
nccreate(savefile,'pval_bs_prem','Dimensions',{'X',168,'Y',112})
nccreate(savefile,'pval_bs_postm','Dimensions',{'X',168,'Y',112})

ncwrite(savefile,'pval_perm_full',pval_perm_full)
ncwrite(savefile,'pval_perm_prem',pval_perm_prem)
ncwrite(savefile,'pval_perm_postm',pval_perm_postm)
ncwrite(savefile,'pval_bs_full',pval_bs_full)
ncwrite(savefile,'pval_bs_prem',pval_bs_prem)
ncwrite(savefile,'pval_bs_postm',pval_bs_postm)