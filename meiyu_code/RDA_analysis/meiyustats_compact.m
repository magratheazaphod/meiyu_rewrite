function [fq1,fq2,latout,intensout,latout2,intensout2]=meiyustats_compact(daymin,daymax,yearmin,yearmax,lat_toggle,lat_cutoff,primaryonly,tau)

%meiyustats_compact.m

%written by Jesse Day, July 30th 2014 - a rewrite of meiyustats.m in a much
%smarter way that allows for the gathering of stats for any set of years
%and any range of dates.

% EDITED by Jesse Day March 13th 2015 - fixed silly coding mistake which
% prevented latitude cutoffs. ALSO, added important additional toggle
% primaryonly - when set to 1, only considers primary front events. When
% set to zero, statistics include both primary and secondary events.
% Especially important during Post-Meiyu when distinction between primary
% and secondary front events is minor (very few secondary front events in
% other seasons, so unlikely to affect other statistics).

%more edits April 3rd - now accounts for the decorrelation length scale
%tau, provide as a 2x1 vector tau. tau(1) is tau of primary fronts, tau(2)
%s the same for secondary fronts.

%also, now returns statistics about secondary front.

%latcutoff - optionally limits the data collected by latitude as well

%lattoggle - 1 - only latitudes + than latcutoff. -1 - only latitudes -
%than latcutoff. 0 - no cutoff

%statistics returned:
% -total number of counts, percentage of days with a front, pct of days with
%secondary front
%
% -mean latitude and standard deviation of latitude
%
% -50%, 68.3%, 95.45& (1 sigma and 2 sigma), 99% and 99.9% intensity events
%
% -mean tilt, length and width and associated standard deviations
%
% -plot of latitude occupancy, intensity

%display day and year range
%daymin
%daymax
%yearmin
%yearmax
%lat_cutoff
%lat_toggle
%pause

%% LOADING DATA FROM NETCDF %%

%load data from NetCDF - primary Meiyu
lat115=ncread('meiyu_clean.nc','lat_115');
intens=ncread('meiyu_clean.nc','intensity');
ismeiyu=ncread('meiyu_clean.nc','ismeiyu');
q1=ncread('meiyu_clean.nc','Q1');
q1_alt=ncread('meiyu_clean.nc','Q1_alt');
countit_1=ncread('meiyu_clean.nc','countit_1');
countit_2=ncread('meiyu_clean.nc','countit_2');
c2type=ncread('meiyu_clean.nc','c2type');


%load data from NetCDF - secondary Meiyu
lat115_2=ncread('meiyu_2_clean.nc','lat_115');
intens_2=ncread('meiyu_2_clean.nc','intensity');
ismeiyu_2=ncread('meiyu_2_clean.nc','ismeiyu');
q2=ncread('meiyu_2_clean.nc','Q2');
q2_clean=ncread('meiyu_2_clean.nc','Q2_clean');


%%% ASSOCIATE DATE WITH EACH DAY

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

%year hash - know where to cut off based off of the desired years

yeardays=365*ones(57,1);

for i=2:57
    yeardays(i)=yeardays(i)+yeardays(i-1);
    
    if mod(i,4)==0
        yeardays(i)=yeardays(i)+1;
    end
    
end

if yearmin==1951
    firstday=1;
else
    firstday=yeardays(yearmin-1950-1)+1;
end

lastday=yeardays(yearmax-1950);

%%% SELECT DAYS

%only allow dates that fall within our year boundaries
mydays_1=([1:20819]' >= firstday) & ([1:20819]' <= lastday);

%only allow days that fall with daymin & daymax (restrict by season)
if daymax >= daymin
    
    mydays_2=(daynum >= daymin) & (daynum <= daymax);
    
elseif daymax < daymin %in other words, our season of choice wraps around
    %the end of the year.
    
    mydays_2=(daynum >=daymin) | (daynum<=daymax);
    
end
    
mydays=mydays_1 & mydays_2';


%%% MASK DEFINITION
mask=(countit_1 & mydays);
mask2=(countit_2 & mydays);

%% INCORPORATE LATITUDE RESTRICTIONS

if lat_toggle == 1
    mask_lat = lat115 > lat_cutoff;
    mask_lat_2= lat115_2 > lat_cutoff;
    mask=mask.*mask_lat;
    mask2=mask2.*mask_lat_2;
end

if lat_toggle == -1
    mask_lat = lat115 < lat_cutoff;
    mask_lat_2 = lat115_2 < lat_cutoff;
    mask=mask.*mask_lat;
    mask2=mask2.*mask_lat_2;
end

%%% FIND VALUES FOR SELECTED DATES

%% MASK VARIABLES
lats=lat115(mask==1);
intensity=intens(mask==1);
lats2=lat115_2(mask2==1);
intensity2=intens_2(mask2==1);

%%FREQUENCY
totaldays=sum(mydays(mydays));
counts_1=sum(countit_1(mask==1));
counts_2=sum(countit_2(mask==1));
ct_1_pct=counts_1/totaldays;
ct_2_pct=counts_2/totaldays;

n1=totaldays/tau(1);
n2=totaldays/tau(2);
    
%standard deviation - defined as (p*(1-p)/n)^(1/2)
ct_1_dev=(ct_1_pct*(1-ct_1_pct)/n1)^(1/2);
ct_2_dev=(ct_2_pct*(1-ct_2_pct)/n2)^(1/2);


%%LATITUDE
if primaryonly==0

    lats=[lats;lats2];

end    

lat_mean=mean(lats);
lat2_mean=mean(lats2);

%return the mean and mode averages - median already given by cdf_50
if primaryonly==0

    intensity=[intensity;intensity2];

end    
    
intmean=mean(intensity);
int2mean=mean(intensity2);

%ORGANIZE VARIABLES FOR OUTPUT - output value + standard deviation for each

fq1={ct_1_pct,ct_1_dev,totaldays};
fq2={ct_2_pct,ct_2_dev,totaldays};
latout={lat_mean,lats};
intensout={intmean,intensity};
latout2={lat2_mean,lats2};
intensout2={int2mean,intensity2};

%latbin - primary Meiyu events. latbin2 - secondary Meiyu events.
%latbin_all - primary + secondary Meiyu events. occupancy plots for all