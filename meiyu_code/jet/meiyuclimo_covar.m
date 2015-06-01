%meiyuclimo_covar.m

%written in tandem with meiyu_jet_covar.m. This calculates the anomalies in
%Meiyu frequency for 121-150 for the years 1958-2001 versus the
%climatology, and also using the full 1951-2007 climatology (shouldn't be a
%huge difference between them). Then, we do the same thing for 201-230, and
%231-260

%In addition, script will be repeated to replicate the exact same thing
%in 10-day increments.

%EDITED by Jesse Day, March 2nd 2015 - uses the functionality of
%meiyustats_new which allows us to only consider the statistics of frontal
%events above a certain latitude.

%specifically, post-Meiyu season often sees a double front, and only the
%northern front of the two is likely to be jet-related. Therefore, we use a
%frontal cutoff of 27N (referenced to 115E), which Figure 2d shows is a time of low rainfall in
%central China.

clear all
close all

latcutoff=27;
ns=1; %north (+1) or south (-1) of 27N?

%% 121-150 - pre-Meiyu stats
years=[1958:2001];
firstyr=1958;
endyr=2001;

[all1,all2,all3,all4,all5,all6,all7]= ...
    meiyustats_new(121,150,firstyr,endyr,0,0);

lat_mean_121150=all3{1};
freq_mean_121150=all1{1};

lat_121150=zeros(44,1);
freq_121150=zeros(44,1);

for i=1:44
    
    yr=years(i)
    tic
    
    [yr1,yr2,yr3,yr4,yr5,yr6,yr7]= ...
        meiyustats_new(121,150,yr,yr,0,0);
    lat_121150(i)=yr3{1}
    freq_121150(i)=yr1{1}
    toc

end

lat_anom_121150=lat_121150-lat_mean_121150
freq_anom_121150=freq_121150-freq_mean_121150

%% 201-230 - post-Meiyu stats
years=[1958:2001];
firstyr=1958;
endyr=2001;

[all1,all2,all3,all4,all5,all6,all7]= ...
    meiyustats_new(201,230,firstyr,endyr,0,0);

lat_mean_201230=all3{1};
freq_mean_201230=all1{1};

lat_201230=zeros(44,1);
freq_201230=zeros(44,1);

for i=1:44
    
    yr=years(i)
    tic
    
    [yr1,yr2,yr3,yr4,yr5,yr6,yr7]= ...
        meiyustats_new(201,230,yr,yr,0,0);
    lat_201230(i)=yr3{1}
    freq_201230(i)=yr1{1}
    toc

end

lat_anom_201230=lat_201230-lat_mean_201230
freq_anom_201230=freq_201230-freq_mean_201230

%% NEW: only consider events NORTH of 28N, 201-230
years=[1958:2001];
firstyr=1958;
endyr=2001;

[all1,all2,all3,all4,all5,all6,all7]= ...
    meiyustats_new(201,230,firstyr,endyr,latcutoff,ns);

lat_mean_201230_north=all3{1};
freq_mean_201230_north=all1{1};

lat_201230_north=zeros(44,1);
freq_201230_north=zeros(44,1);

for i=1:44
    
    yr=years(i)
    tic
    
    [yr1,yr2,yr3,yr4,yr5,yr6,yr7]= ...
        meiyustats_new(201,230,yr,yr,latcutoff,ns);
    lat_201230_north(i)=yr3{1}
    freq_201230_north(i)=yr1{1}
    toc

end

lat_anom_201230_north=lat_201230_north-lat_mean_201230_north
freq_anom_201230_north=freq_201230_north-freq_mean_201230_north


%% 231-260 - post-Meiyu stats
years=[1958:2001];
firstyr=1958;
endyr=2001;

[all1,all2,all3,all4,all5,all6,all7]= ...
    meiyustats_new(231,260,firstyr,endyr,0,0);

lat_mean_231260=all3{1};
freq_mean_231260=all1{1};

lat_231260=zeros(44,1);
freq_231260=zeros(44,1);

for i=1:44
    
    yr=years(i)
    tic
    
    [yr1,yr2,yr3,yr4,yr5,yr6,yr7]= ...
        meiyustats_new(231,260,yr,yr,0,0);
    lat_231260(i)=yr3{1}
    freq_231260(i)=yr1{1}
    toc

