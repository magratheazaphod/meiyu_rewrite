%meiyuclimo_build.m

%A new version of meiyuhov.m, written by Jesse Day August 27th 2014, run
%again with Jake's new date hash on January 13th 2015. Further updated on
%February 9th, 2015 to reproduce the exact same climatology, only also
%reporting the mean latitude of meiyu events on each day.


%% UPDATED ONE FINAL TIME March 18th 2015 - also produces Meiyu climatology
%for 1958-1979 and 1980-2001 - need to be able to compare front occupancy
%for the time two periods for the sidebars of figure 4.


%Now relies on meiyustats_new.m to ease calculation. Produces a daily
%climatology of key variables.

%creates Hovmoller plots of occupancy for all years, 1951-1979 and
%1980-2007. Also creates graphs of occupancy and mean intensity, with 
%uncertainties where possible.

clear all
close all

%%DEFINE VARIABLES

%hov variables - counter of what latitudes are occupied between 20N-40N

%the relevant output variable is all3{6}, which gives a joint latitude 
%occupancy of primary and secondary events

%DIFFERENCE from previous version - also includes secondary Meiyu events.
hov=zeros(365,20);
hov_5179=zeros(365,20);
hov_8007=zeros(365,20);
hov_5879=zeros(365,20);
hov_8001=zeros(365,20);

%frequency of primary Meiyu events
freq1=zeros(365,1);
freq1_5179=zeros(365,1);
freq1_8007=zeros(365,1);
freq1_5879=zeros(365,1);
freq1_8001=zeros(365,1);
freq1dev=zeros(365,1);
freq1dev_5179=zeros(365,1);
freq1dev_8007=zeros(365,1);
freq1dev_5879=zeros(365,1);
freq1dev_8001=zeros(365,1);

%frequency of secondary Meiyu events
freq2=zeros(365,1);
freq2_5179=zeros(365,1);
freq2_8007=zeros(365,1);
freq2_5879=zeros(365,1);
freq2_8001=zeros(365,1);

%mean latitude of Meiyu events
lat=zeros(365,1)
lat_5179=zeros(365,1)
lat_8007=zeros(365,1)
lat_5879=zeros(365,1)
lat_8001=zeros(365,1)

%intensity metrics 

%means - given by output all4{11}
avmean=zeros(365,1);
avmean_5179=zeros(365,1);
avmean_8007=zeros(365,1);
avmean_5879=zeros(365,1);
avmean_8001=zeros(365,1);

%medians - given by output all4{1}
avmed=zeros(365,1);
avmed_5179=zeros(365,1);
avmed_8007=zeros(365,1);
avmed_5879=zeros(365,1);
avmed_8001=zeros(365,1);

%error bars
%+1 sigma - given by output all4{2}
avmed_plus1=zeros(365,1);
avmed_plus1_5179=zeros(365,1);
avmed_plus1_8007=zeros(365,1);
avmed_plus1_5879=zeros(365,1);
avmed_plus1_8001=zeros(365,1);

%-1 sigma
avmed_minus1=zeros(365,1);
avmed_minus1_5179=zeros(365,1);
avmed_minus1_8007=zeros(365,1);
avmed_minus1_5879=zeros(365,1);
avmed_minus1_8001=zeros(365,1);

%mode averages - given by output all4{12}
avmode=zeros(365,1);
avmode_5179=zeros(365,1);
avmode_8007=zeros(365,1);
avmode_5879=zeros(365,1);
avmode_8001=zeros(365,1);

%length
len=zeros(365,1);
len_5179=zeros(365,1);
len_8007=zeros(365,1);
len_5879=zeros(365,1);
len_8001=zeros(365,1);

%tilt
tilt=zeros(365,1);
tilt_5179=zeros(365,1);
tilt_8007=zeros(365,1);
tilt_5879=zeros(365,1);
tilt_8001=zeros(365,1);

%width
width=zeros(365,1);
width_5179=zeros(365,1);
width_8007=zeros(365,1);
width_5879=zeros(365,1);
width_8001=zeros(365,1);



