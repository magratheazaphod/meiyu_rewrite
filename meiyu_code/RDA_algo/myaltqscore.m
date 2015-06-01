
function q1_alt=myaltqscore(Pday,lat105_1,tilt_1,lat105_2,tilt_2,minlong,maxlong,minlat,maxlat)
     
%myaltqscore.m

%Written by Jesse Day, July 2nd 2014

%UPDATED MARCH 11 2015 - switched the front removal algorithm from
%removefront.m to remove10.m, which removes rainfall in a more
%sophisticated fashion.

%Script that recalculates the quality score for the primary detected Meiyu
%score, while leaving out SECONDARY EVENT 

%Logic is that if we have two events of approximately same magnitude that
%are picked up well, then it should count as good fit - but Q1 would not
%reflect this

%based largely on script in meiyu.m for calculating quality
mylats=[minlat:.25:maxlat];
mylongs=[minlong:.25:maxlong];
xindices=(mylongs-59.875)*4;
yindices=(mylats+15.125)*4;
xmin=min(xindices);
xmax=max(xindices);
ymin=min(yindices);
ymax=max(yindices);
xref=mylongs-105;
frontlats=tand(tilt_1)*xref+lat105_1;
frontindices=round((frontlats-minlat)*4+1);

%%SECONDARY FRONT REMOVAL
%use removefront.m to remove secondary meiyu using lat105_2 and tilt_2\
Ptemp=remove10(Pday,lat105_2,tilt_2,minlong,maxlong,minlat,maxlat);
P=Ptemp(xmin:xmax,ymin:ymax);

%DEBUGGING
%figure(1)
%contourf(P')
%pause

%% QUALITY SCORE CALCULATION

%Calculation based off of previous convergent fit

%this little algorithm determines the quality score for a meiyu, based on
%what fraction of the precipitation for that day inside our region lies
%within our proposed front.

%in this case, within the front means within 2.5 degrees of the calculated
%front latitude.

%total precipitation - have to adjust for NaNs
for i=1:size(P,1)
    for j=1:size(P,2)
        if P(i,j) < 0
            
            P(i,j)=0;
        end
    end
end

totalprecip=sum(sum(P)); %total precipitation

meiyuprecip=0;
myqwidth=10; %what range around the front line do we include?
%in units of cells, so for now 2.5 degrees on either side

for i=1:length(mylongs)
    
    if (frontindices(i) > 0) & (frontindices(i) <= length(mylats))
        qq=frontindices(i);
        
        %the code below makes sure we don't go outside the bounds
        minrange=max(1,qq-10);
        maxrange=min(length(mylats),qq+10);
        meiyuprecip=meiyuprecip+sum(P(i,minrange:maxrange));
        
    end
    
end

%final output - quality score with secondary front removed. used for
%finding double fit days
q1_alt=meiyuprecip/totalprecip;