end

lat_anom_231260=lat_231260-lat_mean_231260
freq_anom_231260=freq_231260-freq_mean_231260


%% NEW - 231-260 - post-Meiyu stats, NORTH of 28N
years=[1958:2001];
firstyr=1958;
endyr=2001;

[all1,all2,all3,all4,all5,all6,all7]= ...
    meiyustats_new(231,260,firstyr,endyr,latcutoff,ns);

lat_mean_231260_north=all3{1};
freq_mean_231260_north=all1{1};

lat_231260_north=zeros(44,1);
freq_231260_north=zeros(44,1);

for i=1:44
    
    yr=years(i)
    tic
    
    [yr1,yr2,yr3,yr4,yr5,yr6,yr7]= ...
        meiyustats_new(231,260,yr,yr,latcutoff,ns);
    lat_231260_north(i)=yr3{1}
    freq_231260_north(i)=yr1{1}
    toc

end

lat_anom_231260_north=lat_231260_north-lat_mean_231260_north
freq_anom_231260_north=freq_231260_north-freq_mean_231260_north

%%save data as NetCDF
savefile='meiyuclimo_covar_mth.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create variables
nccreate(savefile,'freq_121150','Dimensions',{'time',44})
nccreate(savefile,'freq_201230','Dimensions',{'time',44})
nccreate(savefile,'freq_231260','Dimensions',{'time',44})
nccreate(savefile,'lat_121150','Dimensions',{'time',44})
nccreate(savefile,'lat_201230','Dimensions',{'time',44})
nccreate(savefile,'lat_231260','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_121150','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_201230','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_231260','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_121150','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_201230','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_231260','Dimensions',{'time',44})

nccreate(savefile,'freq_201230_north','Dimensions',{'time',44})
nccreate(savefile,'freq_231260_north','Dimensions',{'time',44})
nccreate(savefile,'lat_201230_north','Dimensions',{'time',44})
nccreate(savefile,'lat_231260_north','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_201230_north','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_231260_north','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_201230_north','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_231260_north','Dimensions',{'time',44})


%write variables
ncwrite(savefile,'freq_121150',freq_121150)
ncwrite(savefile,'freq_201230',freq_201230)
ncwrite(savefile,'freq_231260',freq_231260)
ncwrite(savefile,'freq_anom_121150',freq_anom_121150)
ncwrite(savefile,'freq_anom_201230',freq_anom_201230)
ncwrite(savefile,'freq_anom_231260',freq_anom_231260)
ncwrite(savefile,'lat_121150',lat_121150)
ncwrite(savefile,'lat_201230',lat_201230)
ncwrite(savefile,'lat_231260',lat_231260)
ncwrite(savefile,'lat_anom_121150',lat_anom_121150)
ncwrite(savefile,'lat_anom_201230',lat_anom_201230)
ncwrite(savefile,'lat_anom_231260',lat_anom_231260)

ncwrite(savefile,'freq_201230_north',freq_201230_north)
ncwrite(savefile,'freq_231260_north',freq_231260_north)
ncwrite(savefile,'freq_anom_201230_north',freq_anom_201230_north)
ncwrite(savefile,'freq_anom_231260_north',freq_anom_231260_north)
ncwrite(savefile,'lat_201230_north',lat_201230_north)
ncwrite(savefile,'lat_231260_north',lat_231260_north)
ncwrite(savefile,'lat_anom_201230_north',lat_anom_201230_north)
ncwrite(savefile,'lat_anom_231260_north',lat_anom_231260_north)


movefile(savefile,'/Users/Siwen/Desktop/ferret/bin/');




%% TEN-DAY CLIMATOLOGY: same as above, but with ten-day boxes.

%% 121-150 - pre-Meiyu stats, now broken into 121-130, 131-140 and 141-150
years=[1958:2001];
firstyr=1958;
endyr=2001;

[first1,first2,first3,first4,first5,first6,first7]= ...
    meiyustats_new(121,130,firstyr,endyr,0,0);

[second1,second2,second3,second4,second5,second6,second7]= ...
    meiyustats_new(131,140,firstyr,endyr,0,0);

