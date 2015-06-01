function [lat105,lat115,tilt,intensity,width,ismeiyu,qscore,len, ...
    twfrac,density,crash,crashlat,crashtop]=meiyu(PRECIP,d,minlong,maxlong,minlat,maxlat)

%written by Jesse Day and Liu Weihan, August-September 2013

%takes in a precipitation map for one day PRECIP, the day number d, and the
%domain size (min/max longitude, min/max latitude). Returns the latitude of
%the front (at 105E and 115E), the tilt, intensity, width, whether there is
%a meiyu or not, the quality score, length, percentage of fraction that
%falls on taiwan (for quality control) and finally whether each longitude
%point has a front or not.

%also returns crash parameters in case of a bad fit - crash, crashlat and
%crashtop. Crash indicates whether crash or not, crashlat indicates
%latitude boundary of new window, and crashtop indicates whether it should
%consider the top or the bottom half as primary.

%APHRODITE precipitation maps originally start out covering 60E:150E and
%15S:55N with quarter degree resolution. This code ASSUMES that the
%preciptation supplied is in that window, and chooses the corresponding
%subwindow.

%to avoid confusion - lats and longs refer to gridding of original data.
%the output LATITUDE refers to the latitude of the Meiyu Front on that day.

%% TO DO

%TO-DO LIST

%1. Varying the 5 degree limit of where maxima must be
%not that effective, but changed to latitude of CENTROID as opposed to raw
%average
%DONE

%2. Band quality index
%Very useful measure of Meiyu quality on any given day
%but may not help improve fitting that much.
%DONE

%3. Change weights to zero outside of main band of precip
%Ineffective, made fits worse by excluding valid data.
%DONE

%4. Leave out Taiwan
%still has not been implemented, should be very straightforward
%Logic being that precip over Taiwan never improves fit, only confirms it,
%while also having too many independent phenomena
%High resolution data, but that might be an impediment
%DONE - unhelpful, but alternative is to calculate taiwan fraction
%(implemented)

%5. Adaptive convergent fit
%likely the best way to go besides an image processing approach
%only limitation is that it would only be able to find one day of precip
%will NOT improve quality score.
%DONE

%6. Change criterion 1 so that the stretch of maximums can't jump in
%latitude
%NO

%7. Triads, pentads, decads
%still untested. what do these change?
%unnecessary - could simply be achieved by smoothing

%%% LONG-TERM
%Image processing approach where every blob gets evaluated for potential
%resemblance to a Meiyu Front day - could account for days with two
%apparent independent fronts.
%meh, current methods seem to work fine

%convert supplied window parameters into necessary arrays, given max domain
%of 60.125E-149.875E and 14.875S:54.875N
lats=[minlat:.25:maxlat];
longs=[minlong:.25:maxlong];
nlats=length(lats); %number of latitude points
nlongs=length(longs); %number of longitude points

%window selected inside of PRECIP, which runs over 60E-150E and 15S-55N
xmin=4*(minlong-60.125)+1;
xmax=4*(maxlong-60.125)+1;
ymin=4*(minlat+14.875)+1;
ymax=4*(maxlat+14.875)+1;

%subfield P of full precip PRECIP
P=zeros(nlongs,nlats);
P=PRECIP(xmin:xmax,ymin:ymax);

