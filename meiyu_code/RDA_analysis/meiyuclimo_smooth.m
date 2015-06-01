%meiyuclimo_smooth.m

%written by Jesse Day, February 19th 2015 - outputs smoothed versions of
%the Meiyu climatology contained in meiyuclimo_final.nc. THe resulting
%files are saved in a format that reflects how they were smoothed in time
%and space (although the spatial smoothing is only relevant for the
%Hovmoller plot).

%%PREFERRED FOR THE PURPOSES OF THE MEIYU PAPER: 9-day running mean and
%%2-degree latitude smoothing - looks nicest without obscuring too much
%%actual variability. However, DIFFERENCES are shown with a 15-day
%%smoothing for greater coherence.

clear all; close all;

tsmth=4; %4 days before and after, so 9 day
latsmth=2;

%% LOADING VARIABLES from meiyuclimo_final.nc
loadfile='meiyuclimo_final.nc';

hov=ncread(loadfile,'hov')';
freq1=ncread(loadfile,'freq1');
freq2=ncread(loadfile,'freq2');
avmean=ncread(loadfile,'avmean');
avmed=ncread(loadfile,'avmed');
len=ncread(loadfile,'len');
tilt=ncread(loadfile,'tilt');
width=ncread(loadfile,'width');

%define new variables
hov_smth=zeros(365,20);
freq1_smth=zeros(365,1);
freq2_smth=zeros(365,1);
avmean_smth=zeros(365,1);
avmed_smth=zeros(365,1);
len_smth=zeros(365,1);
tilt_smth=zeros(365,1);
width_smth=zeros(365,1);


%% LOAD RAINFALL - averaged over 100-123E, latitudes 20-40N
P=ncread('meiyudingchan_updated.nc','P')';
P_smth=zeros(365,80);

for dd=1:365
    
    mydays=mod([dd-tsmth-1:dd+tsmth-1],365)+1; %since the indexing starts at 1, not 0
    
    
    for j=1:80
    %smoothing in latitude of precipitation - in fact, should be 0 degrees,
    %but leaving the option just in case
        
        mylatmin=max(1,j-latsmth);
        mylatmax=min(80,j+latsmth);
        mylats=[mylatmin:mylatmax];

        P_smth(dd,j)=mean(mean(P(mydays,mylats)));
    end
        
        
    for jj=1:20
    %the only other variable with latitudinal smoothing is hov.
    
        mylatmin=max(1,jj-latsmth);
        mylatmax=min(20,jj+latsmth);
        mylats=[mylatmin:mylatmax];

        hov_smth(dd,jj)=mean(mean(hov(mydays,mylats)));
        
    end

    
    freq1_smth(dd)=100*mean(freq1(mydays));
    freq2_smth(dd)=100*mean(freq2(mydays));
    avmean_smth(dd)=mean(avmean(mydays));
    avmed_smth(dd)=mean(avmed(mydays));
    len_smth(dd)=mean(len(mydays));
    tilt_smth(dd)=mean(tilt(mydays));
    width_smth(dd)=mean(width(mydays));
    
end
   
%%SAVING - all years
mysmth=2*tsmth+1;
savefile=strcat('meiyuclimo_final_smooth_',num2str(mysmth),'day_', ...
    num2str(latsmth),'deg.nc')

deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create variables
%nccreate(savefile,'P','Dimensions',{'Y',80,'time',365})
nccreate(savefile,'hov','Dimensions',{'Y',20,'time',365})
nccreate(savefile,'freq1','Dimensions',{'time',365})
nccreate(savefile,'freq2','Dimensions',{'time',365})
nccreate(savefile,'avmean','Dimensions',{'time',365})
nccreate(savefile,'avmed','Dimensions',{'time',365})
nccreate(savefile,'len','Dimensions',{'time',365})
nccreate(savefile,'tilt','Dimensions',{'time',365})
nccreate(savefile,'width','Dimensions',{'time',365})

%write variables
%ncwrite(savefile,'P',P_smth')
ncwrite(savefile,'hov',hov_smth')
ncwrite(savefile,'freq1',freq1_smth)
ncwrite(savefile,'freq2',freq2_smth)
ncwrite(savefile,'avmean',avmean_smth)
ncwrite(savefile,'avmed',avmed_smth)
ncwrite(savefile,'len',len_smth)
ncwrite(savefile,'tilt',tilt_smth)
ncwrite(savefile,'width',width_smth)

movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')