[third1,third2,third3,third4,third5,third6,third7]= ...
    meiyustats_new(141,150,firstyr,endyr,0,0);

lat_mean_121130=first3{1};
freq_mean_121130=first1{1};

lat_mean_131140=second3{1};
freq_mean_131140=second1{1};

lat_mean_141150=third3{1};
freq_mean_141150=third1{1};

lat_121130=zeros(44,1);
freq_121130=zeros(44,1);

lat_131140=zeros(44,1);
freq_131140=zeros(44,1);

lat_141150=zeros(44,1);
freq_141150=zeros(44,1);

for i=1:44
    
    yr=years(i);
    tic
    
    [yr_1_1,yr_1_2,yr_1_3,yr_1_4,yr_1_5,yr_1_6,yr_1_7]= ...
        meiyustats_new(121,130,yr,yr,0,0);
    lat_121130(i)=yr_1_3{1};
    freq_121130(i)=yr_1_1{1};

    [yr_2_1,yr_2_2,yr_2_3,yr_2_4,yr_2_5,yr_2_6,yr_2_7]= ...
        meiyustats_new(131,140,yr,yr,0,0);
    lat_131140(i)=yr_2_3{1};
    freq_131140(i)=yr_2_1{1};

    [yr_3_1,yr_3_2,yr_3_3,yr_3_4,yr_3_5,yr_3_6,yr_3_7]= ...
        meiyustats_new(141,150,yr,yr,0,0);
    lat_141150(i)=yr_3_3{1};
    freq_141150(i)=yr_3_1{1};

    toc

end

lat_anom_121130=lat_121130-lat_mean_121130
freq_anom_121130=freq_121130-freq_mean_121130

lat_anom_131140=lat_131140-lat_mean_131140
freq_anom_131140=freq_131140-freq_mean_131140

lat_anom_141150=lat_141150-lat_mean_141150
freq_anom_141150=freq_141150-freq_mean_141150


%% 201-250 - post-Meiyu stats
years=[1958:2001];
firstyr=1958;
endyr=2001;

[first1,first2,first3,first4,first5,first6,first7]= ...
    meiyustats_new(201,210,firstyr,endyr,0,0);

[second1,second2,second3,second4,second5,second6,second7]= ...
    meiyustats_new(211,220,firstyr,endyr,0,0);

[third1,third2,third3,third4,third5,third6,third7]= ...
    meiyustats_new(221,230,firstyr,endyr,0,0);

[fourth1,fourth2,fourth3,fourth4,fourth5,fourth6,fourth7]= ...
    meiyustats_new(231,240,firstyr,endyr,0,0);

[fifth1,fifth2,fifth3,fifth4,fifth5,fifth6,fifth7]= ...
    meiyustats_new(241,250,firstyr,endyr,0,0);

lat_mean_201210=first3{1};
freq_mean_201210=first1{1};

lat_mean_211220=second3{1};
freq_mean_211220=second1{1};

lat_mean_221230=third3{1};
freq_mean_221230=third1{1};

lat_mean_231240=fourth3{1};
freq_mean_231240=fourth1{1};

lat_mean_241250=fifth3{1};
freq_mean_241250=fifth1{1};

lat_201210=zeros(44,1);
freq_201210=zeros(44,1);

lat_211220=zeros(44,1);
freq_211220=zeros(44,1);

lat_221230=zeros(44,1);
freq_221230=zeros(44,1);

lat_231240=zeros(44,1);
freq_231240=zeros(44,1);

lat_241250=zeros(44,1);
freq_241250=zeros(44,1);