%%DEBUGGING - show current day of precip
% contourf(longs,lats,P',[0:2:20,20:5:50,100,200])
% pause

%indices of maxima
[maxval,location]=max(P,[],2);
latlocation=lats(location); %location contains indices, this translates
%them to actual latitudes


%%%%% MEIYU SELECTION CRITERIA
%The following section of code is crucial - this is where the parameter
%ismeiyu is set to 0 or 1.

%Criteria employed
%1. There must be a continuous band of maxima of at least 5 degrees
%exceeding 10 mm/day.

%2. Maxima outside of a n-degree range of the centroid have their weighting 
%set to zero where n is adjustable.

cutoff=maxval>10;

cutoff2=zeros(nlongs,1);
cutoff2(1)=cutoff(1);

for i=2:nlongs

    if cutoff(i)==1
    
        cutoff2(i)=cutoff2(i-1)+1;
        
    else
        
        cutoff2(i)=0;
    
    end
        
end 

%cutoff2;
[crit1,lloc]=max(cutoff2);

%DEBUGGING
%meiyuplot
%pause

if crit1>=20   %if not, just returns NaNs for all the values.
    
    
    %% SECOND CRITERION
    
    %we assign weights to each of the maxima based off of the magnitude of
    %precipitation there.
    weight=maxval; %weight is a 72x1 column vector
    
    %Before performing our weighted polynomial fit, we find the CENTROID
    %LATITUDE OF PRECIPITATION by doing sum(max*latlocation)/sum(max)
    
    centroidlat=sum(maxval.*latlocation')/sum(maxval);

    %second weighting criterion - discounts maxima outside of a n degree range
    widthcutoff=5;
    
    %this loop changes our weighting of the points for our linear fit,
    %adjusting the weight on outliers to zero.
    for i=1:size(latlocation,2)
        
        if abs(latlocation(i)-centroidlat) > widthcutoff
            weight(i)=0;
        end
        
    end
    
    
    %CRASH CONDITION
    %in some cases, no fit can occur because two patches of precip are so
    %far from each other that neither is within 5 degrees of the precip
    %centroid. in such a case, we break out of the algorithm and go back to
    %the control script.
    
    %debugging
    weightsum=sum(weight);
    
    if weightsum<200 %this only happens on days with two fronts
        crash=1;
        
        %additional code to indicate whether to pick the bottom or top
        %half after splitting domain (crashtop)
        crashlat=(round((centroidlat-.125)*4)/4)+.125; %quantized
        clatindex=4*(crashlat-minlat)+1; % corresponding latitude
        
        %find the maxima in each of the half windows
        botmax=max(P(:,1:clatindex)');
        topmax=max(P(:,clatindex+1:nlats)');

        %apply a criterion very similar to cutoff 2 - most consecutive
        %maxima over 10 mm/day
        bmax=botmax>10;
        tmax=topmax>10;
        
        bmaxcount=zeros(size(bmax));
        tmaxcount=zeros(size(tmax));
        bmaxcount(1)=bmax(1);
        tmaxcount(1)=tmax(1);
        
        for i=2:nlongs
            
            if bmax(i)==0
                bmaxcount(i)=0;
            else    
                bmaxcount(i)=bmaxcount(i-1)+1;
            end
            
            if tmax(i)==0
                tmaxcount(i)=0;
            else    
                tmaxcount(i)=tmaxcount(i-1)+1;
            end
            
        end
        
        botmaxnum=max(bmaxcount);
        topmaxnum=max(tmaxcount);
        
        %pick whichever half has longer string of maxima (i.e. frontiest
        %sequence)
        if topmaxnum >= botmaxnum
            crashtop=1;
        else
            crashtop=0;
        end
        
        %FAKE RETURN
        lat105=NaN;
        lat115=NaN;
        tilt=NaN;
        intensity=NaN;
        width=NaN;
        ismeiyu=0;
        qscore=NaN;
        len=NaN;
        twfrac=NaN;
        density=NaN;

    else
        %Now that we've adjusted the weights, we perform our fit.
        %wpolyfit is a slight rewrite of polyfit.m. the "1" here means that we
        %are performing a linear fits
        coeffs=wpolyfit(longs,latlocation,1,weight);

        %fit is coeffs(1)*x+coeffs(2) or mx+b with m=coeffs(1), b=coeffs(2)
        %

        %% CONVERGE %%
        %performs a convergent weighted fit
        %FINALIZES OUR FIT - everything hereafter is just finding statistics

        coeffs=meiyufit(P,coeffs,longs,lats);
        %coeffs(1)=m, coeffs(2)=b
        


            
        %% BEST FIT POINTS

        %IMPORTANT - latitude of the front for each longitude as calculated by
        %our best fit
        %d
        %coeffs
        mylats=coeffs(1)*longs+coeffs(2);
        mylatindices=round((mylats-(minlat-.25))*4);  
        %finds the index number relative to boundary (which is now variable
        %in the new version of the program)
        
        mylatindices(mylatindices<1)=999;
        mylatindices(mylatindices>nlats)=999;
        
        %% DEBUGGING - comment out if running for all years
        %meiyuplot3
        
        %% FRONTINESS %%
        %In order to calculate the width and length of the front (since it
        %doesn't always span all longitudes) we find all points along our best
        %fit line where the intensity of rainfall is over 5 mm for the day.
        
        myfront=zeros(nlongs,1); %indicates whether there is a front at
        %each longitude or not along the best fit line
        mywidths=zeros(nlongs,1);
        myP=zeros(nlongs,1); %contains the intensity of precipitation at
        %each point along the calculated front axis
        
        for i=1:length(longs)
            
            if mylatindices(i)~=999 %in place to deal with missing values (cf lines 174-175)
                
                if P(i,mylatindices(i)) > 5
                    myfront(i)=1;
                    myP(i)=P(i,mylatindices(i));               
                end
                
            end
            
        end
          
        len=sum(myfront)/4;
        density=myfront;
        
        %CALCULATE INTENSITY - simply the mean of the intensity at each
        %point along the front axis, given by myP
        %could be a one-linear - intensity=mean(myP(myP~=0)) - but split
        %into two lines for clarity
        myprecip=myP(myP~=0);
        intensity=mean(myprecip);
        
        %FIND WIDTH - we average over the width at each longitude where a front
        %is found
        
        for i=1:nlongs
            
            if myfront(i)==1
                
                %thresh=P(i,mylatindices(i))/exp(1);
                thresh=P(i,mylatindices(i))/2;
                
                %find northernmost extent
                pos=mylatindices(i);
                
                while (P(i,pos)>thresh) & (pos<nlats)
                    
                    pos=pos+1;
                end
                
                maxval=pos;
                
                %find southernmost extent
                pos=mylatindices(i);
                
                while (P(i,pos)>thresh) & (pos>1)
                    
                    pos=pos-1;
                    
                end
                
                minval=pos;
                mywidths(i)=(maxval-minval-1)/4;
                
            end
            
        end
        
        width=mean(mywidths(mywidths~=0)); %finds the mean of nonzero widths

        %len
        %width
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
        
        for i=1:nlongs

            if (mylatindices(i) > 0) & (mylatindices(i) <= nlats)
                qq=mylatindices(i);
                
                %the code below makes sure we don't go outside the bounds
                minrange=max(1,qq-myqwidth);
                maxrange=min(nlats,qq+myqwidth);
                meiyuprecip=meiyuprecip+sum(P(i,minrange:maxrange));
            end

        end

        %P(longs,mylats)
        %plot(longs,mylats)

        
        qscore=meiyuprecip/totalprecip;

        %% TAIWAN FRACTION
        %Taiwan experiences different storms from the rest of the mainland. At
        %times, this can be misleading. Experimental variables that simply
        %indicates the percentage of daily rainfall in our domain that occurred
        %in Taiwan
        
        %the window chosen for Taiwan is 120E-123E and 20N-26N        
        preciptw=max(PRECIP(241:252,141:164),0);
        taiwanprecip=sum(sum(preciptw));
        twfrac=100*taiwanprecip/totalprecip;

        %%RETURN VALUES
        lat105=coeffs(2)+105*coeffs(1);
        lat115=coeffs(2)+115*coeffs(1);
        tilt=atan(coeffs(1))*180/pi;
        
        %previous method of calculating intensity - new way only includes
        %points within front
%       intensity=mean(weight);

        ismeiyu=1;
        crash=0; %code ran properly
        crashlat=NaN;
        crashtop=NaN;
        
    end %ends the main fitting loop - only accessed if the original fit 
    %could be carried out correctly
    
else
   
    %if the criteria for meiyuness are not reached, all the parameters are
    %set to NaN to aid calculation of averages in ferret.
    
    lat105=NaN;
    lat115=NaN;
    tilt=NaN;
    intensity=NaN;
    width=NaN;
    ismeiyu=0;
    qscore=NaN;
    len=NaN;
    twfrac=NaN;
    density=NaN(nlongs,1);
    crash=NaN;
    crashlat=NaN;
    crashtop=NaN;
    
end