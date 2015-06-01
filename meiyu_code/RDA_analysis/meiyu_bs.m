function [f1vals,f2vals,latvals,intvals,nvals] = meiyu_bs(startday,endday,startyr1,endyr1,startyr2,endyr2,latmark,latlimit,primaryonly,tau)
%REWRITTEN BY JESSE DAY 13 MARCH 2015 - added toggle primaryonly which
%determines whether we only consider primary front events, or both primary
%and secondary events

%% FURTHER EDITS by Jesse Day April 3 2015 - now accounts for the decorrelation length scale tau.
%tau is a 2x1 vector, where tau(1) is tau for primary front, and tau(2) for
%secondary front.

%latmark - whether there is a cutoff latitude in the range considered or
%not. if 0 - none. 1 - north of the limit. -1 - south of the limit.

%latlimit - the actual value of this cutoff if it exists

%written by Jesse Day November 3rd 2014. Edited by Jesse Day 

%variables returned:
%1) Frequency of primary Meiyu events and standard deviation
%2) Frequency of secondary Meiyu events and standard deviation
%3) Mean and standard deviation in the mean of latitude
%4) Mean and standard deviation in the mean of intensity

%the variables returned are structs, each with 10 subvariables as listed:
%[allyearmean,allyearstd,period1mean,period1std,period2mean,period2std,p1,
%p2]

%where p1 is the result of using a permutation test (myperm.m) and p2 is
%the result of using bootstrapping with replacement (mybs_diff.m)

%note that the all year statistics returned are for the full set of years
%from startyr1 to endyr2, and do not leave out intervening years, for the
%sake of simplicity.

%latmark and latlimit are usually 0 - they exist in case we have a desire
%to choose a subset of results within a certain latitude range.

%%IMPORTANT - the standard deviation for binary processes is stored as a
%%true standard deviation, whereas the standard deviations of latitude and
%%intensity processes are stored as 7

%for the time being we don't do anything with the secondary front
%statistics alone.

%statistics for all years
[f1_all,f2_all,lat_all,int_all,lat2_all,int2_all]=meiyustats_compact(startday,endday,startyr1,endyr2,latmark,latlimit,primaryonly,tau);

%statistics for period 1
[f1_p1,f2_p1,lat_p1,int_p1,lat2_p1,int2_p1]=meiyustats_compact(startday,endday,startyr1,endyr1,latmark,latlimit,primaryonly,tau);

%statistics for period 2
[f1_p2,f2_p2,lat_p2,int_p2,lat2_p2,int2_p2]=meiyustats_compact(startday,endday,startyr2,endyr2,latmark,latlimit,primaryonly,tau);


%returning means and standard deviations
f1vals{1}=f1_all{1};
f1vals{2}=f1_all{2};
f1vals{3}=f1_p1{1};
f1vals{4}=f1_p1{2};
f1vals{5}=f1_p2{1};
f1vals{6}=f1_p2{2};

%returning the statistical significance of the difference
diff=f1_p2{1}-f1_p1{1};
dev=(f1_p1{2}^2+f1_p2{2}^2)^(1/2);
zscore=diff/dev;
p=normcdf(zscore);
f1vals{7}=p; %this is the true p-value based on analytic result
f1vals{8}=NaN; 

%% SECONDARY FRONT PROBABILITY

f2vals{1}=f2_all{1};
f2vals{2}=f2_all{2};
f2vals{3}=f2_p1{1};
f2vals{4}=f2_p1{2};
f2vals{5}=f2_p2{1};
f2vals{6}=f2_p2{2};

%returning the statistical significance of the difference
diff=f2_p2{1}-f2_p1{1};
dev=(f2_p1{2}^2+f2_p2{2}^2)^(1/2);
zscore=diff/dev;
p=normcdf(zscore);

f2vals{7}=p; %this is the true p-value based on analytic result
f2vals{8}=NaN; %
   

%% LATITUDE DISTRIBUTION
latvals{1}=lat_all{1};
latvals{3}=lat_p1{1};
latvals{5}=lat_p2{1};


