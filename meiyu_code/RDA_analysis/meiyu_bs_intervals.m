%meiyu_bs_intervals.m

%copied from meiyu_bs_control.m on March 12th 2015. given two year
%intervals (s1,e1) and (s2,e2) returns the mean and standard deviation of
%front frequency, latitude and intensity for each time period over the span
%of days (s,e), and then also returns the p-value of the statistical
%significance of their difference.

%we have changed the calculation by default to include both primary and
%secondary, events, which is given by the toggle primaryonly=0; can be
%changed to 1 if we want to just look at primary front events. Important
%during post-Meiyu.

%small edits by Jesse Day on April 3 2015. Now account for the temporal
%autocorrelation in calculating standard deviation and significance of
%difference. We pass the decorrelation length scale tau (units of days) to
%the functions calculating significance.


%%INTERVALS

%data stored in the same way as other time periods, except that each time
%step instead corresponds to an interval as listed below:

%1) 60-120 - Spring Rains
%2) 121-160 - Pre-Meiyu
%3) 161-120 - Meiyu
%4) 201-273 - Post-Meiyu
%5) 201-273 - Post-Meiyu, north of 27N
%6) 201-273 - Post-Meiyu, south of 27N
%7) 274-320 - Fall Rains
%8) 1-365 - Full year

%YEARS OF COMPARISON
s1=1951;
e1=1979;
s2=1980;
e2=2007;

primaryonly=0; %do we want statistics just on primary events, or on both primary and secondary events?

startday=[60 121 161 201 201 201 274 1];
endday=[120 160 200 273 273 273 320 365];
latmark=[0 0 0 0 1 -1 0 0];
latlimit=[0 0 0 0 27 27 0 0];

tau=[1.96 2.01 2.19 1.91 1.91 1.91 2.15 1.81; .95 .98 1.11 1.44 1.44 1.44 1.48 1.12]

%optional if we don't feel like using the decorrelation length scale:
%tau=ones(2,8);


%choose your time periods...
f1_all_mean=zeros(8,1);
f1_all_stdv=zeros(8,1);
f1_p1_mean=zeros(8,1);
f1_p1_stdev=zeros(8,1);
f1_p2_mean=zeros(8,1);
f1_p2_stdev=zeros(8,1);
f1_diff_p1=zeros(8,1);
f1_diff_p2=zeros(8,1);

f2_all_mean=zeros(8,1);
f2_all_stdv=zeros(8,1);
f2_p1_mean=zeros(8,1);
f2_p1_stdev=zeros(8,1);
f2_p2_mean=zeros(8,1);
f2_p2_stdev=zeros(8,1);
f2_diff_p1=zeros(8,1);
f2_diff_p2=zeros(8,1);

lat_all_mean=zeros(8,1);
lat_all_stdv=zeros(8,1);
lat_p1_mean=zeros(8,1);
lat_p1_stdev=zeros(8,1);
lat_p2_mean=zeros(8,1);
lat_p2_stdev=zeros(8,1);
lat_diff_p1=zeros(8,1);
lat_diff_p2=zeros(8,1);

int_all_mean=zeros(8,1);
int_all_stdv=zeros(8,1);
int_p1_mean=zeros(8,1);
int_p1_stdev=zeros(8,1);
int_p2_mean=zeros(8,1);
int_p2_stdev=zeros(8,1);
int_diff_p1=zeros(8,1);
int_diff_p2=zeros(8,1);

n_tot=zeros(8,1);
n_p1=zeros(8,1);
n_p2=zeros(8,1);
n1_tot=zeros(8,1);
n1_p1=zeros(8,1);
n1_p2=zeros(8,1);
n2_tot=zeros(8,1);
n2_p1=zeros(8,1);
n2_p2=zeros(8,1);