for i=1:44
    
    yr=years(i);
    tic
    
    [yr_1_1,yr_1_2,yr_1_3,yr_1_4,yr_1_5,yr_1_6,yr_1_7]= ...
        meiyustats_new(201,210,yr,yr,0,0);
    lat_201210(i)=yr_1_3{1};
    freq_201210(i)=yr_1_1{1};

    [yr_2_1,yr_2_2,yr_2_3,yr_2_4,yr_2_5,yr_2_6,yr_2_7]= ...
        meiyustats_new(211,220,yr,yr,0,0);
    lat_211220(i)=yr_2_3{1};
    freq_211220(i)=yr_2_1{1};

    [yr_3_1,yr_3_2,yr_3_3,yr_3_4,yr_3_5,yr_3_6,yr_3_7]= ...
        meiyustats_new(221,230,yr,yr,0,0);
    lat_221230(i)=yr_3_3{1};
    freq_221230(i)=yr_3_1{1};

    [yr_4_1,yr_4_2,yr_4_3,yr_4_4,yr_4_5,yr_4_6,yr_4_7]= ...
        meiyustats_new(231,240,yr,yr,0,0);
    lat_231240(i)=yr_4_3{1};
    freq_231240(i)=yr_4_1{1};

    [yr_5_1,yr_5_2,yr_5_3,yr_5_4,yr_5_5,yr_5_6,yr_5_7]= ...
        meiyustats_new(241,250,yr,yr,0,0);
    lat_241250(i)=yr_5_3{1};
    freq_241250(i)=yr_5_1{1};


    toc

end

lat_anom_201210=lat_201210-lat_mean_201210
freq_anom_201210=freq_201210-freq_mean_201210

lat_anom_211220=lat_211220-lat_mean_211220
freq_anom_211220=freq_211220-freq_mean_211220

lat_anom_221230=lat_221230-lat_mean_221230
freq_anom_221230=freq_221230-freq_mean_221230

lat_anom_231240=lat_231240-lat_mean_231240
freq_anom_231240=freq_231240-freq_mean_231240

lat_anom_241250=lat_241250-lat_mean_241250
freq_anom_241250=freq_241250-freq_mean_241250


%% NEW: 201-250 - post-Meiyu stats but ONLY NORTH OF 28N
years=[1958:2001];
firstyr=1958;
endyr=2001;

[first1,first2,first3,first4,first5,first6,first7]= ...
    meiyustats_new(201,210,firstyr,endyr,latcutoff,ns);

[second1,second2,second3,second4,second5,second6,second7]= ...
    meiyustats_new(211,220,firstyr,endyr,latcutoff,ns);

[third1,third2,third3,third4,third5,third6,third7]= ...
    meiyustats_new(221,230,firstyr,endyr,latcutoff,ns);

[fourth1,fourth2,fourth3,fourth4,fourth5,fourth6,fourth7]= ...
    meiyustats_new(231,240,firstyr,endyr,latcutoff,ns);

[fifth1,fifth2,fifth3,fifth4,fifth5,fifth6,fifth7]= ...
    meiyustats_new(241,250,firstyr,endyr,latcutoff,ns);

lat_mean_201210_north=first3{1};
freq_mean_201210_north=first1{1};

lat_mean_211220_north=second3{1};
freq_mean_211220_north=second1{1};

lat_mean_221230_north=third3{1};
freq_mean_221230_north=third1{1};

lat_mean_231240_north=fourth3{1};
freq_mean_231240_north=fourth1{1};

lat_mean_241250_north=fifth3{1};
freq_mean_241250_north=fifth1{1};

lat_201210_north=zeros(44,1);
freq_201210_north=zeros(44,1);

lat_211220_north=zeros(44,1);
freq_211220_north=zeros(44,1);

lat_221230_north=zeros(44,1);
freq_221230_north=zeros(44,1);

lat_231240_north=zeros(44,1);
freq_231240_north=zeros(44,1);

lat_241250_north=zeros(44,1);
freq_241250_north=zeros(44,1);


