%meiyuclean.nc

%written by Jesse Day, July 7th 2014. Minor edit, March 6th 2015

%takes meiyu.nc and meiyu_2.nc, and turns them into meiyu_clean.nc and
%meiyu_2_clean.nc. In those, values are turned into NaNs on days that do
%not meet our quality criteria, even when a fit was successfully performed.

%resulting data much more useful for statistical analysis

%in updated version, several things are changed: We save countit_1,
%countit_2 and c2type to both meiyu_clean.nc and meiyu_2_clean.nc, and we
%also save q1_clean and q2_clean, in addition to the original Q1 and Q2 -
%the idea being to be able to plot a yearly climatology of quality scores.

clear all;
close all;

%load data from NetCDF - primary Meiyu
lat105_clean=ncread('meiyu.nc','LAT_105');
lat115_clean=ncread('meiyu.nc','LAT_115');
tilt_clean=ncread('meiyu.nc','TILT');
intensity_clean=ncread('meiyu.nc','INTENSITY');
width_clean=ncread('meiyu.nc','WIDTH');
ismeiyu=ncread('meiyu.nc','ISMEIYU');
q1=ncread('meiyu.nc','Q1');
q1_alt=ncread('meiyu.nc','Q1_ALT');
len_clean=ncread('meiyu.nc','LENGTH');
twfrac=ncread('meiyu.nc','TWFRAC');
density_clean=ncread('meiyu.nc','DENSITY');
countit_1=ncread('meiyu.nc','COUNTIT_1');
countit_2=ncread('meiyu.nc','COUNTIT_2');
c2type=ncread('meiyu.nc','C2TYPE');

%load data from NetCDF - secondary Meiyu
lat105_2_clean=ncread('meiyu_2.nc','LAT_105_2');
lat115_2_clean=ncread('meiyu_2.nc','LAT_115_2');
tilt_2_clean=ncread('meiyu_2.nc','TILT_2');
intensity_2_clean=ncread('meiyu_2.nc','INTENSITY_2');
width_2_clean=ncread('meiyu_2.nc','WIDTH_2');
ismeiyu_2=ncread('meiyu_2.nc','ISMEIYU_2');
q2=ncread('meiyu_2.nc','Q2');
len_2_clean=ncread('meiyu_2.nc','LENGTH_2');
density_2_clean=ncread('meiyu_2.nc','DENSITY_2');

days=length(lat105_clean);

q1_clean=q1;
q1_alt_clean=q1_alt
q2_clean=q2;

for d=1:days
    
    if ismeiyu(d)==1
        
        if countit_1(d)==0
            
            lat105_clean(d)=NaN;
            lat115_clean(d)=NaN;
            tilt_clean(d)=NaN;
            intensity_clean(d)=NaN;
            width_clean(d)=NaN;
            q1_clean(d)=NaN;
            q1_alt_clean(d)=NaN;
            len_clean(d)=NaN;
            density_clean(:,d)=NaN(72,1);
            
            lat105_2_clean(d)=NaN;
            lat115_2_clean(d)=NaN;
            tilt_2_clean(d)=NaN;
            intensity_2_clean(d)=NaN;
            width_2_clean(d)=NaN;
            q2_clean(d)=NaN;
            len_2_clean(d)=NaN;
            density_2_clean(:,d)=NaN(72,1);
            
        end
        
        if (ismeiyu_2(d)==1 & countit_2(d) == 0)
            
            lat105_2_clean(d)=NaN;
            lat115_2_clean(d)=NaN;
            tilt_2_clean(d)=NaN;
            intensity_2_clean(d)=NaN;
            width_2_clean(d)=NaN;
            q2_clean(d)=NaN;
            len_2_clean(d)=NaN;
            density_2_clean(:,d)=NaN(72,1);
            
        end
        
    end
    
end


%% SAVE UPDATED VARIABLES - taken almost directly from fridaysave.nc

%create file name
savefile=strcat('meiyu_clean.nc')

deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%the names used for the vars are slightly weird because we rename them
%later anyway
nccreate(savefile,'lat_105','Dimensions',{'time',Inf})
nccreate(savefile,'lat_115','Dimensions',{'time',Inf})
nccreate(savefile,'tilt','Dimensions',{'time',Inf})
nccreate(savefile,'intensity','Dimensions',{'time',Inf})
nccreate(savefile,'width','Dimensions',{'time',Inf})
nccreate(savefile,'ismeiyu','Dimensions',{'time',Inf})
nccreate(savefile,'Q1','Dimensions',{'time',Inf})
nccreate(savefile,'Q1_alt','Dimensions',{'time',Inf})
nccreate(savefile,'length','Dimensions',{'time',Inf})
nccreate(savefile,'twfrac','Dimensions',{'time',Inf})
nccreate(savefile,'density','Dimensions',{'X',72,'time',Inf})

nccreate(savefile,'countit_1','Dimensions',{'time',Inf})
nccreate(savefile,'countit_2','Dimensions',{'time',Inf})
nccreate(savefile,'c2type','Dimensions',{'time',Inf})
nccreate(savefile,'Q1_clean','Dimensions',{'time',Inf})
nccreate(savefile,'Q1_alt_clean','Dimensions',{'time',Inf})


%write variables to file
ncwrite(savefile,'lat_105',lat105_clean)
ncwrite(savefile,'lat_115',lat115_clean)
ncwrite(savefile,'tilt',tilt_clean)
ncwrite(savefile,'intensity',intensity_clean)
ncwrite(savefile,'width',width_clean)
ncwrite(savefile,'ismeiyu',ismeiyu)
ncwrite(savefile,'Q1',q1)
ncwrite(savefile,'Q1_alt',q1_alt)
ncwrite(savefile,'length',len_clean)
ncwrite(savefile,'twfrac',twfrac)
ncwrite(savefile,'density',density_clean)
ncwrite(savefile,'countit_1',countit_1)
ncwrite(savefile,'countit_2',countit_2)
ncwrite(savefile,'c2type',c2type)
ncwrite(savefile,'Q1_clean',q1_clean)
ncwrite(savefile,'Q1_alt_clean',q1_alt_clean)


%move the resulting file if necessary
movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')


%% PART II - Save statistics of SECOND Meiyu (if two detected on same day)

%create file name
savefile='meiyu_2_clean.nc';

deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%the names used for the vars are slightly weird because we rename them
%later anyway
nccreate(savefile,'lat_105','Dimensions',{'time',Inf})
nccreate(savefile,'lat_115','Dimensions',{'time',Inf})
nccreate(savefile,'tilt','Dimensions',{'time',Inf})
nccreate(savefile,'intensity','Dimensions',{'time',Inf})
nccreate(savefile,'width','Dimensions',{'time',Inf})
nccreate(savefile,'ismeiyu','Dimensions',{'time',Inf})
nccreate(savefile,'Q2','Dimensions',{'time',Inf})
nccreate(savefile,'length','Dimensions',{'time',Inf})
nccreate(savefile,'density','Dimensions',{'X',72,'time',Inf})

nccreate(savefile,'countit_1','Dimensions',{'time',Inf})
nccreate(savefile,'countit_2','Dimensions',{'time',Inf})
nccreate(savefile,'c2type','Dimensions',{'time',Inf})
nccreate(savefile,'Q2_clean','Dimensions',{'time',Inf})


%write variables to file
ncwrite(savefile,'lat_105',lat105_2_clean)
ncwrite(savefile,'lat_115',lat115_2_clean)
ncwrite(savefile,'tilt',tilt_2_clean)
ncwrite(savefile,'intensity',intensity_2_clean)
ncwrite(savefile,'width',width_2_clean)
ncwrite(savefile,'ismeiyu',ismeiyu_2)
ncwrite(savefile,'Q2',q2)
ncwrite(savefile,'length',len_2_clean)
ncwrite(savefile,'density',density_2_clean)

ncwrite(savefile,'countit_1',countit_1)
ncwrite(savefile,'countit_2',countit_2)
ncwrite(savefile,'c2type',c2type)
ncwrite(savefile,'Q2_clean',q2_clean)


%move the resulting file if necessary
movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')
    