for i=1:8 %number of different time periods studied.
    
    i
    
    s=startday(i);
    e=endday(i);
    latm=latmark(i);
    latl=latlimit(i);
    mytau=tau(:,i);
    
    [f1,f2,lat,int,nn]=meiyu_bs(s,e,s1,e1,s2,e2,latm,latl,primaryonly,mytau); %returns structs
    
    f1_all_mean(i)=f1{1};
    f1_all_stdv(i)=f1{2};
    f1_p1_mean(i)=f1{3};
    f1_p1_stdv(i)=f1{4};
    f1_p2_mean(i)=f1{5};
    f1_p2_stdv(i)=f1{6};
    f1_diff_p1(i)=f1{7};
    f1_diff_p2(i)=f1{8};
    
    f2_all_mean(i)=f2{1};
    f2_all_stdv(i)=f2{2};
    f2_p1_mean(i)=f2{3};
    f2_p1_stdv(i)=f2{4};
    f2_p2_mean(i)=f2{5};
    f2_p2_stdv(i)=f2{6};
    f2_diff_p1(i)=f2{7};
    f2_diff_p2(i)=f2{8};
    
    lat_all_mean(i)=lat{1};
    lat_all_stdv(i)=lat{2};
    lat_p1_mean(i)=lat{3};
    lat_p1_stdv(i)=lat{4};
    lat_p2_mean(i)=lat{5};
    lat_p2_stdv(i)=lat{6};
    lat_diff_p1(i)=lat{7};
    lat_diff_p2(i)=lat{8};
    
    int_all_mean(i)=int{1};
    int_all_stdv(i)=int{2};
    int_p1_mean(i)=int{3};
    int_p1_stdv(i)=int{4};
    int_p2_mean(i)=int{5};
    int_p2_stdv(i)=int{6};
    int_diff_p1(i)=int{7};
    int_diff_p2(i)=int{8};
    
    n_tot(i)=nn{1};
    n_p1(i)=nn{2};
    n_p2(i)=nn{3};
    n1_tot(i)=nn{4};
    n1_p1(i)=nn{5};
    n1_p2(i)=nn{6};
    n2_tot(i)=nn{7};
    n2_p1(i)=nn{8};
    n2_p2(i)=nn{9};
    
end

savefile='mybs_5179_8007_tau.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

