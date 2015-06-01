%meiyu_fq_diff.m

%called by meiyu_diff_bgplot.m

%produces figure 2b of the Meiyu paper, which shows the difference in Meiyu
%frequency at each latitude between 1951-1979 and 1980-2007.

%for the purposes of the Meiyu paper, I'll try running this script only
%with 2degrees latitude smoothing, and with either a 9-day or 15-day
%running mean.

clear all;
close all;

hov_5179=ncread('meiyuclimo_5179_final.nc','hov');
hov_8007=ncread('meiyuclimo_8007_final.nc','hov');
fq_5179=100*hov_5179/29;
fq_8007=100*hov_8007/28;

fq_diff=fq_8007-fq_5179;

tsmth=7;
latsmth=2;

%define arrays used subsequently
fq_5179_smth=zeros(20,365);
fq_8007_smth=zeros(20,365);
fq_diff_smth=zeros(20,365);
p=zeros(20,365);


for i=1:365
    
    i
            
    for j=1:20
        
        
        j
        
        mydays=mod([i-tsmth-1:i+tsmth-1],365)+1; %since the indexing starts at 1, not 0
        mylatmin=max(1,j-latsmth);
        mylatmax=min(20,j+latsmth);
        mylats=[mylatmin:mylatmax];
        days=length(mydays);
        lats=length(mylats);
        
        fqsub_5179=fq_5179(mylats,mydays);
        fqsub_8007=fq_8007(mylats,mydays);
        
        fq_5179_smth(j,i)=mean(mean(fqsub_5179));
        fq_8007_smth(j,i)=mean(mean(fqsub_8007));
        
        fq_diff_smth(j,i)=fq_8007_smth(j,i)-fq_5179_smth(j,i);
        
        %IMPORTANT CHANGE - WE NOW USE THE AUTOCORRELATION LENGTH SCALE TAU
        %(roughly tau=1.99) because number of true independent observations
        %is reduced.
        
        tau=1.81; %determined from meiyu_autocorr.m
        
        n1=29*days*lats/tau;
        n2=28*days*lats/tau;
        
        fq1=fq_5179_smth(j,i)/100;
        fq2=fq_8007_smth(j,i)/100;
        dff=fq2-fq1;
                
        %% STATISTICAL SIGNIFICANCE
        var1=fq1*(1-fq1)/n1;
        var2=fq2*(1-fq2)/n2;
        var=var1+var2;
        stdv=var^(1/2);
        
        if stdv~=0
            Z=dff/stdv;
        else
            Z=0;
        end
        
        p(j,i)=normcdf(Z);
        
    end
    
end



%%SAVE NETCDF FILE
daysmth=2*tsmth+1;
savefile=strcat('meiyu_fq_diff_',num2str(daysmth),'day_',num2str(latsmth)', ...
    'deglat.nc');
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%Make netcdf file with correct dimensions
nccreate(savefile,'fq_diff','Dimensions',{'time',365,'Y',20})
nccreate(savefile,'fq_diff_smth','Dimensions',{'time',365,'Y',20})
nccreate(savefile,'p','Dimensions',{'time',365,'Y',20})

%write variables to file
ncwrite(savefile,'fq_diff',fq_diff')
ncwrite(savefile,'fq_diff_smth',fq_diff_smth')
ncwrite(savefile,'p',p')

%move the resulting file if necessary
movefile(savefile,'/Users/Siwen/Desktop/ferret/bin');