for i=1:44
    
    yr=years(i);
    tic
    
    [yr_1_1,yr_1_2,yr_1_3,yr_1_4,yr_1_5,yr_1_6,yr_1_7]= ...
        meiyustats_new(201,210,yr,yr,latcutoff,ns);
    lat_201210_north(i)=yr_1_3{1};
    freq_201210_north(i)=yr_1_1{1};

    [yr_2_1,yr_2_2,yr_2_3,yr_2_4,yr_2_5,yr_2_6,yr_2_7]= ...
        meiyustats_new(211,220,yr,yr,latcutoff,ns);
    lat_211220_north(i)=yr_2_3{1};
    freq_211220_north(i)=yr_2_1{1};

    [yr_3_1,yr_3_2,yr_3_3,yr_3_4,yr_3_5,yr_3_6,yr_3_7]= ...
        meiyustats_new(221,230,yr,yr,latcutoff,ns);
    lat_221230_north(i)=yr_3_3{1};
    freq_221230_north(i)=yr_3_1{1};

    [yr_4_1,yr_4_2,yr_4_3,yr_4_4,yr_4_5,yr_4_6,yr_4_7]= ...
        meiyustats_new(231,240,yr,yr,latcutoff,ns);
    lat_231240_north(i)=yr_4_3{1};
    freq_231240_north(i)=yr_4_1{1};

    [yr_5_1,yr_5_2,yr_5_3,yr_5_4,yr_5_5,yr_5_6,yr_5_7]= ...
        meiyustats_new(241,250,yr,yr,latcutoff,ns);
    lat_241250_north(i)=yr_5_3{1};
    freq_241250_north(i)=yr_5_1{1};


    toc

end

lat_anom_201210_north=lat_201210_north-lat_mean_201210_north
freq_anom_201210_north=freq_201210_north-freq_mean_201210_north

lat_anom_211220_north=lat_211220_north-lat_mean_211220_north
freq_anom_211220_north=freq_211220_north-freq_mean_211220_north

lat_anom_221230_north=lat_221230_north-lat_mean_221230_north
freq_anom_221230_north=freq_221230_north-freq_mean_221230_north

lat_anom_231240_north=lat_231240_north-lat_mean_231240_north
freq_anom_231240_north=freq_231240_north-freq_mean_231240_north

lat_anom_241250_north=lat_241250_north-lat_mean_241250_north
freq_anom_241250_north=freq_241250_north-freq_mean_241250_north



%%save data as NetCDF
savefile='meiyuclimo_covar_tenday.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create variables
nccreate(savefile,'freq_121130','Dimensions',{'time',44})
nccreate(savefile,'freq_131140','Dimensions',{'time',44})
nccreate(savefile,'freq_141150','Dimensions',{'time',44})
nccreate(savefile,'freq_201210','Dimensions',{'time',44})
nccreate(savefile,'freq_211220','Dimensions',{'time',44})
nccreate(savefile,'freq_221230','Dimensions',{'time',44})
nccreate(savefile,'freq_231240','Dimensions',{'time',44})
nccreate(savefile,'freq_241250','Dimensions',{'time',44})

nccreate(savefile,'freq_anom_121130','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_131140','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_141150','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_201210','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_211220','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_221230','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_231240','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_241250','Dimensions',{'time',44})

nccreate(savefile,'lat_121130','Dimensions',{'time',44})
nccreate(savefile,'lat_131140','Dimensions',{'time',44})
nccreate(savefile,'lat_141150','Dimensions',{'time',44})
nccreate(savefile,'lat_201210','Dimensions',{'time',44})
nccreate(savefile,'lat_211220','Dimensions',{'time',44})
nccreate(savefile,'lat_221230','Dimensions',{'time',44})
nccreate(savefile,'lat_231240','Dimensions',{'time',44})
nccreate(savefile,'lat_241250','Dimensions',{'time',44})

nccreate(savefile,'lat_anom_121130','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_131140','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_141150','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_201210','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_211220','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_221230','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_231240','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_241250','Dimensions',{'time',44})

%write variables
ncwrite(savefile,'freq_121130',freq_121130)
ncwrite(savefile,'freq_131140',freq_131140)
ncwrite(savefile,'freq_141150',freq_141150)
ncwrite(savefile,'freq_201210',freq_201210)
ncwrite(savefile,'freq_211220',freq_211220)
ncwrite(savefile,'freq_221230',freq_221230)
ncwrite(savefile,'freq_231240',freq_231240)
ncwrite(savefile,'freq_241250',freq_241250)

ncwrite(savefile,'freq_anom_121130',freq_anom_121130)
ncwrite(savefile,'freq_anom_131140',freq_anom_131140)
ncwrite(savefile,'freq_anom_141150',freq_anom_141150)
ncwrite(savefile,'freq_anom_201210',freq_anom_201210)
ncwrite(savefile,'freq_anom_211220',freq_anom_211220)
ncwrite(savefile,'freq_anom_221230',freq_anom_221230)
ncwrite(savefile,'freq_anom_231240',freq_anom_231240)
ncwrite(savefile,'freq_anom_241250',freq_anom_241250)