nccreate(savefile,'f1_all_mean','Dimensions',{'time',8})
nccreate(savefile,'f1_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'f1_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'f1_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'f1_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'f1_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'f1_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'f1_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'f2_all_mean','Dimensions',{'time',8})
nccreate(savefile,'f2_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'f2_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'f2_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'f2_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'f2_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'f2_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'f2_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'lat_all_mean','Dimensions',{'time',8})
nccreate(savefile,'lat_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'lat_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'lat_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'lat_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'lat_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'lat_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'lat_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'int_all_mean','Dimensions',{'time',8})
nccreate(savefile,'int_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'int_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'int_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'int_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'int_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'int_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'int_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'n_tot','Dimensions',{'time',8})
nccreate(savefile,'n_p1','Dimensions',{'time',8})
nccreate(savefile,'n_p2','Dimensions',{'time',8})
nccreate(savefile,'n1_tot','Dimensions',{'time',8})
nccreate(savefile,'n1_p1','Dimensions',{'time',8})
nccreate(savefile,'n1_p2','Dimensions',{'time',8})
nccreate(savefile,'n2_tot','Dimensions',{'time',8})
nccreate(savefile,'n2_p1','Dimensions',{'time',8})
nccreate(savefile,'n2_p2','Dimensions',{'time',8})


ncwrite(savefile,'f1_all_mean',f1_all_mean)
ncwrite(savefile,'f1_all_stdv',f1_all_stdv)
ncwrite(savefile,'f1_p1_mean',f1_p1_mean)
ncwrite(savefile,'f1_p1_stdv',f1_p1_stdv)
ncwrite(savefile,'f1_p2_mean',f1_p2_mean)
ncwrite(savefile,'f1_p2_stdv',f1_p2_stdv)
ncwrite(savefile,'f1_diff_p1',f1_diff_p1)
ncwrite(savefile,'f1_diff_p2',f1_diff_p2)

ncwrite(savefile,'f2_all_mean',f2_all_mean)
ncwrite(savefile,'f2_all_stdv',f2_all_stdv)
ncwrite(savefile,'f2_p1_mean',f2_p1_mean)
ncwrite(savefile,'f2_p1_stdv',f2_p1_stdv)
ncwrite(savefile,'f2_p2_mean',f2_p2_mean)
ncwrite(savefile,'f2_p2_stdv',f2_p2_stdv)
ncwrite(savefile,'f2_diff_p1',f2_diff_p1)
ncwrite(savefile,'f2_diff_p2',f2_diff_p2)

ncwrite(savefile,'lat_all_mean',lat_all_mean)
ncwrite(savefile,'lat_all_stdv',lat_all_stdv)
ncwrite(savefile,'lat_p1_mean',lat_p1_mean)
ncwrite(savefile,'lat_p1_stdv',lat_p1_stdv)
ncwrite(savefile,'lat_p2_mean',lat_p2_mean)
ncwrite(savefile,'lat_p2_stdv',lat_p2_stdv)
ncwrite(savefile,'lat_diff_p1',lat_diff_p1)
ncwrite(savefile,'lat_diff_p2',lat_diff_p2)

ncwrite(savefile,'int_all_mean',int_all_mean)
ncwrite(savefile,'int_all_stdv',int_all_stdv)
ncwrite(savefile,'int_p1_mean',int_p1_mean)
ncwrite(savefile,'int_p1_stdv',int_p1_stdv)
ncwrite(savefile,'int_p2_mean',int_p2_mean)
ncwrite(savefile,'int_p2_stdv',int_p2_stdv)
ncwrite(savefile,'int_diff_p1',int_diff_p1)
ncwrite(savefile,'int_diff_p2',int_diff_p2)

ncwrite(savefile,'n_tot',n_tot)
ncwrite(savefile,'n_p1',n_p1)
ncwrite(savefile,'n_p2',n_p2)
ncwrite(savefile,'n1_tot',n1_tot)
ncwrite(savefile,'n1_p1',n1_p1)
ncwrite(savefile,'n1_p2',n1_p2)
ncwrite(savefile,'n2_tot',n2_tot)
ncwrite(savefile,'n2_p1',n2_p1)
ncwrite(savefile,'n2_p2',n2_p2)

movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')


clear f1_all_mean f1_all_stdv f1_p1_mean f1_p1_stdv f1_p2_mean f1_p2_stdev;
clear f1_diff_p1 f1_diff_p2;
clear f2_all_mean f2_all_stdv f2_p1_mean f2_p1_stdv f2_p2_mean f2_p2_stdev;
clear f2_diff_p1 f2_diff_p2;
clear lat_all_mean lat_all_stdv lat_p1_mean lat_p1_stdv lat_p2_mean lat_p2_stdev;
clear lat_diff_p1 lat_diff_p2;
clear int_all_mean int_all_stdv int_p1_mean int_p1_stdv int_p2_mean int_p2_stdev;
clear int_diff_p1 int_diff_p2;
clear n_tot n_p1 n_p2 n1_tot n1_p1 n1_p2 n2_tot n2_p1 n2_p2;
 



%% 1958-1979 v 1980-2001
s1=1958;
e1=1979;
s2=1980;
e2=2001;

primaryonly=0


%1) 60-120 - Spring Rains
%2) 121-160 - Pre-Meiyu
%3) 161-120 - Meiyu
%4) 201-273 - Post-Meiyu
%5) 201-273 - Post-Meiyu, north of 27N
%6) 201-273 - Post-Meiyu, south of 27N
%7) 274-320 - Fall Rains
%8) 1-365 - Full year

%time periods as described above
startday=[60 121 161 201 201 201 274 1];
endday=[120 160 200 273 273 273 320 365];
latmark=[0 0 0 0 1 -1 0 0];
latlimit=[0 0 0 0 27 27 0 0];

