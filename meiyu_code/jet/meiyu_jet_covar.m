%meiyu_jet_covar.m

%written by Jesse Day, February 9th, 2015. Edited March 2nd, 2015 with a
%different definition of frontal anomalies.

%produces key figure for the 2015 Meiyu paper with Jake, John, Inez and
%Weihan. 

%eventual goal - two x-y plots of jet anomalies corresponding to a)
%frequency changes in frontal % during 121-150 and b) latitude of frontal
%occurrence during 201-260.

%years for which this is calculated - 1958-2001, duration of jet data set.
%broken into two groups, 1958-1979 and 1980-2001 (color-coded into two
%separate groups on the plot).


clear all
close all

%LOAD DATA FROM CSV
years=[1958:2001]

%%MONTHLY
jet_mean_121150=40.009
jet_mean_201230=44.46997
jet_mean_231260=42.84506

%monthly jet anomalies
jet_anom_121150=csvread('monthly_jetlat_anoms.csv',1,1,[1 1 44 1])
jet_anom_201230=csvread('monthly_jetlat_anoms.csv',1,2,[1 2 44 2])
jet_anom_231260=csvread('monthly_jetlat_anoms.csv',1,3,[1 3 44 3])

jet_vals_121150=jet_anom_121150+jet_mean_121150;
jet_vals_201230=jet_anom_201230+jet_mean_201230;
jet_vals_231260=jet_anom_231260+jet_mean_231260;


%%TEN-DAY
jet_vals_121130=csvread('tenday_jetlat_anoms.csv',1,1,[1 1 44 1])
jet_vals_131140=csvread('tenday_jetlat_anoms.csv',1,2,[1 2 44 2])
jet_vals_141150=csvread('tenday_jetlat_anoms.csv',1,3,[1 3 44 3])
jet_vals_201210=csvread('tenday_jetlat_anoms.csv',1,4,[1 4 44 4])
jet_vals_211220=csvread('tenday_jetlat_anoms.csv',1,5,[1 5 44 5])
jet_vals_221230=csvread('tenday_jetlat_anoms.csv',1,6,[1 6 44 6])
jet_vals_231240=csvread('tenday_jetlat_anoms.csv',1,7,[1 7 44 7])
jet_vals_241250=csvread('tenday_jetlat_anoms.csv',1,8,[1 8 44 8])

jet_mean_121130=mean(jet_vals_121130);
jet_mean_131140=mean(jet_vals_131140);
jet_mean_141150=mean(jet_vals_141150);
jet_mean_201210=mean(jet_vals_201210);
jet_mean_211220=mean(jet_vals_211220);
jet_mean_221230=mean(jet_vals_221230);
jet_mean_231240=mean(jet_vals_231240);
jet_mean_241250=mean(jet_vals_241250);

jet_anom_121130=csvread('tenday_jetlat_anoms.csv',1,9,[1 9 44 9])
jet_anom_131140=csvread('tenday_jetlat_anoms.csv',1,10,[1 10 44 10])
jet_anom_141150=csvread('tenday_jetlat_anoms.csv',1,11,[1 11 44 11])
jet_anom_201210=csvread('tenday_jetlat_anoms.csv',1,12,[1 12 44 12])
jet_anom_211220=csvread('tenday_jetlat_anoms.csv',1,13,[1 13 44 13])
jet_anom_221230=csvread('tenday_jetlat_anoms.csv',1,14,[1 14 44 14])
jet_anom_231240=csvread('tenday_jetlat_anoms.csv',1,15,[1 15 44 15])
jet_anom_241250=csvread('tenday_jetlat_anoms.csv',1,16,[1 16 44 16])


%%% LOAD APPROPRIATE MEIYU DATA

%February 9 2015 - relies on new script meiyuclimo_covar.m, which produces
%the appropriate data sets necessary for working on this exact problem

%monthly data
freq_anom_121150=100*ncread('meiyuclimo_covar_mth.nc','freq_anom_121150');
freq_anom_201230=100*ncread('meiyuclimo_covar_mth.nc','freq_anom_201230');
freq_anom_231260=100*ncread('meiyuclimo_covar_mth.nc','freq_anom_231260');

