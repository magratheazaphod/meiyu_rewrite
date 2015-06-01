function [fq1,fq2,latout,intensout,lenout,tiltout,widthout]=meiyustats_new(daymin,daymax,yearmin,yearmax,lat_cutoff,lat_toggle)

%meiyustats_new.m

%written by Jesse Day, July 30th 2014 - a rewrite of meiyustats.m in a much
%smarter way that allows for the gathering of stats for any set of years
%and any range of dates.

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
lat105=ncread('meiyu_clean.nc','lat_105');
lat115=ncread('meiyu_clean.nc','lat_115');
tlt=ncread('meiyu_clean.nc','tilt');
intens=ncread('meiyu_clean.nc','intensity');
wdth=ncread('meiyu_clean.nc','width');
ismeiyu=ncread('meiyu_clean.nc','ismeiyu');
q1=ncread('meiyu_clean.nc','Q1');
q1_alt=ncread('meiyu_clean.nc','Q1_alt');
lngth=ncread('meiyu_clean.nc','length');
twfrac=ncread('meiyu_clean.nc','twfrac');
density=ncread('meiyu_clean.nc','density');
countit_1=ncread('meiyu_clean.nc','countit_1');
countit_2=ncread('meiyu_clean.nc','countit_2');
c2type=ncread('meiyu_clean.nc','c2type');

%load data from NetCDF - secondary Meiyu
lat105_2=ncread('meiyu_2_clean.nc','lat_105');
lat115_2=ncread('meiyu_2_clean.nc','lat_115');
tlt_2=ncread('meiyu_2_clean.nc','tilt');
intens_2=ncread('meiyu_2_clean.nc','intensity');
wdth_2=ncread('meiyu_2_clean.nc','width');
ismeiyu_2=ncread('meiyu_2_clean.nc','ismeiyu');
q2=ncread('meiyu_2_clean.nc','Q2');
lngth_2=ncread('meiyu_2_clean.nc','length');
density_2=ncread('meiyu_2_clean.nc','density');


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
mydays_2=(daynum >= daymin) & (daynum <= daymax);

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
width=wdth(mask==1);
len=lngth(mask==1);
tilt=tlt(mask==1);

lats_2=lat115_2(mask2==1);
intensity_2=intens_2(mask2==1);
width_2=wdth_2(mask2==1);
len_2=lngth_2(mask2==1);
tilt_2=tlt_2(mask2==1);

%%FREQUENCY
totaldays=sum(mydays(mydays));
cts_1=countit_1(mydays);
counts_1=length(lats);
counts_2=sum(countit_2(mydays));
ct_1_pct=counts_1/totaldays;
ct_2_pct=counts_2/totaldays;

    
%standard deviation - defined as (p*(1-p)/n)^(1/2)
ct_1_dev=(ct_1_pct*(1-ct_1_pct)/totaldays)^(1/2);
ct_2_dev=(ct_2_pct*(1-ct_2_pct)/totaldays)^(1/2);
%pause

%%LENGTH, TILT & WIDTH
len_mean=mean(len);
len_dev=std(len);
tilt_mean=mean(tilt);
tilt_dev=std(tilt);
width_mean=mean(width);
width_dev=std(width);

%%LATITUDE
lat_mean=mean(lats);
lat_dev=std(lats);

%histogram of latitudes - currently with 1 degree resolution
latbin=zeros(20,1);

for i=1:length(lats)
    
    j=round(lats(i)-19.5);
    
    if (j>=1 & j<=20)
        latbin(j)=latbin(j)+1;
    end
 
end

%UNCOMMENT TO SEE LATITUDE DISTRIBUTION
%plot([20.5:1:39.5],latbin)
%pause


%SECONDARY MEIYU DISTRIBUTION - new variable that also keeps an occupancy plot of
%secondary front events (useful for producing a Hovmoller diagram later)
latbin2=zeros(20,1);

for i=1:length(lats_2)
    
    j=round(lats_2(i)-19.5);
    
    if (j>=1 & j<=20)
        latbin2(j)=latbin2(j)+1;
    end
 
end

%plot([20.5:1:39.5],latbin2)
%pause


%DISTRIBUTION OF PRIMARY + SECONDARY EVENTS
latbin_all=latbin+latbin2;


%LATITUDE CDF

mylatcdf=zeros(400,1);
ll=length(lats);

for i=1:400
    ii=i/10+10;
    mylatcdf(i)=sum(lats<ii)/ll;
end


%%INTENSITY - using actual probability distribution function and CDF from
%%the data

mypdf=zeros(100,1);

for i=1:100
   
    mypdf(i)=sum((intensity > (i-1)) & (intensity < i));
    
end

%gamma fit of intensity data - good, but underestimates 99% and up events
[phat,pci]=gamfit(intensity,.05);
mygam=gampdf([1:100],phat(1),phat(2));
mygam_norm=mygam*max(mypdf)/max(mygam);
%plot(mypdf)
%hold on
%plot(mygam_norm)
%pause
%close

mycdf=zeros(1000,1);
ll=length(intensity);

for i=1:1000
    ii=i/10;
    mycdf(i)=sum(intensity<ii)/ll;
end

%figure(2)
%plot(mycdf)

cdf_50=sum(mycdf<.5)/10;
cdf_1sigma=sum(mycdf<.684)/10;
cdf_2sigma=sum(mycdf<.955)/10;
cdf_99=sum(mycdf<.99)/10;
cdf_999=sum(mycdf<.999)/10;

%return the mean and mode averages - median already given by cdf_50
intmean=mean(intensity);
[~,intmode]=max(mypdf);
cdf_below_1sigma=sum(mycdf<.316)/10;


%pause

%ORGANIZE VARIABLES FOR OUTPUT - output value + standard deviation for each
fq1={ct_1_pct,ct_1_dev,totaldays,cts_1};
fq2={ct_2_pct,ct_2_dev,totaldays};
latout={lat_mean,lat_dev,latbin,mylatcdf,latbin2,latbin_all,lats};
intensout={cdf_50,cdf_1sigma,cdf_2sigma,cdf_99,cdf_999,mypdf,mygam_norm,phat,pci,mycdf,intmean,intmode,cdf_below_1sigma,intensity};
lenout={len_mean,len_dev};
tiltout={tilt_mean,tilt_dev};
widthout={width_mean,width_dev};

%latbin - primary Meiyu events. latbin2 - secondary Meiyu events.
%latbin_all - primary + secondary Meiyu events. occupancy plots for all