tau=[1.96 2.01 2.19 1.91 1.91 1.91 2.15 1.81; .95 .98 1.11 1.44 1.44 1.44 1.48 1.12]

%optional if we don't feel like using the decorrelation length scale:
%tau=ones(2,8);

%choose your time periods...
f1_all_mean=zeros(8,1);
f1_all_stdv=zeros(8,1);
f1_p1_mean=zeros(8,1);
f1_p1_stdev=zeros(8,1);
f1_p2_mean=zeros(8,1);
f1_p2_stdev=zeros(8,1);
f1_diff_p1=zeros(8,1);
f1_diff_p2=zeros(8,1);

f2_all_mean=zeros(8,1);
f2_all_stdv=zeros(8,1);
f2_p1_mean=zeros(8,1);
f2_p1_stdev=zeros(8,1);
f2_p2_mean=zeros(8,1);
f2_p2_stdev=zeros(8,1);
f2_diff_p1=zeros(8,1);
f2_diff_p2=zeros(8,1);

lat_all_mean=zeros(8,1);
lat_all_stdv=zeros(8,1);
lat_p1_mean=zeros(8,1);
lat_p1_stdev=zeros(8,1);
lat_p2_mean=zeros(8,1);
lat_p2_stdev=zeros(8,1);
lat_diff_p1=zeros(8,1);
lat_diff_p2=zeros(8,1);

int_all_mean=zeros(8,1);
int_all_stdv=zeros(8,1);
int_p1_mean=zeros(8,1);
int_p1_stdev=zeros(8,1);
int_p2_mean=zeros(8,1);
int_p2_stdev=zeros(8,1);
int_diff_p1=zeros(8,1);
int_diff_p2=zeros(8,1);

n_tot=zeros(8,1);
n_p1=zeros(8,1);
n_p2=zeros(8,1);
n1_tot=zeros(8,1);
n1_p1=zeros(8,1);
n1_p2=zeros(8,1);
n2_tot=zeros(8,1);
n2_p1=zeros(8,1);
n2_p2=zeros(8,1);


for i=1:8 %number of different time periods studied.
    
    i
    
    s=startday(i);
    e=endday(i);
    latm=latmark(i);
    latl=latlimit(i);
    mytau=tau(:,i);
    
    [f1,f2,lat,int,nn]=meiyu_bs(s,e,s1,e1,s2,e2,latm,latl,primaryonly,tau); %returns structs
    
    f1_all_mean(i)=f1{1};
    f1_all_stdv(i)=f1{2};
    f1_p1_mean(i)=f1{3};
    f1_p1_stdv(i)=f1{4};
    f1_p2_mean(i)=f1{5};
    f1_p2_stdv(i)=f1{6};
    f1_diff_p1(i)=f1{7};
    f1_diff_p2(i)=f1{8};
    
    f2_all_mean(i)=f2{1};
    f2_all_stdv(i)=f2{2};
    f2_p1_mean(i)=f2{3};
    f2_p1_stdv(i)=f2{4};
    f2_p2_mean(i)=f2{5};
    f2_p2_stdv(i)=f2{6};
    f2_diff_p1(i)=f2{7};
    f2_diff_p2(i)=f2{8};
    
    lat_all_mean(i)=lat{1};
    lat_all_stdv(i)=lat{2};
    lat_p1_mean(i)=lat{3};
    lat_p1_stdv(i)=lat{4};
    lat_p2_mean(i)=lat{5};
    lat_p2_stdv(i)=lat{6};
    lat_diff_p1(i)=lat{7};
    lat_diff_p2(i)=lat{8};
    
    int_all_mean(i)=int{1};
    int_all_stdv(i)=int{2};
    int_p1_mean(i)=int{3};
    int_p1_stdv(i)=int{4};
    int_p2_mean(i)=int{5};
    int_p2_stdv(i)=int{6};
    int_diff_p1(i)=int{7};
    int_diff_p2(i)=int{8};
    
    n_tot(i)=nn{1};
    n_p1(i)=nn{2};
    n_p2(i)=nn{3};
    n1_tot(i)=nn{4};
    n1_p1(i)=nn{5};
    n1_p2(i)=nn{6};
    n2_tot(i)=nn{7};
    n2_p1(i)=nn{8};
    n2_p2(i)=nn{9};
    
