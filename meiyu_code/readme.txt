readme.txt

COMPLETE PACKAGE of code for rainband detection project, except for download of APHRODITE precipitation data, which should be done at original website.

A readme for use with the Front Detection Algorithm package used in Day et al. (2015).
Produces all results displayed in paper.

!! DETECTION CODE
countmeiyu.m
fridaycontrol.m - external script that runs everything.
fridaysave.m
meiyu.m
meiyufit.m
myaltqscore.m
remove10.m
wpolyfit.m


!input files:
APHRO_MA_025deg_V1101.year.nc  !APHRODITE .25 degree by .25 degree precip, available at http://www.chikyu.ac.jp/precip/

!output files
meiyu_`year`.nc - subsequently use nccat to chain all of the individual year meiyu_*.nc files into one giant file.


!! ANALYSIS CODE

!bootstrapping codes
acf.m - generic code that calculates autocorrelation function

fridayload.m - loads all meiyu variables into MATLAB.

meiyu_autocorr.m - checks if rainband properties are autocorrelated in time, affecting calculations of statistical significance.

meiyu_bs.m - bootstrapping calculations of significance of frequency/latitude changes for different time periods

meiyu_bs_intervals.m - runs meiyu_bs.m for a preset set of time periods.

meiyu_dc.m - makes Hovmoller plot of mean rainfall over China in one year starting with Pchina.nc. Outputs meiyudingchan_updated.nc

meiyu_diff_bgplot.m - script that shows significance of changes in rainfall with and without moving blocks bootstrapping. produces meiyu_diff_15day.nc

meiyu_fq_diff.m - plots a yearly map of changes in rainband frequency between 1951-1979 and 1980-2007. produces meiyudiff_xday_ydeglat.nc

meiyu_supp_figs.m - supplementary figures of Meiyu algorithm performance as shown in supplementary material.

meiyuclean.m - takes the original meiyu.nc and changes any days that failed our quality statistics to NaNs. outputs to meiyu_clean.nc and meiyu_2_clean.nc. Important for being able to show accurate climatology.

meiyuclimo_build.m - produces rainband climatology meiyuclimo_final.nc, meiyuclimo_5179_final.nc and meiyuclimo_8007_final.nc

meiyuclimo_smooth.m - smooths out the climatology in meiyuclimo_final.nc for display purposes.

meiyustats_compact.m - statistics about rainbands from a particular range of dates. A simplified form of meiyustats_new.m

meiyustats_new.m - reads meiyu_clean.nc and meiyu_2_clean.nc, produces a very comprehensive set of statistics.

mybs.m - bootstrapped statistics.

mybs_blocks.m - blocked bootstrapping statistics.

mybs_diff.m - bootstrapping with replacement test of significance of change in mean

mybs_diff_blocks.m - blocked bootstrapping with replacement of significance of change in mean

mybs_diff_blocks_2d.m - 2D spatial version of mybs_diff_blocks.m

myperm.m - permutation test of significance

rain_changes_2d_sig.m - creates 2D spatial maps of significance of 1951-2007 rainfall trends

sgntrend_xy.m - generic code that provides p-value of an observed trend


!input files
APHRO_eastasia_yr.nc - yearly precip at each point in 105E-123E, 20N-40N
a1.nc
a2.nc
a3.nc
b1.nc
b2.nc
b3.nc
meiyu.nc
meiyu_clean.nc - produced by
meiyu_2_clean.nc - ditto
meiyuclimo_5179_final.nc
meiyuclimo_5879_final.nc
meiyuclimo_8001_final.nc
meiyuclimo_8007_final.nc
meiyuclimo_final.nc
meiyudingchan_updated.nc
Pchina.nc - zonal mean precip for 20N-40N averaged over 105E-123E.

!output files
meiyu_diff_15day.nc
meiyu_fq_diff_15day_2deglat.nc
meiyuclimo_5179_final.nc
meiyuclimo_8007_final.nc
meiyuclimo_final.nc
meiyuclimo_final_smooth_9day_2deg.nc
meiyudingchan_updated.nc
mybs_5179_8007.nc
mybs_5879_8001.nc
mybs_7993_9407.nc
mybs_5179_8007_primaryonly.nc - significance calculated only using primary events
mybs_5879_8001_primaryonly.nc
mybs_7993_9407_primaryonly.nc
mybs_5179_8007_tau.nc !same as above, but significance calculated using autocorrelation timescale tau of front appearance.
mybs_5879_8001_tau.nc
mybs_7993_9407_tau.nc
rain_changes_2d_sig.nc


!! FERRET SCRIPTS
!mostly for displaying of analysis output from MATLAB

meiyuclimo_sidebar.jnl - produces zonally averaged sidebars on relevant figures.

meiyuclimo_sidebar_2d.jnl - variant of above used on different figures

meiyufigures.jnl - primary control script for plotting meiyu figures. Uses the following netcdf files: meiyuclimo_final_smooth_5day_0deg.nc, meiyuclimo_final_smooth_9day_2deg.nc

my_rain_diff_sig.jnl - plots spatial significance of rainfall trends


!! JET CODE (now unused)
meiyu_jet_covar.m - plots correlations of jet anomalies and rainband anomalies during particular time periods
meiyuclimo_covar.m - outputs anomalies of rainband statistics for particular time periods.

!input files
monthly_jetlat_anoms.csv
tenday_jetlat_anoms.csv
meiyuclimo_covar_mth.nc
meiyuclimo_covar_tenday.nc