lat_anom_121150=ncread('meiyuclimo_covar_mth.nc','lat_anom_121150');
lat_anom_201230=ncread('meiyuclimo_covar_mth.nc','lat_anom_201230');
lat_anom_231260=ncread('meiyuclimo_covar_mth.nc','lat_anom_231260');

%ten-day data
freq_anom_121130=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_121130');
freq_anom_131140=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_131140');
freq_anom_141150=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_141150');

freq_anom_201210=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_201210');
freq_anom_211220=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_211220');
freq_anom_221230=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_221230');
freq_anom_231240=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_231240');
freq_anom_241250=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_241250');


lat_anom_121130=ncread('meiyuclimo_covar_tenday.nc','lat_anom_121130');
lat_anom_131140=ncread('meiyuclimo_covar_tenday.nc','lat_anom_131140');
lat_anom_141150=ncread('meiyuclimo_covar_tenday.nc','lat_anom_141150');

lat_anom_201210=ncread('meiyuclimo_covar_tenday.nc','lat_anom_201210');
lat_anom_211220=ncread('meiyuclimo_covar_tenday.nc','lat_anom_211220');
lat_anom_221230=ncread('meiyuclimo_covar_tenday.nc','lat_anom_221230');
lat_anom_231240=ncread('meiyuclimo_covar_tenday.nc','lat_anom_231240');
lat_anom_241250=ncread('meiyuclimo_covar_tenday.nc','lat_anom_241250');

%% NEW DATA - data only north of 28N for the post-Meiyu
freq_anom_201230_north=100*ncread('meiyuclimo_covar_mth.nc','freq_anom_201230_north');
freq_anom_231260_north=100*ncread('meiyuclimo_covar_mth.nc','freq_anom_231260_north');

lat_anom_201230_north=ncread('meiyuclimo_covar_mth.nc','lat_anom_201230_north');
lat_anom_231260_north=ncread('meiyuclimo_covar_mth.nc','lat_anom_231260_north');

%ten-day data
freq_anom_201210_north=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_201210_north');
freq_anom_211220_north=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_211220_north');
freq_anom_221230_north=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_221230_north');
freq_anom_231240_north=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_231240_north');
freq_anom_241250_north=100*ncread('meiyuclimo_covar_tenday.nc','freq_anom_241250_north');

lat_anom_201210_north=ncread('meiyuclimo_covar_tenday.nc','lat_anom_201210_north');
lat_anom_211220_north=ncread('meiyuclimo_covar_tenday.nc','lat_anom_211220_north');
lat_anom_221230_north=ncread('meiyuclimo_covar_tenday.nc','lat_anom_221230_north');
lat_anom_231240_north=ncread('meiyuclimo_covar_tenday.nc','lat_anom_231240_north');
lat_anom_241250_north=ncread('meiyuclimo_covar_tenday.nc','lat_anom_241250_north');


%% MAKE PLOTS
%things plotted:
%a) Meiyu frequency anomaly (%) versus jet latitude anomaly (degrees), for
%days 121-150
%b) Meiyu latitude anomaly (degrees) versus jet latitude anomaly (degrees),
%for days 201-260 with 201-230 and 231-260 as separate points.

%also calculated: i) best fit line  ii) r^2  iii) statistical significance
%of obtained trend with permutation test.

%% MONTHLY ANOMALIES - 121-150
figure(1)

xdata_5879=freq_anom_121150(1:22);
ydata_5879=jet_anom_121150(1:22);

xdata_8001=freq_anom_121150(23:44);
ydata_8001=jet_anom_121150(23:44);

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-25,25])
plot([-25,25],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['121-150, jet latitude V front frequency, R=' num2str(r(1,2))] ...
    ,'FontSize',20)
legend('1958-1979','1980-2001')

axis([-25 25 -5 5])

fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_1';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

figure(1)
axis([-25 25 -2.25 2.25])

fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_1_alt';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

figure(5)
h1=histogram(xdata_5879,[-25:5:25])
hold on
h2=histogram(xdata_8001,[-25:5:25])
%h1.BinWidth=5;
%h2.BinWidth=5;

filename='meiyu_jet_1a';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