end

savefile='mybs_5879_8001_tau.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

nccreate(savefile,'f1_all_mean','Dimensions',{'time',8})
nccreate(savefile,'f1_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'f1_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'f1_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'f1_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'f1_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'f1_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'f1_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'f2_all_mean','Dimensions',{'time',8})
nccreate(savefile,'f2_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'f2_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'f2_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'f2_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'f2_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'f2_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'f2_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'lat_all_mean','Dimensions',{'time',8})
nccreate(savefile,'lat_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'lat_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'lat_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'lat_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'lat_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'lat_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'lat_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'int_all_mean','Dimensions',{'time',8})
nccreate(savefile,'int_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'int_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'int_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'int_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'int_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'int_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'int_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'n_tot','Dimensions',{'time',8})
nccreate(savefile,'n_p1','Dimensions',{'time',8})
nccreate(savefile,'n_p2','Dimensions',{'time',8})
nccreate(savefile,'n1_tot','Dimensions',{'time',8})
nccreate(savefile,'n1_p1','Dimensions',{'time',8})
nccreate(savefile,'n1_p2','Dimensions',{'time',8})
nccreate(savefile,'n2_tot','Dimensions',{'time',8})
nccreate(savefile,'n2_p1','Dimensions',{'time',8})
nccreate(savefile,'n2_p2','Dimensions',{'time',8})


ncwrite(savefile,'f1_all_mean',f1_all_mean)
ncwrite(savefile,'f1_all_stdv',f1_all_stdv)
ncwrite(savefile,'f1_p1_mean',f1_p1_mean)
ncwrite(savefile,'f1_p1_stdv',f1_p1_stdv)
ncwrite(savefile,'f1_p2_mean',f1_p2_mean)
ncwrite(savefile,'f1_p2_stdv',f1_p2_stdv)
ncwrite(savefile,'f1_diff_p1',f1_diff_p1)
ncwrite(savefile,'f1_diff_p2',f1_diff_p2)

ncwrite(savefile,'f2_all_mean',f2_all_mean)
ncwrite(savefile,'f2_all_stdv',f2_all_stdv)
ncwrite(savefile,'f2_p1_mean',f2_p1_mean)
ncwrite(savefile,'f2_p1_stdv',f2_p1_stdv)
ncwrite(savefile,'f2_p2_mean',f2_p2_mean)
ncwrite(savefile,'f2_p2_stdv',f2_p2_stdv)
ncwrite(savefile,'f2_diff_p1',f2_diff_p1)
ncwrite(savefile,'f2_diff_p2',f2_diff_p2)

ncwrite(savefile,'lat_all_mean',lat_all_mean)
ncwrite(savefile,'lat_all_stdv',lat_all_stdv)
ncwrite(savefile,'lat_p1_mean',lat_p1_mean)
ncwrite(savefile,'lat_p1_stdv',lat_p1_stdv)
ncwrite(savefile,'lat_p2_mean',lat_p2_mean)
ncwrite(savefile,'lat_p2_stdv',lat_p2_stdv)
ncwrite(savefile,'lat_diff_p1',lat_diff_p1)
ncwrite(savefile,'lat_diff_p2',lat_diff_p2)

ncwrite(savefile,'int_all_mean',int_all_mean)
ncwrite(savefile,'int_all_stdv',int_all_stdv)
ncwrite(savefile,'int_p1_mean',int_p1_mean)
ncwrite(savefile,'int_p1_stdv',int_p1_stdv)
ncwrite(savefile,'int_p2_mean',int_p2_mean)
ncwrite(savefile,'int_p2_stdv',int_p2_stdv)
ncwrite(savefile,'int_diff_p1',int_diff_p1)
ncwrite(savefile,'int_diff_p2',int_diff_p2)

ncwrite(savefile,'n_tot',n_tot)
ncwrite(savefile,'n_p1',n_p1)
ncwrite(savefile,'n_p2',n_p2)
ncwrite(savefile,'n1_tot',n1_tot)
ncwrite(savefile,'n1_p1',n1_p1)
ncwrite(savefile,'n1_p2',n1_p2)
ncwrite(savefile,'n2_tot',n2_tot)
ncwrite(savefile,'n2_p1',n2_p1)
ncwrite(savefile,'n2_p2',n2_p2)
movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')


clear f1_all_mean f1_all_stdv f1_p1_mean f1_p1_stdv f1_p2_mean f1_p2_stdev;
clear f1_diff_p1 f1_diff_p2;
clear f2_all_mean f2_all_stdv f2_p1_mean f2_p1_stdv f2_p2_mean f2_p2_stdev;
clear f2_diff_p1 f2_diff_p2;
clear lat_all_mean lat_all_stdv lat_p1_mean lat_p1_stdv lat_p2_mean lat_p2_stdev;
clear lat_diff_p1 lat_diff_p2;
clear int_all_mean int_all_stdv int_p1_mean int_p1_stdv int_p2_mean int_p2_stdev;
clear int_diff_p1 int_diff_p2;




%% 1979-1993 v 1994-2007
s1=1979;
e1=1993;
s2=1994;
e2=2007;

primaryonly=0


%1) 60-120 - Spring Rains
%2) 121-160 - Pre-Meiyu
%3) 161-120 - Meiyu
%4) 201-273 - Post-Meiyu
%5) 201-273 - Post-Meiyu, north of 27N
%6) 201-273 - Post-Meiyu, south of 27N
%7) 274-320 - Fall Rains
%8) 1-365 - Full year

