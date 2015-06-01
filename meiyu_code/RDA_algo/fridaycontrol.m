
%fridaycontrol.m

%last updated June 23rd 2014 by Jesse Day. Minor edits on March 11th 2015.

%main external script for running the Meiyu Front analysis.

%assumes exterior precipitation maps from APHRO_MA_025deg.nc, the APHRODITE
%reanalysis over Monsoon Asia, which span 60E-150E and 15S-55N

%although meiyu.m uses simple criteria to attempt fit (20 maxima in a row >
%10 mm/day) we use more stringent requirements to view a day as having a
%Meiyu. They are: taiwan frac < 20% and either Q1>.6 OR (Q2>.6 AND
%Q1_alt>.6). The latter scenario occurs in less than 10% of all days.

%variables currently returned:
%latitude of front at 105E
%latitude of front at 115E
%tilt of front 
%intensity of front (mm/day)
%width of front
%ismeiyu (meiyu or not?)
%quality score Q1 of primary front
%length of front
%fraction of precip that lands in taiwan (to exclude bad fits)
%"density" (whether front is occupied at a certain longitude or not
%crash - was best fit carried out correctly?
%crashlat - where to cut domain if best fit not carried out correctly

%additonal calculated variables:
%Q1_alt - quality score w/secondary front removed (in case of double front)
%countit_1 - whether first Meiyu event fits criteria
%countit_2 - whether secondary Meiyu event fits criteria
%c2type - whether secondary Meiyu accepted because Q1>.6 and Q2>.6 or
%because Q1_alt>.6 and Q2>.6

%March 11th edits - when splitting window on double front days, the
%obtained Q1 was not an accurate measure of what fraction of precip the
%primary front accounts for. in such cases, we recalculate Q1. Only affects
%small number of cases.


%% MINOR CHANGES still remaining to be considered as of 3/11/15
%1) should rerun whole algorithm with new tweak for recalculating Q1 in
%case of split window. Current Q1 score in such cases is highly inaccurate.

%2) it would be good to know how often we have to use the split window 
%method (the answer would seem to be very few). Should save as output var

%3) also, in terms of presenting aggregate quality score, should consider how
%to incorporate the statistics from double front days - just presenting Q1
%undersells the quality of fit, but presenting Q1_alt may slightly oversell
%our fitting ability.


%add folder where precip data is contained
addpath('/Users/Siwen/Desktop/Ferret/fer_dsets/data')
close all

%define exterior window size - the function may get called again with ]
%different subwindows.
minlong=105.125;
maxlong=122.875;
longpts=(maxlong-minlong)*4+1;

%LATITUDES
minlat=20.125;
maxlat=39.875;
latpts=(maxlat-minlat)*4+1;        

%for year=1951:2007 %input into fridaysave subsequently
for year=2007:2007

    %load in the data for the year
    str1='APHRO_MA_025deg_V1101.';
    str2=int2str(year);
    str3='.nc';
    filename=strcat(str1,str2,str3);
    clear PRECIP;
    P=ncread(filename,'precip');
    
    %analyze each day, predefine variables
    days=size(P,3); %could be 365 or 366
    lat105=zeros(days,1);
    lat115=zeros(days,1);
    tilt=zeros(days,1);
    intensity=zeros(days,1);
    width=zeros(days,1);
    ismeiyu=zeros(days,1);
    Q1=zeros(days,1); %quality score
    Q1_alt=zeros(days,1); %quality score in case of double front, otherwise NaN
    len=zeros(days,1);
    twfrac=zeros(days,1);
    
    density=zeros(longpts,days);
    
    %same set of variables for second detected front
    lat105_2=NaN(days,1);
    lat115_2=NaN(days,1);
    tilt_2=NaN(days,1);
    intensity_2=NaN(days,1);
    width_2=NaN(days,1);
    Q2=NaN(days,1); %quality score after first Meiyu fit removed
    len_2=NaN(days,1);
    density_2=NaN(longpts,days);
    ismeiyu_2=NaN(days,1);
    
    for d=1:days

        %window can get edited in running script, must reset it each time.
        
        %LONGITUDES
        minlong=105.125;
        maxlong=122.875;
       
        %LATITUDES
        minlat=20.125;
        maxlat=39.875;
        
        PRECIP=P(:,:,d);
        [l105,l115,t,i,w,my,q,lgth,tw,dy,crash,crashlat,crashtop]=...
            meiyu(PRECIP,d,minlong,maxlong,minlat,maxlat);
                
        %crash condition - activated if unable to perform good linear fit of
        %precip on a given day before
        if crash==1
            
            %define new variables for clarity
            newminlat=minlat;
            newmaxlat=maxlat;
            
            %crashtop indicates whether the top or bottom half of the
            %domain should be primary.
            if crashtop==1
                newminlat=crashlat;
            else
                newmaxlat=crashlat;
            end
            
            %debug
            [l105,l115,t,i,w,my,q,lgth,tw,dy,crash,crashlat]=...
            meiyu(PRECIP,d,minlong,maxlong,newminlat,newmaxlat);
            
            %quality score returned above is inaccurate because performed
            %over split window. Therefore, use myaltqscore, but putting a
            %pseudo-front to remove (zeros below).
            q=myaltqscore(PRECIP,l105,t,0,0, ...
                    minlong,maxlong,minlat,maxlat);
                
                      
        end
        
        %% ADDED MARCH 11, 2015 - on days where we have to split the window
        % we now use myaltqscore to determine a true Q1 value of the
        % primary front versus all precip on that day.
                
        %put daily returns into full array
        lat105(d)=l105;
        lat115(d)=l115;
        tilt(d)=t;
        intensity(d)=i;
        width(d)=w;
        ismeiyu(d)=my;
        Q1(d)=q;
        len(d)=lgth;
        twfrac(d)=tw;
        density(:,d)=dy;
        
        %meiyuplot3
        %pause

        
        %SECOND FIT - figure out if there is a second Meiyu-like feature
        
        %first step - set area around first calculated front to zero
        %carried out in separate script. If there wasn't a front the first
        %time around, then we skip this step entirely.
                
        if my==1 %if there 
            
            %debugging - output all relevant variables
