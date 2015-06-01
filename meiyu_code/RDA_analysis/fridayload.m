lat105_clean=ncread('meiyu_clean.nc',lower('LAT_105'));
lat115_clean=ncread('meiyu_clean.nc',lower('LAT_115'));
tilt_clean=ncread('meiyu_clean.nc',lower('TILT'));
intensity_clean=ncread('meiyu_clean.nc',lower('INTENSITY'));
width_clean=ncread('meiyu_clean.nc',lower('WIDTH'));
ismeiyu=ncread('meiyu_clean.nc',lower('ISMEIYU'));
q1=ncread('meiyu_clean.nc','Q1');
q1_alt=ncread('meiyu_clean.nc','Q1_alt');
len_clean=ncread('meiyu_clean.nc',lower('LENGTH'));
twfrac=ncread('meiyu_clean.nc',lower('TWFRAC'));
density_clean=ncread('meiyu_clean.nc',lower('DENSITY'));
countit_1=ncread('meiyu_clean.nc',lower('COUNTIT_1'));
countit_2=ncread('meiyu_clean.nc',lower('COUNTIT_2'));
c2type=ncread('meiyu_clean.nc',lower('C2TYPE'));
q1_clean=ncread('meiyu_clean.nc','Q1_clean');
q1_alt_clean=ncread('meiyu_clean.nc','Q1_alt_clean');


%load data from NetCDF - secondary Meiyu
lat105_2_clean=ncread('meiyu_2_clean.nc',lower('LAT_105'));
lat115_2_clean=ncread('meiyu_2_clean.nc',lower('LAT_115'));
tilt_2_clean=ncread('meiyu_2_clean.nc',lower('TILT'));
intensity_2_clean=ncread('meiyu_2_clean.nc',lower('INTENSITY'));
width_2_clean=ncread('meiyu_2_clean.nc',lower('WIDTH'));
ismeiyu_2=ncread('meiyu_2_clean.nc',lower('ISMEIYU'));
q2=ncread('meiyu_2_clean.nc','Q2');
len_2_clean=ncread('meiyu_2_clean.nc',lower('LENGTH'));
density_2_clean=ncread('meiyu_2_clean.nc',lower('DENSITY'));
q2_clean=ncread('meiyu_2_clean.nc','Q2_clean');