%time periods as described above
startday=[60 121 161 201 201 201 274 1];
endday=[120 160 200 273 273 273 320 365];
latmark=[0 0 0 0 1 -1 0 0];
latlimit=[0 0 0 0 27 27 0 0];

tau=[1.96 2.01 2.19 1.91 1.91 1.91 2.15 1.81; .95 .98 1.11 1.44 1.44 1.44 1.48 1.12]

%optional if we don't feel like using the decorrelation length scale:
%tau=ones(2,8);


%choose your time periods...
f1_all_mean=zeros(8,1);
f1_all_stdv=zeros(8,1);
f1_p1_mean=zeros(8,1);
f1_p1_stdev=zeros(8,1);
f1_p2_mean=zeros(8,1);
f1_p2_stdev=zeros(8,1);
f1_diff_p1=zeros(8,1);
f1_diff_p2=zeros(8,1);

f2_all_mean=zeros(8,1);
f2_all_stdv=zeros(8,1);
f2_p1_mean=zeros(8,1);
f2_p1_stdev=zeros(8,1);
f2_p2_mean=zeros(8,1);
f2_p2_stdev=zeros(8,1);
f2_diff_p1=zeros(8,1);
f2_diff_p2=zeros(8,1);

lat_all_mean=zeros(8,1);
lat_all_stdv=zeros(8,1);
lat_p1_mean=zeros(8,1);
lat_p1_stdev=zeros(8,1);
lat_p2_mean=zeros(8,1);
lat_p2_stdev=zeros(8,1);
lat_diff_p1=zeros(8,1);
lat_diff_p2=zeros(8,1);

int_all_mean=zeros(8,1);
int_all_stdv=zeros(8,1);
int_p1_mean=zeros(8,1);
int_p1_stdev=zeros(8,1);
int_p2_mean=zeros(8,1);
int_p2_stdev=zeros(8,1);
int_diff_p1=zeros(8,1);
int_diff_p2=zeros(8,1);