%%MAIN LOOP - go day by day, find stats

for i=1:365
    
    i
    tic
    
    [all1,all2,all3,all4,all5,all6,all7]= ...
        meiyustats_new(i,i,1951,2007,0,0);
    hov(i,:)=all3{6};
    freq1(i)=all1{1};
    freq1dev(i)=all1{2};
    freq2(i)=all2{1};
    lat(i)=all3{1}
    avmean(i)=all4{11};
    avmed(i)=all4{1};
    avmed_plus1(i)=all4{2};
    avmed_minus1(i)=all4{13};
    avmode(i)=all4{12};
    len(i)=all5{1};
    tilt(i)=all6{1};
    width(i)=all7{1};
        
    [first1,first2,first3,first4,first5,first6,first7]= ...
        meiyustats_new(i,i,1951,1979,0,0);
    hov_5179(i,:)=first3{6};
    freq1_5179(i)=first1{1};
    freq1dev_5179(i)=first1{2};
    freq2_5179(i)=first2{1};
    lat_5179(i)=first3{1}
    avmean_5179(i)=first4{11};
    avmed_5179(i)=first4{1};
    avmed_plus1_5179(i)=first4{2};
    avmed_minus1_5179(i)=first4{13};
    avmode_5179(i)=first4{12};
    len_5179(i)=first5{1};
    tilt_5179(i)=first6{1};
    width_5179(i)=first7{1};
    
    [last1,last2,last3,last4,last5,last6,last7]= ...
        meiyustats_new(i,i,1980,2007,0,0);
    hov_8007(i,:)=last3{6};
    freq1_8007(i)=last1{1};
    freq1dev_8007(i)=last1{2};
    freq2_8007(i)=last2{1};
    lat_8007(i)=last3{1}
    avmean_8007(i)=last4{11};
    avmed_8007(i)=last4{1};
    avmed_plus1_8007(i)=last4{2};
    avmed_minus1_8007(i)=last4{13};
    avmode_8007(i)=last4{12};
    len_8007(i)=last5{1};
    tilt_8007(i)=last6{1};
    width_8007(i)=last7{1};
    
    [early1,early2,early3,early4,early5,early6,early7]= ...
        meiyustats_new(i,i,1958,1979,0,0);
    hov_5879(i,:)=early3{6};
    freq1_5879(i)=early1{1};
    freq1dev_5879(i)=early1{2};
    freq2_5879(i)=early2{1};
    lat_5879(i)=early3{1}
    avmean_5879(i)=early4{11};
    avmed_5879(i)=early4{1};
    avmed_plus1_5879(i)=early4{2};
    avmed_minus1_5879(i)=early4{13};
    avmode_5879(i)=early4{12};
    len_5879(i)=early5{1};
    tilt_5879(i)=early6{1};
    width_5879(i)=early7{1};
    
    [late1,late2,late3,late4,late5,late6,late7]= ...
        meiyustats_new(i,i,1980,2001,0,0);
    hov_8001(i,:)=late3{6};
    freq1_8001(i)=late1{1};
    freq1dev_8001(i)=late1{2};
    freq2_8001(i)=late2{1};
    lat_8001(i)=late3{1}
    avmean_8001(i)=late4{11};
    avmed_8001(i)=late4{1};
    avmed_plus1_8001(i)=late4{2};
    avmed_minus1_8001(i)=late4{13};
    avmode_8001(i)=late4{12};
    len_8001(i)=late5{1};
    tilt_8001(i)=late6{1};
    width_8001(i)=late7{1};
    
    toc

end

%contourf(hov)


