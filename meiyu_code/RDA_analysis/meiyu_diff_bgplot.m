%meiyu_diff_bgplot.m

%written by Jesse Day, February 14th 2015 as a shortened version of
%meiyu_diff_control.m

%edited by Jesse Day, April 2nd 2015, to also test the statistical
%significance of changes using a mobing blocks bootstrap method.

%script that produces Figure 3 of the Meiyu paper, showing the difference
%in Meiyu occurrences and precipitation changes between the time periods of
%1951-1979 and 1980-2007. Also produces the exact same figure except for 
%the time periods 1979-1993 versus 1994-2007.

%relies primarily on Pchina.nc, the longitudinal mean of precip as calculated
%from Ferret over the longitude range 105E-123E. Latitude range is from 
%20N to 40N at quarter degree resolution. Pchina is 80 x 20819 in size

clear all;
close all;


%% PRECIP

P=ncread('Pchina.nc','PCHINA');
P=P';

%%% ASSOCIATE DATE WITH EACH DAY
daynum=zeros(20819,1);

%day hash - now using Jake's convention of naming Jan 1 of each year day 1,
%and ignoring leap years.
for j=1:14
    
    for i=1:4
        
        dmin=1461*(j-1)+365*(i-1)+1;
        dmax=1461*(j-1)+365*i;
        daynum(dmin:dmax)=[1:365];
        
    end
    
    daynum(j*1461) = 366;

end

daynum(20455:20819) = [1:365];



%%% RAINFALL


%%% PART I - changes in rainfall between 1951-1979 and 1980-2007 %%%

Psample_5179=zeros(365,80,29);  %29 years
Psample_8007=zeros(365,80,28);  %28 years

counter=zeros(365,1);


%1951-1979 - days 1-10592; 
for i=1:10592
    
    dd=daynum(i);
    
    if not(dd==366)
        zz=counter(dd)+1;
        Psample_5179(dd,:,zz)=P(i,:);
        counter(dd)=zz;

%         if dd==1
%             dd
%             zz
%             pause
%             P(i,:)
%             pause
%             q=Psample_5179(dd,:,1:zz)
%             pause
% 
%         end
%     
    end
       
end

counter=zeros(365,1);

%1980-2007 - 10593-20819
for i=10593:20819
    
    dd=daynum(i);
    
    if not(dd==366)
        zz=counter(dd)+1;
        Psample_8007(dd,:,zz)=P(i,:);
        counter(dd)=zz;
% 
%         if dd==1
%             dd
%             zz
%             pause
%             P(i,:)
%             pause
%             q=Psample_5179(dd,:,1:zz)
%             pause
% 
%         end
%     
    end
       
end

%MEANS
P_5179=mean(Psample_5179,3); %means over each of the time periods
P_8007=mean(Psample_8007,3);

P_diff=P_8007-P_5179;

%STANDARD DEVIATIONS
P_std=zeros(365,80);

for i=1:365
    
    for j=1:80
        
        
        A=permute(Psample_5179(i,j,:),[3 1 2]);
        B=permute(Psample_8007(i,j,:),[3 1 2]);
        C=[A; B];
        P_std(i,j)=std(C);
        P_diff(i,j);
        P_std(i,j);
        
    end
    
end


%show precipitation changes in units of standard deviation
P_diff_std=zeros(365,80);
P_diff_std=P_diff./P_std;