n_tot=zeros(8,1);
n_p1=zeros(8,1);
n_p2=zeros(8,1);
n1_tot=zeros(8,1);
n1_p1=zeros(8,1);
n1_p2=zeros(8,1);
n2_tot=zeros(8,1);
n2_p1=zeros(8,1);
n2_p2=zeros(8,1);


for i=1:8 %number of different time periods studied.
    
    i
    
    s=startday(i);
    e=endday(i);
    latm=latmark(i);
    latl=latlimit(i);
    mytau=tau(:,i);
    [f1,f2,lat,int,nn]=meiyu_bs(s,e,s1,e1,s2,e2,latm,latl,primaryonly,mytau); %returns structs
    
    f1_all_mean(i)=f1{1};
    f1_all_stdv(i)=f1{2};
    f1_p1_mean(i)=f1{3};
    f1_p1_stdv(i)=f1{4};
    f1_p2_mean(i)=f1{5};
    f1_p2_stdv(i)=f1{6};
    f1_diff_p1(i)=f1{7};
    f1_diff_p2(i)=f1{8};
    
    f2_all_mean(i)=f2{1};
    f2_all_stdv(i)=f2{2};
    f2_p1_mean(i)=f2{3};
    f2_p1_stdv(i)=f2{4};
    f2_p2_mean(i)=f2{5};
    f2_p2_stdv(i)=f2{6};
    f2_diff_p1(i)=f2{7};
    f2_diff_p2(i)=f2{8};
    
    lat_all_mean(i)=lat{1};
    lat_all_stdv(i)=lat{2};
    lat_p1_mean(i)=lat{3};
    lat_p1_stdv(i)=lat{4};
    lat_p2_mean(i)=lat{5};
    lat_p2_stdv(i)=lat{6};
    lat_diff_p1(i)=lat{7};
    lat_diff_p2(i)=lat{8};
    
    int_all_mean(i)=int{1};
    int_all_stdv(i)=int{2};
    int_p1_mean(i)=int{3};
    int_p1_stdv(i)=int{4};
    int_p2_mean(i)=int{5};
    int_p2_stdv(i)=int{6};
    int_diff_p1(i)=int{7};
    int_diff_p2(i)=int{8};
    
    n_tot(i)=nn{1};
    n_p1(i)=nn{2};
    n_p2(i)=nn{3};
    n1_tot(i)=nn{4};
    n1_p1(i)=nn{5};
    n1_p2(i)=nn{6};
    n2_tot(i)=nn{7};
    n2_p1(i)=nn{8};
    n2_p2(i)=nn{9};
    
end

savefile='mybs_7993_9407_tau.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