%% standard deviation of mean - obtained by bootstrapping
%functioned used: mybs.m
s_all=lat_all{2};
s1=lat_p1{2};
s2=lat_p2{2};

n=length(s_all);
if n>0
    [av,ll,ul]=mybs(s_all,n,10000);
%ul-av
%ll-av
%pause
    latdev=(ul-ll)/2;
    latvals{2}=latdev;
    
else
    
    latvals{2}=NaN;

end    
    
n1=length(s1);

if n1>0
    [av,ll,ul]=mybs(s_all,n1,10000);
    %ul-av
    %ll-av
    %pause
    latdev=(ul-ll)/2;
    latvals{4}=latdev;
   
else
    
    latvals{4}=NaN;
    
end

n2=length(s2);

if n2>0
    [av,ll,ul]=mybs(s_all,n2,10000);
    %ul-av
    %ll-av
    %pause
    latdev=(ul-ll)/2;
    latvals{6}=latdev;
    
else
    
    latvals{6}=NaN;
    
end


%significance of difference
%relies on two different scripts: a permutation test myperm.m and a
%bootstrapping method mybs_diff.m

if ((n1>0) & (n2>0))
    [a,p,c,d]=myperm(s1',s2',10000);
    %[~,p,~,~]=myperm(s1,s2,10000)
    latvals{7}=p;

    [a,p,c,d,e]=mybs_diff(s1,s2,10000);
    latvals{8}=p;
    
else
    
    latvals{7}=NaN;
    latvals{8}=NaN;
    
end

%latvals
%pause

%% INTENSITY DISTRIBUTION
intvals{1}=int_all{1};
intvals{3}=int_p1{1};
intvals{5}=int_p2{1};

%% standard deviation of mean - obtained by bootstrapping
%functioned used: mybs.m
s_all=int_all{2};
s1=int_p1{2};
s2=int_p2{2};

n=length(s_all);

if n>0
    [av,ll,ul]=mybs(s_all,n,10000);
    %ul-av
    %ll-av
    %pause
    intdev=(ul-ll)/2;
    intvals{2}=intdev;
else
    
    intvals{2}=NaN;
    
end

n1=length(s1);

if n1>0

    [av,ll,ul]=mybs(s_all,n1,10000);
    intdev=(ul-ll)/2;
    intvals{4}=intdev;
    
else
    
    intvals{4}=NaN;
    
end

n2=length(s2);

if n2>0
    
    [av,ll,ul]=mybs(s_all,n2,10000);
    %ul-av
    %ll-av
    %pause
    intdev=(ul-ll)/2;
    intvals{6}=intdev;
    
else
    
    intvals{6}=NaN;
    
end

%significance of difference
%relies on two different scripts: a permutation test myperm.m and a
%bootstrapping method mybs_diff.m

if ((n1>0) & (n2>0))

    [a,p,c,d]=myperm(s1',s2',10000);
    %[~,p,~,~]=myperm(s1,s2,10000)
    intvals{7}=p;

    [a,p,c,d,e]=mybs_diff(s1,s2,10000);
    intvals{8}=p;

    %intvals
    %pause
    
else
    
    intvals{7}=NaN;
    intvals{8}=NaN;
    
end

%% NVALS - just returning outright numbers of events

%all events
nvals{1}=length(s_all);
nvals{2}=length(s1);
nvals{3}=length(s2);

%primary only
nvals{4}=round(nvals{1}*f1_all{1}/(f1_all{1}+f2_all{1}));
nvals{5}=round(nvals{2}*f1_p1{1}/(f1_p1{1}+f2_p1{1}));
nvals{6}=round(nvals{3}*f1_p2{1}/(f1_p2{1}+f2_p2{1}));

%secondary only
nvals{7}=round(nvals{1}*f2_all{1}/(f1_all{1}+f2_all{1}));
nvals{8}=round(nvals{2}*f2_p1{1}/(f1_p1{1}+f2_p1{1}));
nvals{9}=round(nvals{3}*f2_p2{1}/(f1_p2{1}+f2_p2{1}));

end