figure(6)
ydata_5879(ydata_5879<-2.5)=-2.4
ydata_5879(ydata_5879>2.5)=2.4
ydata_8001(ydata_8001<-2.5)=-2.4
ydata_8001(ydata_8001>2.5)=2.4
h3=histogram(ydata_5879,[-2.5:.5:2.5])
hold on
h4=histogram(ydata_8001,[-2.5:.5:2.5])
%h3.BinWidth=1
%h4.BinWidth=1

filename='meiyu_jet_1b';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

pause

close(5)
close(6)

%% MONTHLY ANOMALIES - 201-260
figure(7)
xdata_5879=[lat_anom_201230(1:22);lat_anom_231260(1:22)]
ydata_5879=[jet_anom_201230(1:22);jet_anom_231260(1:22)]

xdata_8001=[lat_anom_201230(23:44);lat_anom_231260(23:44)]
ydata_8001=[jet_anom_201230(23:44);jet_anom_231260(23:44)]

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-5,5])
plot([-8,8],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['201-260, jet latitude V front latitude, R=' ...
    num2str(r(1,2))] ,'FontSize',20)
legend('1958-1979','1980-2001')


fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_2';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')


figure(5)
h1=histogram(xdata_5879)
hold on
h2=histogram(xdata_8001)
h1.BinWidth=1;
h2.BinWidth=1;

filename='meiyu_jet_2a';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

figure(6)
h3=histogram(ydata_5879)
hold on
h4=histogram(ydata_8001)
h3.BinWidth=1
h4.BinWidth=1

filename='meiyu_jet_2b';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

pause

close(5)
close(6)


%% TEN-DAY ANOMALIES - 121-150
figure(3)
xdata_5879=[freq_anom_121130(1:22);freq_anom_131140(1:22);freq_anom_141150(1:22)]
ydata_5879=[jet_anom_121130(1:22);jet_anom_131140(1:22);jet_anom_141150(1:22);]

xdata_8001=[freq_anom_121130(23:44);freq_anom_131140(23:44);freq_anom_141150(23:44)]
ydata_8001=[jet_anom_121130(23:44);jet_anom_131140(23:44);jet_anom_141150(23:44);]

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-50,50])
plot([-50,50],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['121-150, 10-day bins, jet latitude V front frequency, R=' ...
    num2str(r(1,2))] ,'FontSize',20)
legend('1958-1979','1980-2001')


fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_3';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

figure(5)
h1=histogram(xdata_5879)
hold on
h2=histogram(xdata_8001)
h1.BinWidth=10;
h2.BinWidth=10;

filename='meiyu_jet_3a';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

figure(6)
h3=histogram(ydata_5879)
hold on
h4=histogram(ydata_8001)
h3.BinWidth=1
h4.BinWidth=1

filename='meiyu_jet_3b';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

pause

close(5)
close(6)



%% TEN-DAY ANOMALIES - 201-250
figure(4)
xdata_5879=[lat_anom_201210(1:22);lat_anom_211220(1:22);lat_anom_221230(1:22); ...
lat_anom_231240(1:22);lat_anom_241250(1:22)]
ydata_5879=[jet_anom_201210(1:22);jet_anom_211220(1:22);jet_anom_221230(1:22); ...
jet_anom_231240(1:22);jet_anom_241250(1:22)]

xdata_8001=[lat_anom_201210(23:44);lat_anom_211220(23:44);lat_anom_221230(23:44); ...
lat_anom_231240(23:44);lat_anom_241250(23:44)]
ydata_8001=[jet_anom_201210(23:44);jet_anom_211220(23:44);jet_anom_221230(23:44); ...
jet_anom_231240(23:44);jet_anom_241250(23:44)]

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];

a=isnan(xdata).*[1:220]'
nans=a(a>0)
ydata(nans)=NaN
xdata=xdata(not(isnan(xdata)));
ydata=ydata(not(isnan(ydata)));

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-10,10])
plot([-10,10],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['201-260, 10-day bins, jet latitude V front latitude, R=' ...
    num2str(r(1,2))] ,'FontSize',20)
legend('1958-1979','1980-2001')


grid on

fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_4';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')


figure(5)
h1=histogram(xdata_5879)
hold on
h2=histogram(xdata_8001)
h1.BinWidth=1;
h2.BinWidth=1;

filename='meiyu_jet_4a';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

figure(6)
h3=histogram(ydata_5879)
hold on
h4=histogram(ydata_8001)
h3.BinWidth=1
h4.BinWidth=1