nccreate(savefile,'f1_all_mean','Dimensions',{'time',8})
nccreate(savefile,'f1_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'f1_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'f1_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'f1_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'f1_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'f1_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'f1_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'f2_all_mean','Dimensions',{'time',8})
nccreate(savefile,'f2_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'f2_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'f2_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'f2_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'f2_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'f2_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'f2_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'lat_all_mean','Dimensions',{'time',8})
nccreate(savefile,'lat_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'lat_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'lat_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'lat_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'lat_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'lat_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'lat_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'int_all_mean','Dimensions',{'time',8})
nccreate(savefile,'int_all_stdv','Dimensions',{'time',8})
nccreate(savefile,'int_p1_mean','Dimensions',{'time',8})
nccreate(savefile,'int_p1_stdv','Dimensions',{'time',8})
nccreate(savefile,'int_p2_mean','Dimensions',{'time',8})
nccreate(savefile,'int_p2_stdv','Dimensions',{'time',8})
nccreate(savefile,'int_diff_p1','Dimensions',{'time',8})
nccreate(savefile,'int_diff_p2','Dimensions',{'time',8})

nccreate(savefile,'n_tot','Dimensions',{'time',8})
nccreate(savefile,'n_p1','Dimensions',{'time',8})
nccreate(savefile,'n_p2','Dimensions',{'time',8})
nccreate(savefile,'n1_tot','Dimensions',{'time',8})
nccreate(savefile,'n1_p1','Dimensions',{'time',8})
nccreate(savefile,'n1_p2','Dimensions',{'time',8})
nccreate(savefile,'n2_tot','Dimensions',{'time',8})
nccreate(savefile,'n2_p1','Dimensions',{'time',8})
nccreate(savefile,'n2_p2','Dimensions',{'time',8})


ncwrite(savefile,'f1_all_mean',f1_all_mean)
ncwrite(savefile,'f1_all_stdv',f1_all_stdv)
ncwrite(savefile,'f1_p1_mean',f1_p1_mean)
ncwrite(savefile,'f1_p1_stdv',f1_p1_stdv)
ncwrite(savefile,'f1_p2_mean',f1_p2_mean)
ncwrite(savefile,'f1_p2_stdv',f1_p2_stdv)
ncwrite(savefile,'f1_diff_p1',f1_diff_p1)
ncwrite(savefile,'f1_diff_p2',f1_diff_p2)

ncwrite(savefile,'f2_all_mean',f2_all_mean)
ncwrite(savefile,'f2_all_stdv',f2_all_stdv)
ncwrite(savefile,'f2_p1_mean',f2_p1_mean)
ncwrite(savefile,'f2_p1_stdv',f2_p1_stdv)
ncwrite(savefile,'f2_p2_mean',f2_p2_mean)
ncwrite(savefile,'f2_p2_stdv',f2_p2_stdv)
ncwrite(savefile,'f2_diff_p1',f2_diff_p1)
ncwrite(savefile,'f2_diff_p2',f2_diff_p2)

ncwrite(savefile,'lat_all_mean',lat_all_mean)
ncwrite(savefile,'lat_all_stdv',lat_all_stdv)
ncwrite(savefile,'lat_p1_mean',lat_p1_mean)
ncwrite(savefile,'lat_p1_stdv',lat_p1_stdv)
ncwrite(savefile,'lat_p2_mean',lat_p2_mean)
ncwrite(savefile,'lat_p2_stdv',lat_p2_stdv)
ncwrite(savefile,'lat_diff_p1',lat_diff_p1)
ncwrite(savefile,'lat_diff_p2',lat_diff_p2)

ncwrite(savefile,'int_all_mean',int_all_mean)
ncwrite(savefile,'int_all_stdv',int_all_stdv)
ncwrite(savefile,'int_p1_mean',int_p1_mean)
ncwrite(savefile,'int_p1_stdv',int_p1_stdv)
ncwrite(savefile,'int_p2_mean',int_p2_mean)
ncwrite(savefile,'int_p2_stdv',int_p2_stdv)
ncwrite(savefile,'int_diff_p1',int_diff_p1)
ncwrite(savefile,'int_diff_p2',int_diff_p2)

ncwrite(savefile,'n_tot',n_tot)
ncwrite(savefile,'n_p1',n_p1)
ncwrite(savefile,'n_p2',n_p2)
ncwrite(savefile,'n1_tot',n1_tot)
ncwrite(savefile,'n1_p1',n1_p1)
ncwrite(savefile,'n1_p2',n1_p2)
ncwrite(savefile,'n2_tot',n2_tot)
ncwrite(savefile,'n2_p1',n2_p1)
ncwrite(savefile,'n2_p2',n2_p2)


movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')


clear f1_all_mean f1_all_stdv f1_p1_mean f1_p1_stdv f1_p2_mean f1_p2_stdev;
clear f1_diff_p1 f1_diff_p2;
clear f2_all_mean f2_all_stdv f2_p1_mean f2_p1_stdv f2_p2_mean f2_p2_stdev;
clear f2_diff_p1 f2_diff_p2;
clear lat_all_mean lat_all_stdv lat_p1_mean lat_p1_stdv lat_p2_mean lat_p2_stdev;
clear lat_diff_p1 lat_diff_p2;
clear int_all_mean int_all_stdv int_p1_mean int_p1_stdv int_p2_mean int_p2_stdev;
clear int_diff_p1 int_diff_p2;