%             d
%             l115
%             t
%             i
%             w
%             q
%             lgth
%             tw
%             pause
%             dy
%             pause
            
            %reset window in case we had to do split window before
            
            %LONGITUDES
            minlong=105.125;
            maxlong=122.875;
        
            %LATITUDES
            minlat=20.125;
            maxlat=39.875;
            
            Pnew=remove10(PRECIP,l105,t,minlong,maxlong,minlat,maxlat);
            
            %debugging - view removed area
            %close(1)
            %contourf(Pnew(181:252,140:220)',[0:2:20,20:5:50,100])
            %pause   
            %size(Pnew)
            
            [l105_2,l115_2,t_2,i_2,w_2,my_2,q_2,lgth_2,~,dy_2,crash,crashlat]=...
                meiyu(Pnew,d,minlong,maxlong,minlat,maxlat);
            
            %DEBUGGING
            %meiyuplot4
            %pause
            
            lat105_2(d)=l105_2;
            lat115_2(d)=l115_2;
            tilt_2(d)=t_2;
            intensity_2(d)=i_2;
            width_2(d)=w_2;
            Q2(d)=q_2;
            len_2(d)=lgth_2;
            density_2(:,d)=dy_2;
            ismeiyu_2(d)=my_2;
            
            %% DEBUGGING - output characteristics of second front
            if my_2 == 1
                
%                 d
%                 my_2
%                 pause
%                 l115_2
%                 t_2
%                 i_2
%                 w_2
%                 q_2
%                 lgth_2
%                 pause
%                 %dy_2
%                 %pause
%                 
%                 q
%                 q_2
%                 pause
                
                
                %calculate the Q score for our initial fit REMOVING FIT FOR
                %SECOND MEIYU EVENT
                
                %changed March 11th 2015 - myaltqscore now uses remove10
                %instead of removefront. Very minor difference in estimate
                %of quality scores on double front days.
                
                %%DEBUGGING - see quality scores
                %d
                
                Q1_alt(d)=myaltqscore(PRECIP,l105,t,l105_2,t_2, ...
                    minlong,maxlong,minlat,maxlat);
                
                %can help us detect a good fit even in the absence of a
                %good initial Q1 score.
       
                
            else %if no secondary front, then no Q1_alt calculated
                
                Q1_alt(d)=NaN;
                
            end
            
        else % if no primary front then definitely no Q1_alt!
            
            Q1_alt(d)=NaN;
            
        end
            
    end
    
    %%COUNTMEIYU - little script that decides based on our criteria whether
    %an observed Meiyu event should count or not. Runs after processing the
    %entire year's events.
    
    %Criteria: 1) TW fraction < 20%
    %2) Either Q1 > .6 OR both Q2 and Q1_alt > .6
    countit_1=zeros(days,1);
    countit_2=zeros(days,1);
    c2type=NaN(days,1);
    
    for d=1:days
        
        if ismeiyu(d)==1
                
            [countit_1(d),countit_2(d),c2type(d)]=countmeiyu(twfrac(d), ...
                Q1(d),Q1_alt(d),Q2(d));
            
            %DEBUGGING
%             if countit_2(d) == 1
%                 
%                 d
%                 pause
%                 
%             end
            
        end
        
    end
    
    fridaysave;  %outputs the data as a netcdf file.
    
    %delete variables
    %First Meiyu
    clear lat105; clear lat115; clear tilt; clear intensity; clear width; ...
    clear ismeiyu; clear Q1; clear Q1_alt; clear len; clear twfrac; ...
    clear density; clear countit_1; clear countit_2; clear c2type;
    
    %Second Meiyu
    clear lat105_2; clear lat115_2; clear tilt_2; clear intensity_2; ...
        clear width_2; clear Q2; clear len_2; clear density_2; ...
        clear ismeiyu_2;

end

%%MORE DEBUGGING - output statistics about specific days

% %Taiwan days
% for i=1:days
%    if (twfrac(i) > 10)
%        i
%        twfrac(i)
%        pause
%    end
% end
% 
% %Double front days
% for i=1:days
%    if (ismeiyu_2(i) == 1)
%        i
%        pause
%    end
% end