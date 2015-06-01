%written by Jesse Day, March 9th 2015

%makes supplementary figures of algorithm functionality for 2015 paper on
%Meiyu front, based on meiyu.m.

%4 Figure sets: 1) criterion for fitting 2) recursion 3) double front
% ... 4) quality score for acceptance

minlong=105.125;
maxlong=122.875;
minlat=20.125;
maxlat=39.875;

year=2007
str1='APHRO_MA_025deg_V1101.';
str2=int2str(year);
str3='.nc';
filename=strcat(str1,str2,str3);
P=ncread(filename,'precip');

%Figure set 1
%a) 25 May 2007 (day 145) - fit accepted
%b) 11 Jun 2007 (day 162) - no fit

%a)
d=145
PRECIP=P(:,:,d);
[l105,l115,t,i,w,my,q,lgth,tw,dy,crash,crashlat,crashtop]=...
    meiyu(PRECIP,d,minlong,maxlong,minlat,maxlat);
        

%b)
d=162
PRECIP=P(:,:,d);
[l105,l115,t,i,w,my,q,lgth,tw,dy,crash,crashlat,crashtop]=...
    meiyu(PRECIP,d,minlong,maxlong,minlat,maxlat);

%Figure set 2
% 29 April 2007 (day 119) - convergence of fit'
%a) initial fit. b) 2 degree window c) final fit

minlong=105.125;
maxlong=122.875;
minlat=20.125;
maxlat=39.875;

year=2007
str1='APHRO_MA_025deg_V1101.';
str2=int2str(year);
str3='.nc';
filename=strcat(str1,str2,str3);
P=ncread(filename,'precip');


d=119
PRECIP=P(:,:,d);
[l105,l115,t,i,w,my,q,lgth,tw,dy,crash,crashlat,crashtop]=...
    meiyu(PRECIP,d,minlong,maxlong,minlat,maxlat);

%figure set 3
%a) show primary fit, shade associated precipitation
%b) show secondary fit with associated precip removed
%day used - d=141, May 21 2007

minlong=105.125;
maxlong=122.875;
minlat=20.125;
maxlat=39.875;

year=2007
str1='APHRO_MA_025deg_V1101.';
str2=int2str(year);
str3='.nc';
filename=strcat(str1,str2,str3);
P=ncread(filename,'precip');


d=141;
PRECIP=P(:,:,d);
[l105,l115,t,i,w,my,q,lgth,tw,dy,crash,crashlat,crashtop]=...
    meiyu(PRECIP,d,29.625,maxlong,minlat,maxlat);


%figure set 4
%a) Taiwan day
%b) Q>.6 - ordinary fit
%c) Q<.6 - no fit
%d) Q1 > .6 and Q2 > .6

%a) chose 18th August (Typhoon Sepat), L=230

%b) 4 June 2007 - good fit

minlong=105.125;
maxlong=122.875;
minlat=20.125;
maxlat=39.875;

year=2007
str1='APHRO_MA_025deg_V1101.';
str2=int2str(year);
str3='.nc';
filename=strcat(str1,str2,str3);
P=ncread(filename,'precip');

d=155;
PRECIP=P(:,:,d);
[l105,l115,t,i,w,my,q,lgth,tw,dy,crash,crashlat,crashtop]=...
    meiyu(PRECIP,d,minlong,maxlong,minlat,maxlat);


%c) 17 April 2007 - poor fit

minlong=105.125;
maxlong=122.875;
minlat=20.125;
maxlat=39.875;

year=2007
str1='APHRO_MA_025deg_V1101.';
str2=int2str(year);
str3='.nc';
filename=strcat(str1,str2,str3);
P=ncread(filename,'precip');

d=107;
PRECIP=P(:,:,d);
[l105,l115,t,i,w,my,q,lgth,tw,dy,crash,crashlat,crashtop]=...
    meiyu(PRECIP,d,minlong,maxlong,minlat,maxlat);