ncwrite(savefile,'lat_121130',lat_121130)
ncwrite(savefile,'lat_131140',lat_131140)
ncwrite(savefile,'lat_141150',lat_141150)
ncwrite(savefile,'lat_201210',lat_201210)
ncwrite(savefile,'lat_211220',lat_211220)
ncwrite(savefile,'lat_221230',lat_221230)
ncwrite(savefile,'lat_231240',lat_231240)
ncwrite(savefile,'lat_241250',lat_241250)

ncwrite(savefile,'lat_anom_121130',lat_anom_121130)
ncwrite(savefile,'lat_anom_131140',lat_anom_131140)
ncwrite(savefile,'lat_anom_141150',lat_anom_141150)
ncwrite(savefile,'lat_anom_201210',lat_anom_201210)
ncwrite(savefile,'lat_anom_211220',lat_anom_211220)
ncwrite(savefile,'lat_anom_221230',lat_anom_221230)
ncwrite(savefile,'lat_anom_231240',lat_anom_231240)
ncwrite(savefile,'lat_anom_241250',lat_anom_241250)

%%NEW VARIABLES

%new variables
nccreate(savefile,'freq_201210_north','Dimensions',{'time',44})
nccreate(savefile,'freq_211220_north','Dimensions',{'time',44})
nccreate(savefile,'freq_221230_north','Dimensions',{'time',44})
nccreate(savefile,'freq_231240_north','Dimensions',{'time',44})
nccreate(savefile,'freq_241250_north','Dimensions',{'time',44})

nccreate(savefile,'freq_anom_201210_north','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_211220_north','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_221230_north','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_231240_north','Dimensions',{'time',44})
nccreate(savefile,'freq_anom_241250_north','Dimensions',{'time',44})

nccreate(savefile,'lat_201210_north','Dimensions',{'time',44})
nccreate(savefile,'lat_211220_north','Dimensions',{'time',44})
nccreate(savefile,'lat_221230_north','Dimensions',{'time',44})
nccreate(savefile,'lat_231240_north','Dimensions',{'time',44})
nccreate(savefile,'lat_241250_north','Dimensions',{'time',44})

nccreate(savefile,'lat_anom_201210_north','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_211220_north','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_221230_north','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_231240_north','Dimensions',{'time',44})
nccreate(savefile,'lat_anom_241250_north','Dimensions',{'time',44})

ncwrite(savefile,'freq_201210_north',freq_201210_north)
ncwrite(savefile,'freq_211220_north',freq_211220_north)
ncwrite(savefile,'freq_221230_north',freq_221230_north)
ncwrite(savefile,'freq_231240_north',freq_231240_north)
ncwrite(savefile,'freq_241250_north',freq_241250_north)

ncwrite(savefile,'freq_anom_201210_north',freq_anom_201210_north)
ncwrite(savefile,'freq_anom_211220_north',freq_anom_211220_north)
ncwrite(savefile,'freq_anom_221230_north',freq_anom_221230_north)
ncwrite(savefile,'freq_anom_231240_north',freq_anom_231240_north)
ncwrite(savefile,'freq_anom_241250_north',freq_anom_241250_north)

ncwrite(savefile,'lat_201210_north',lat_201210_north)
ncwrite(savefile,'lat_211220_north',lat_211220_north)
ncwrite(savefile,'lat_221230_north',lat_221230_north)
ncwrite(savefile,'lat_231240_north',lat_231240_north)
ncwrite(savefile,'lat_241250_north',lat_241250_north)

ncwrite(savefile,'lat_anom_201210_north',lat_anom_201210_north)
ncwrite(savefile,'lat_anom_211220_north',lat_anom_211220_north)
ncwrite(savefile,'lat_anom_221230_north',lat_anom_221230_north)
ncwrite(savefile,'lat_anom_231240_north',lat_anom_231240_north)
ncwrite(savefile,'lat_anom_241250_north',lat_anom_241250_north)

movefile('/Users/Siwen/Desktop/ferret/bin/',savefile);