filename='meiyu_jet_4b';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

pause

close(5)
close(6)



%% MAKE MORE PLOTS - this time only using ABSOLUTE jet latitude
%things plotted:
%a) Meiyu frequency anomaly (%) versus jet latitude anomaly (degrees), for
%days 121-150
%b) Meiyu latitude anomaly (degrees) versus jet latitude anomaly (degrees),
%for days 201-260 with 201-230 and 231-260 as separate points.

%also calculated: i) best fit line  ii) r^2  iii) statistical significance
%of obtained trend with permutation test.

close(3)
close(4)
close(7)

%% MONTHLY ANOMALIES - 121-150
figure(1)

xdata_5879=freq_anom_121150(1:22);
ydata_5879=jet_vals_121150(1:22);

xdata_8001=freq_anom_121150(23:44);
ydata_8001=jet_vals_121150(23:44);

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-25,25])
plot([-25,25],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['121-150 monthly anomalies, jet latitude V front frequency, R=' num2str(r(1,2))] ...
    ,'FontSize',20)
legend('1958-1979','1980-2001')

fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_abs_1';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

%% MONTHLY ANOMALIES - 201-260
figure(2)
xdata_5879=[lat_anom_201230(1:22);lat_anom_231260(1:22)]
ydata_5879=[jet_vals_201230(1:22);jet_vals_231260(1:22)]

xdata_8001=[lat_anom_201230(23:44);lat_anom_231260(23:44)]
ydata_8001=[jet_vals_201230(23:44);jet_vals_231260(23:44)]

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-5,5])
plot([-8,8],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['201-260 monthly anomalies, jet latitude V front latitude, R=' ...
    num2str(r(1,2))] ,'FontSize',20)
legend('1958-1979','1980-2001')


fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_abs_2';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')


%% TEN-DAY ANOMALIES - 121-150
figure(3)
xdata_5879=[freq_anom_121130(1:22);freq_anom_131140(1:22);freq_anom_141150(1:22)]
ydata_5879=[jet_vals_121130(1:22);jet_vals_131140(1:22);jet_vals_141150(1:22);]

xdata_8001=[freq_anom_121130(23:44);freq_anom_131140(23:44);freq_anom_141150(23:44)]
ydata_8001=[jet_vals_121130(23:44);jet_vals_131140(23:44);jet_vals_141150(23:44);]

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-50,50])
plot([-50,50],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['121-150, 10-day bins, jet latitude V front frequency, R=' ...
    num2str(r(1,2))] ,'FontSize',20)
legend('1958-1979','1980-2001')


fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_abs_3';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')



%% TEN-DAY ANOMALIES - 201-250
figure(4)
xdata_5879=[lat_anom_201210(1:22);lat_anom_211220(1:22);lat_anom_221230(1:22); ...
lat_anom_231240(1:22);lat_anom_241250(1:22)]
ydata_5879=[jet_vals_201210(1:22);jet_vals_211220(1:22);jet_vals_221230(1:22); ...
jet_vals_231240(1:22);jet_vals_241250(1:22)]

xdata_8001=[lat_anom_201210(23:44);lat_anom_211220(23:44);lat_anom_221230(23:44); ...
lat_anom_231240(23:44);lat_anom_241250(23:44)]
ydata_8001=[jet_vals_201210(23:44);jet_vals_211220(23:44);jet_vals_221230(23:44); ...
jet_vals_231240(23:44);jet_vals_241250(23:44)]

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];

a=isnan(xdata).*[1:220]'
nans=a(a>0)
ydata(nans)=NaN
xdata=xdata(not(isnan(xdata)));
ydata=ydata(not(isnan(ydata)));

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-10,10])
plot([-10,10],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['201-250, 10-day bins, jet latitude V front latitude, R=' ...
    num2str(r(1,2))] ,'FontSize',20)
legend('1958-1979','1980-2001')


grid on

fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_abs_4';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')


%% NEW PLOTS - frontal anomalies during the Post-Meiyu with jet anomalies during the Post-Meiyu
%March 3rd 2015 - now only takes the statistics of frontal events north of
%27N.