%%SAVING - all years
savefile='meiyuclimo_final.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create variables
nccreate(savefile,'hov','Dimensions',{'lats',20,'time',365})
nccreate(savefile,'freq1','Dimensions',{'time',365})
nccreate(savefile,'freq1dev','Dimensions',{'time',365})
nccreate(savefile,'freq2','Dimensions',{'time',365})
nccreate(savefile,'avmean','Dimensions',{'time',365})
nccreate(savefile,'avmed','Dimensions',{'time',365})
nccreate(savefile,'avmed_plus1','Dimensions',{'time',365})
nccreate(savefile,'avmed_minus1','Dimensions',{'time',365})
nccreate(savefile,'avmode','Dimensions',{'time',365})
nccreate(savefile,'len','Dimensions',{'time',365})
nccreate(savefile,'tilt','Dimensions',{'time',365})
nccreate(savefile,'width','Dimensions',{'time',365})

%write variables
ncwrite(savefile,'hov',hov')
ncwrite(savefile,'freq1',freq1)
ncwrite(savefile,'freq1dev',freq1dev)
ncwrite(savefile,'freq2',freq2)
ncwrite(savefile,'avmean',avmean)
ncwrite(savefile,'avmed',avmed)
ncwrite(savefile,'avmed_plus1',avmed_plus1)
ncwrite(savefile,'avmed_minus1',avmed_minus1)
ncwrite(savefile,'avmode',avmode)
ncwrite(savefile,'len',len)
ncwrite(savefile,'tilt',tilt)
ncwrite(savefile,'width',width)

movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')


%%1951-1979
savefile='meiyuclimo_5179_final.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create variables
nccreate(savefile,'hov','Dimensions',{'lats',20,'time',365})
nccreate(savefile,'freq1','Dimensions',{'time',365})
nccreate(savefile,'freq1dev','Dimensions',{'time',365})
nccreate(savefile,'freq2','Dimensions',{'time',365})
nccreate(savefile,'avmean','Dimensions',{'time',365})
nccreate(savefile,'avmed','Dimensions',{'time',365})
nccreate(savefile,'avmed_plus1','Dimensions',{'time',365})
nccreate(savefile,'avmed_minus1','Dimensions',{'time',365})
nccreate(savefile,'avmode','Dimensions',{'time',365})
nccreate(savefile,'len','Dimensions',{'time',365})
nccreate(savefile,'tilt','Dimensions',{'time',365})
nccreate(savefile,'width','Dimensions',{'time',365})

%write variables
ncwrite(savefile,'hov',hov_5179')
ncwrite(savefile,'freq1',freq1_5179)
ncwrite(savefile,'freq1dev',freq1dev_5179)
ncwrite(savefile,'freq2',freq2_5179)
ncwrite(savefile,'avmean',avmean_5179)
ncwrite(savefile,'avmed',avmed_5179)
ncwrite(savefile,'avmed_plus1',avmed_plus1_5179)
ncwrite(savefile,'avmed_minus1',avmed_minus1_5179)
ncwrite(savefile,'avmode',avmode_5179)
ncwrite(savefile,'len',len_5179)
ncwrite(savefile,'tilt',tilt_5179)
ncwrite(savefile,'width',width_5179)

movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')

%%1980-2007
savefile='meiyuclimo_8007_final.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create variables
nccreate(savefile,'hov','Dimensions',{'lats',20,'time',365})
nccreate(savefile,'freq1','Dimensions',{'time',365})
nccreate(savefile,'freq1dev','Dimensions',{'time',365})
nccreate(savefile,'freq2','Dimensions',{'time',365})
nccreate(savefile,'avmean','Dimensions',{'time',365})
nccreate(savefile,'avmed','Dimensions',{'time',365})
nccreate(savefile,'avmed_plus1','Dimensions',{'time',365})
nccreate(savefile,'avmed_minus1','Dimensions',{'time',365})
nccreate(savefile,'avmode','Dimensions',{'time',365})
nccreate(savefile,'len','Dimensions',{'time',365})
nccreate(savefile,'tilt','Dimensions',{'time',365})
nccreate(savefile,'width','Dimensions',{'time',365})

%write variables
ncwrite(savefile,'hov',hov_8007')
ncwrite(savefile,'freq1',freq1_8007)
ncwrite(savefile,'freq1dev',freq1dev_8007)
ncwrite(savefile,'freq2',freq2_8007)
ncwrite(savefile,'avmean',avmean_8007)
ncwrite(savefile,'avmed',avmed_8007)
ncwrite(savefile,'avmed_plus1',avmed_plus1_8007)
ncwrite(savefile,'avmed_minus1',avmed_minus1_8007)
ncwrite(savefile,'avmode',avmode_8007)
ncwrite(savefile,'len',len_8007)
ncwrite(savefile,'tilt',tilt_8007)
ncwrite(savefile,'width',width_8007)

movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')


%%1958-1979
savefile='meiyuclimo_5879_final.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create variables
nccreate(savefile,'hov','Dimensions',{'lats',20,'time',365})
nccreate(savefile,'freq1','Dimensions',{'time',365})
nccreate(savefile,'freq1dev','Dimensions',{'time',365})
nccreate(savefile,'freq2','Dimensions',{'time',365})
nccreate(savefile,'avmean','Dimensions',{'time',365})
nccreate(savefile,'avmed','Dimensions',{'time',365})
nccreate(savefile,'avmed_plus1','Dimensions',{'time',365})
nccreate(savefile,'avmed_minus1','Dimensions',{'time',365})
nccreate(savefile,'avmode','Dimensions',{'time',365})
nccreate(savefile,'len','Dimensions',{'time',365})
nccreate(savefile,'tilt','Dimensions',{'time',365})
nccreate(savefile,'width','Dimensions',{'time',365})

%write variables
ncwrite(savefile,'hov',hov_5879')
ncwrite(savefile,'freq1',freq1_5879)
ncwrite(savefile,'freq1dev',freq1dev_5879)
ncwrite(savefile,'freq2',freq2_5879)
ncwrite(savefile,'avmean',avmean_5879)
ncwrite(savefile,'avmed',avmed_5879)
ncwrite(savefile,'avmed_plus1',avmed_plus1_5879)
ncwrite(savefile,'avmed_minus1',avmed_minus1_5879)
ncwrite(savefile,'avmode',avmode_5879)
ncwrite(savefile,'len',len_5879)
ncwrite(savefile,'tilt',tilt_5879)
ncwrite(savefile,'width',width_5879)

movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')

%%1980-2001
savefile='meiyuclimo_8001_final.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create variables
nccreate(savefile,'hov','Dimensions',{'lats',20,'time',365})
nccreate(savefile,'freq1','Dimensions',{'time',365})
nccreate(savefile,'freq1dev','Dimensions',{'time',365})
nccreate(savefile,'freq2','Dimensions',{'time',365})
nccreate(savefile,'avmean','Dimensions',{'time',365})
nccreate(savefile,'avmed','Dimensions',{'time',365})
nccreate(savefile,'avmed_plus1','Dimensions',{'time',365})
nccreate(savefile,'avmed_minus1','Dimensions',{'time',365})
nccreate(savefile,'avmode','Dimensions',{'time',365})
nccreate(savefile,'len','Dimensions',{'time',365})
nccreate(savefile,'tilt','Dimensions',{'time',365})
nccreate(savefile,'width','Dimensions',{'time',365})

%write variables
ncwrite(savefile,'hov',hov_8001')
ncwrite(savefile,'freq1',freq1_8001)
ncwrite(savefile,'freq1dev',freq1dev_8001)
ncwrite(savefile,'freq2',freq2_8001)
ncwrite(savefile,'avmean',avmean_8001)
ncwrite(savefile,'avmed',avmed_8001)
ncwrite(savefile,'avmed_plus1',avmed_plus1_8001)
ncwrite(savefile,'avmed_minus1',avmed_minus1_8001)
ncwrite(savefile,'avmode',avmode_8001)
ncwrite(savefile,'len',len_8001)
ncwrite(savefile,'tilt',tilt_8001)
ncwrite(savefile,'width',width_8001)

movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')