% contourf(P_diff');
% contourf(P_diff_std')
% pause

%%% SMOOTHING AND SIGNIFICANCE TESTING %%
% the significance testing is done on an individual point and a range of
% its neighbors.

%things that we produce: 
tsmth=7; %include any point within 4 days (9-day filter)
latsmth=0; %include any point within 4 latitude grid boxes (1 degree, 9-point mean)

P_5179_smth=zeros(size(P_5179));
P_8007_smth=zeros(size(P_8007));
P_diff_smth=zeros(size(P_diff));
P_diff_std_smth=zeros(size(P_diff_smth));

pval1=zeros(365,80); %p-value of the change calculated w/permutation test
pval2=zeros(365,80); %same with bootstrapping
pval_blk1=zeros(365,80); %p-value of difference using blocked bootstrapping.
pval_blk2=zeros(365,80); %p-value of difference using blocked bootstrapping.
pval_blk3=zeros(365,80); %p-value of difference using blocked bootstrapping.


for i=1:365
    
    i
            
    for j=1:80
        
        j
        
        mydays=mod([i-tsmth-1:i+tsmth-1],365)+1; %since the indexing starts at 1, not 0
        mylatmin=max(1,j-latsmth);
        mylatmax=min(80,j+latsmth);
        mylats=[mylatmin:mylatmax];
        
        %mydays
        %mylats
        
        Psub_5179=P_5179(mydays,mylats);
        Psub_8007=P_8007(mydays,mylats);
        Psub_diff_std=P_diff_std(mydays,mylats);
        
        P_5179_smth(i,j)=mean(mean(Psub_5179));
        P_8007_smth(i,j)=mean(mean(Psub_8007));
        P_diff_std_smth(i,j)=mean(mean(Psub_diff_std));
        
        %debugging - show included precip values
%         Psub_5179
%         pause
%         Psub_8007
%         pause
%         P_5179_smth(i,j)
%         pause
%         P_8007_smth(i,j)
%         pause
%         P_diff_std_smth(i,j)
%         pause

                
        %% STATISTICAL SIGNIFICANCE
        
        %draw from all values within smoothing range given by tsmth,
        %latsmth
        Ps1=Psample_5179(mydays,mylats,:);
        
        %convert 3D sample into 1D sample to be able to apply existing
        %algorithms.
        m=size(Ps1,1);
        n=size(Ps1,2);
        p=size(Ps1,3);
        s1=zeros(m*n*p,1);
        size(s1);
        
        for ii=1:m
            
            for jj=1:n
                
                base=(((ii-1)*n)+jj-1)*p; %hash that finds 1D position of 3D data
                kmin=base+1;
                kmax=base+p;
                s1(kmin:kmax)=Ps1(ii,jj,:);
                
            end
            
        end

        
        Ps2=Psample_8007(mydays,mylats,:);
        
        m=size(Ps2,1);
        n=size(Ps2,2);
        p=size(Ps2,3);
        s2=zeros(m*n*p,1);
        
        for ii=1:m
            
            for jj=1:n
                
                base=(((ii-1)*n)+jj-1)*p;
                kmin=base+1;
                kmax=base+p;
                s2(kmin:kmax)=Ps2(ii,jj,:);
                
            end
            
        end
        
        ss1=permute(Ps1,[1 3 2]);
        ss2=permute(Ps2,[1 3 2]);
        
        
        %% REGULAR BOOTSTRAPPING
        
        %draw from all values within smoothing range given by tsmth,
        %latsmth
        
        niter=100;
        
        [~,p1,~,~]=myperm(s1',s2',niter);
        [~,p2,~,~,~]=mybs_diff(s1,s2,niter);
%        [~,p3,~,~]=myperm(s11',s22',niter)
%        [~,p4,~,~,~]=mybs_diff(s11,s22,niter)
 
        pval1(i,j)=p1;
        pval2(i,j)=p2;
        
        %% MOVING BLOCKS BOOTSTRAP
        %due to the autocorrelation in rainfall data (tau = 2 days), draws
        %rainfall in blocks of 2 days.
        
        %also important to note that the blocks are autocorrelated only on
        %consecutive days (and obviously not across years!).
        
        %the autocorrelation of rainfall data appears to be roughly 2 days,
        %so we use tau=2 below.
        
        [~,p3,~,~,~]=mybs_diff_blocks_2d(ss1,ss2,niter,1);
        
        [~,p4,~,~,~]=mybs_diff_blocks_2d(ss1,ss2,niter,2);
        
        [~,p5,~,~,~]=mybs_diff_blocks_2d(ss1,ss2,niter,3);

        pval_blk1(i,j)=p3;
        pval_blk2(i,j)=p4;
        pval_blk3(i,j)=p5;

    end
    
end

pause

P_diff_smth=P_8007_smth-P_5179_smth;

contourf(P_diff_smth')
pause


%SAVE NETCDF FILE
daysmth=2*tsmth+1;
savefile=strcat('meiyu_diff_',num2str(daysmth),'.nc')'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%Make netcdf file with correct dimensions
nccreate(savefile,'P_5179','Dimensions',{'time',365,'Y',80})
nccreate(savefile,'P_8007','Dimensions',{'time',365,'Y',80})
nccreate(savefile,'P_diff','Dimensions',{'time',365,'Y',80})

nccreate(savefile,'P_5179_smth','Dimensions',{'time',365,'Y',80})
nccreate(savefile,'P_8007_smth','Dimensions',{'time',365,'Y',80})
nccreate(savefile,'P_diff_smth','Dimensions',{'time',365,'Y',80})

nccreate(savefile,'P_diff_std','Dimensions',{'time',365,'Y',80})
nccreate(savefile,'P_diff_std_smth','Dimensions',{'time',365,'Y',80})

nccreate(savefile,'pval_diff_1','Dimensions',{'time',365,'Y',80})
nccreate(savefile,'pval_diff_2','Dimensions',{'time',365,'Y',80})
nccreate(savefile,'pval_diff_blocks','Dimensions',{'time',365,'Y',80})
nccreate(savefile,'pval_diff_blocks_2','Dimensions',{'time',365,'Y',80})
nccreate(savefile,'pval_diff_blocks_3','Dimensions',{'time',365,'Y',80})




%write variables to file
ncwrite(savefile,'P_5179',P_5179)
ncwrite(savefile,'P_8007',P_8007)
ncwrite(savefile,'P_diff',P_diff)

%ncwrite(savefile,'P_5179_stdv',P_stdv_5179)
%ncwrite(savefile,'P_8007_stdv',P_stdv_8007)
%ncwrite(savefile,'P_diff_stdv',P_stdv_diff)

ncwrite(savefile,'P_5179_smth',P_5179_smth)
ncwrite(savefile,'P_8007_smth',P_8007_smth)
ncwrite(savefile,'P_diff_smth',P_diff_smth)

ncwrite(savefile,'P_diff_std',P_diff_std)
ncwrite(savefile,'P_diff_std_smth',P_diff_std_smth)

ncwrite(savefile,'pval_diff_1',pval1)
ncwrite(savefile,'pval_diff_2',pval2)
ncwrite(savefile,'pval_diff_blocks',pval_blk1)
ncwrite(savefile,'pval_diff_blocks_2',pval_blk2)
ncwrite(savefile,'pval_diff_blocks_3',pval_blk3)



%move the resulting file if necessary
%movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')



%% MEIYU FREQUENCY
%making Figure 2b - showing the change in Meiyu frequency between 1951-1979
%and 1980-2007

meiyu_fq_diff; %run in a separate script so I don't have to run everything that comes before.



%%% PART II - changes in rainfall between 1979-1993 and 1994-2007