%in addition, we test for there being significant changes in front
%frequency (even though the previously compiled statistics suggest that
%there shouldn't be).

%% MONTHLY ANOMALIES - 201-260, north of 28N
figure(11)
xdata_5879=[lat_anom_201230_north(1:22);lat_anom_231260_north(1:22)]
ydata_5879=[jet_anom_201230(1:22);jet_anom_231260(1:22)]

xdata_8001=[lat_anom_201230_north(23:44);lat_anom_231260_north(23:44)]
ydata_8001=[jet_anom_201230(23:44);jet_anom_231260(23:44)]

freq_5879=[freq_anom_201230_north(1:22);freq_anom_231260_north(1:22)]
freq_8001=[freq_anom_201230_north(1:22);freq_anom_231260_north(1:22)]

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];
freqdata=[freq_5879;freq_8001];

%account for the possibility of no frontal observations at all in a time
%period (happens in one month). needed to be able to perform linear fit of
%data
a=isnan(xdata).*[1:88]'
nans=a(a>0)
ydata(nans)=NaN
xdata=xdata(not(isnan(xdata)));
ydata=ydata(not(isnan(ydata)));

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-5.5,5.5])
plot([-5.5,5.5],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['201-260, jet latitude V front latitude (north of 27N), R=' ...
    num2str(r(1,2))] ,'FontSize',20)
legend('1958-1979','1980-2001')
axis([-5.5 5.5 -5 5])


fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_north_mth';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')


figure(12)
h1=histogram(xdata_5879,[-5.5:1:5.5])
hold on
h2=histogram(xdata_8001,[-5.5:1:5.5])

axis([-5.5 5.5 0 12])

filename='meiyu_jet_north_mth_2';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

figure(13)
h3=histogram(ydata_5879)
hold on
h4=histogram(ydata_8001)
h3.BinWidth=1
h4.BinWidth=1

filename='meiyu_jet_north_mth_3';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

pause

%% DAILY ANOMALIES - 201-250, north of 28N

figure(14)
xdata_5879=[lat_anom_201210_north(1:22);lat_anom_211220_north(1:22);lat_anom_221230_north(1:22); ...
lat_anom_231240_north(1:22);lat_anom_241250_north(1:22)]
ydata_5879=[jet_anom_201210(1:22);jet_anom_211220(1:22);jet_anom_221230(1:22); ...
jet_anom_231240(1:22);jet_anom_241250(1:22)]

xdata_8001=[lat_anom_201210_north(23:44);lat_anom_211220_north(23:44);lat_anom_221230_north(23:44); ...
lat_anom_231240_north(23:44);lat_anom_241250_north(23:44)]
ydata_8001=[jet_anom_201210(23:44);jet_anom_211220(23:44);jet_anom_221230(23:44); ...
jet_anom_231240(23:44);jet_anom_241250(23:44)]

xdata=[xdata_5879;xdata_8001];
ydata=[ydata_5879;ydata_8001];

%account for the possibility of no frontal observations at all in a time
%period (happens in one month). needed to be able to perform linear fit of
%data
a=isnan(xdata).*[1:220]'
nans=a(a>0)
ydata(nans)=NaN
xdata=xdata(not(isnan(xdata)));
ydata=ydata(not(isnan(ydata)));

plot(xdata_5879,ydata_5879,'x','Color','Blue')
hold on
plot(xdata_8001,ydata_8001,'o','Color','Red')

%linear fitting of data
P=polyfit(xdata,ydata,1)
yfit=polyval(P,[-10,10])
plot([-10,10],yfit,'Color','Black')
r=corrcoef(xdata,ydata)
title(['201-250, 10-day bins, jet latitude V front latitude (north of 27N), R=' ...
    num2str(r(1,2))] ,'FontSize',20)
legend('1958-1979','1980-2001')

filename='meiyu_jet_north_10day';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')


figure(15)
h1=histogram(xdata_5879)
hold on
h2=histogram(xdata_8001)
h1.BinWidth=1
h2.BinWidth=1

filename='meiyu_jet_north_10day_2';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

figure(16)
h3=histogram(ydata_5879)
hold on
h4=histogram(ydata_8001)
h3.BinWidth=1
h4.BinWidth=1

grid on

fold='/Users/Siwen/Documents/MATLAB';
filename='meiyu_jet_north_10day_3';
saveas(gcf,[fold,filesep,filename,'.eps'],'epsc')

