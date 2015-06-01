%meiyu_autocorr.m

%want to check if any of our variables are auto-correlated. If so,
%important consequences - bootstrapping method used should be a moving
%blocks formulation, with blocks of length tau (where tau is
%autocorrelation length scale).

clear all;
close all;

%%LOAD NETCDF DATA

%front presence
countit_1=ncread('meiyu_clean.nc','countit_1');
countit_2=ncread('meiyu_clean.nc','countit_2');

%rainfall
Pchina=ncread('Pchina.nc','PCHINA');


%%% ASSOCIATE DATE WITH EACH DAY
daynum=zeros(20819,1);

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



%% LOAD MEIYU CLIMATOLOGY

freq1=ncread('meiyuclimo_final.nc','freq1');
freq2=ncread('meiyuclimo_final.nc','freq2');

countit_1_anom=zeros(size(countit_1));
countit_2_anom=zeros(size(countit_2));

for dd=1:20819
    
    day=daynum(dd);
    
    if day==366
        day=365;
    end   
     
    f1=freq1(day);
    f2=freq2(day);
    countit_1_anom(dd)=countit_1(day)-f1;
    countit_2_anom(dd)=countit_2(day)-f2;
    
    f1_dev=(f1*(1-f1)/57)^.5;
    f2_dev=(f2*(1-f2)/57)^.5;
   
    countit_1_anom_norm(dd)=countit_1_anom(dd)/f1_dev;
    countit_2_anom_norm(dd)=countit_2_anom(dd)/f2_dev;
    
    if f2_dev==0
        countit_2_anom_norm(dd)=countit_2_anom(dd);
    end
    
end


%%STEP 1 - remove seasonal cycle

%optional - normalize each day's observation by the standard deviation on
%that day (implicitly assumes that rainfall is normal



%% PRECIPITATION

% make china rainfall climatology.
Psum=zeros(80,365);
Psample=zeros(80,365,57);
counter=zeros(365);

for dd=1:20819
   
    day=daynum(dd);
    
    
    if day~=366

        Psum(:,day)=Psum(:,day)+Pchina(:,dd);
        counter(day)=counter(day)+1;
        cc=counter(day);
        Psample(:,day,cc)=Pchina(:,dd);

    end
       
end

Psum=Psum/57;

%find standard deviation of rainfall events
Pdev=zeros(80,365);

for dd=1:365
    
    for i=1:80
    
        sample=Psample(i,dd,:);
        s=permute(sample,[3 1 2]);
        Pdev(i,dd)=std(s);
        
    end
    
end
        

%% FIND ANOMALIES
Pchina_anom=zeros(80,20819);
Pchina_anom_norm=zeros(80,20819);

for dd=1:20819
   
    day=daynum(dd);
    
    if day==366
        day=365;
    end
    
    Pnorm=Psum(:,day);
    Pchina_anom(:,dd)=Pchina(:,dd)-Pnorm;
%     
%     Pchina(:,dd)
%     pause
%     Pnorm
%     pause
%     Pchina_anom(:,dd)
%     pause

    %%OPTIONAL - normalize anomaly
    stdv=Pdev(:,day);
    Pchina_anom_norm(:,dd)=Pchina_anom(:,dd)./stdv;
    
end


%% CALCULATE AUTOCORRELATION

%%FRONT PRESENCE

%find autocorrelation for lags l=1:365
f1_ac=zeros(1,364);
f1_ac=acf(countit_1_anom,364)
pause

f1_ac_alt=zeros(1,364);
f1_ac_alt=acf(countit_1_anom_norm',364)
pause

for i=1:364
    q1(i)=1+2*sum(f1_ac(1:i));
    q2(i)=1+2*sum(f1_ac_alt(1:i));
end

plot(q1)
hold on
plot(q2)
pause

%find decorrelation length scale tau    
tau_f1_ac=1+2*sum(f1_ac)


f2_ac=zeros(1,50);
f2_ac=acf(countit_2_anom_norm',50)

%find decorrelation length scale tau    
tau_f2_ac=1+2*sum(f2_ac)


%%RAINFALL

%find autocorrelation for lags l=1:365
Pchina_ac=zeros(80,50);
tau_pchina_ac=zeros(80,1);

for i=1:80

    Pchina_ac(i,:)=acf(Pchina_anom(i,:)',50);
    
end

%find decorrelation length scale tau

for i=1:80
    
    tau_pchina_ac(i)=1+2*sum(Pchina_ac(i,:));
    
end


%% CALCULATE AUTOCORRELATION FOR ARBITRARY TIME PERIODS

%Spring
dmin=60
dmax=120
ct_1=countit_1;
f=mean(freq1(dmin:dmax))
ct_1(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_1,30)
tau_ct=1+2*sum(acf_ct(1:10))
tau_30=1+2*sum(acf_ct(1:30))
pause


%Pre-Meiyu
dmin=121
dmax=160
ct_1=countit_1;
f=mean(freq1(dmin:dmax))
ct_1(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_1,30)
tau_ct=1+2*sum(acf_ct(1:10))
tau_30=1+2*sum(acf_ct(1:30))
pause


%Meiyu
dmin=161
dmax=200
ct_1=countit_1;
f=mean(freq1(dmin:dmax))
ct_1(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_1,30)
tau_ct=1+2*sum(acf_ct(1:10))
tau_30=1+2*sum(acf_ct(1:30))
pause


%Post-Meiyu
dmin=201
dmax=273
ct_1=countit_1;
f=mean(freq1(dmin:dmax))
ct_1(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_1,30)
tau_ct=1+2*sum(acf_ct(1:10))
tau_30=1+2*sum(acf_ct(1:30))
pause

%Fall
dmin=274
dmax=320
ct_1=countit_1;
f=mean(freq1(dmin:dmax))
ct_1(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_1,30)
tau_ct=1+2*sum(acf_ct(1:10))
tau_30=1+2*sum(acf_ct(1:30))


%% SECONDARY FREQUENCY

%Spring
dmin=60
dmax=120
ct_2=countit_2;
f=mean(freq2(dmin:dmax))
ct_2(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_2,30)
tau_ct=1+2*sum(acf_ct(2:10))
tau_30=1+2*sum(acf_ct(2:30))
pause


%Pre-Meiyu
dmin=121
dmax=160
ct_2=countit_2;
f=mean(freq2(dmin:dmax))
ct_2(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_2,30)
tau_ct=1+2*sum(acf_ct(2:10))
tau_30=1+2*sum(acf_ct(2:30))
pause

%Meiyu
dmin=161
dmax=200
ct_2=countit_2;
f=mean(freq2(dmin:dmax))
ct_2(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_2,30)
tau_ct=1+2*sum(acf_ct(2:10))
tau_30=1+2*sum(acf_ct(2:30))
pause


%Post-Meiyu
dmin=201
dmax=273
ct_2=countit_2;
f=mean(freq2(dmin:dmax))
ct_2(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_2,30)
tau_ct=1+2*sum(acf_ct(2:10))
tau_30=1+2*sum(acf_ct(2:30))
pause

%Fall
dmin=274
dmax=320
ct_2=countit_2;
f=mean(freq2(dmin:dmax))
ct_2(not(daynum>=dmin & daynum<=dmax))=f;
acf_ct=acf(ct_2,30)
tau_ct=1+2*sum(acf_ct(2:10))
tau_30=1+2*sum(acf_ct(2:30))
pause