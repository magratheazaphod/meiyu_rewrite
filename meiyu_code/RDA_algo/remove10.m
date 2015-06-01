function Pnew = remove10(Pold,lat105,tilt,minlong,maxlong,minlat,maxlat)
%written by Jesse Day, July 3rd 2014

%alternative version of removefront.m - currently in use by meiyu.m

%removes all points inside of the old Meiyu Front that are over 10 mm/day,
%in order to improve detection of secondary front events.

%as usual, assumes that the background maps are precipitation maps from
%60E-150E and 15S-55N as provided by APHRODITE (APHRO_MA_025deg...)

%addition from 7/7/14 - even if calculated front is outside window, can
%still erase precip that would appear within window

mylats=[minlat:.25:maxlat];
mylongs=[minlong:.25:maxlong];
xindices=(mylongs-59.875)*4;
yindices=(mylats+15.125)*4;
xmin=min(xindices);
xmax=max(xindices);
ymin=min(yindices);
ymax=max(yindices);

xref=mylongs-105;
frontlats=tand(tilt)*xref+lat105;
frontindices=round((frontlats+15.125)*4);

Pnew=Pold;

%goes through and iteratively wipes out all rainfall info within 4 degrees
%of the observed front line (approximately two standard deviations of
%width)

for i=1:length(frontindices)
    
    myy=frontindices(i);
    xcoord=xmin+i-1;
    
    if (myy >= (ymin-16)) & (myy <= (ymax+16))
        
        %delete everything within a 4 degree range
        maxspread=min(ymax,myy+16);
        minspread=max(ymin,myy-16);
        Pnew(xcoord,minspread:maxspread)=min(0,Pold(xcoord,minspread:maxspread));

        %remove additional local points greater than 10 mm/day.
        
        if Pold(xcoord,maxspread) > 5
            
            j=maxspread+1;
            
            while (Pold(xcoord,j) > 5) & (j <= ymax)
                
                Pnew(xcoord,j)=0;
                j=j+1;
                
            end
            
        end    
            
        
        if Pold(xcoord,minspread) > 5
            
            j=minspread-1;
            
            while (Pold(xcoord,j) > 5) & (j >= ymin)
                
                Pnew(xcoord,j)=0;
                j=j-1;

            end    
                
        end    
            
    end
    
end

%%debugging - visualize the implemented deletions

% close(1)
% contourf(Pold(xmin:xmax,ymin:ymax)',[0:2:20,20:5:50,100,200])
% close(1)
% contourf(Pnew(xmin:xmax,ymin:ymax)',[0:2:20,20:5:50,100,200])
% pause

%debugging - comment out
% savefile='Ptemp.nc';
% deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
% delete(deletefile);  %clears any existing savefile with that name
% deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
% delete(deletefile);  %clears any existing savefile with that name
% nccreate(savefile,'P','Dimensions',{'X',360,'Y',280})
% ncwrite(savefile,'P',Pnew)
% 
% movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')

% figure(10)
% contourf(Pnew(181:252,141:220)')
% 
% figure(20)
% contourf(Pold(181:252,141:220)')

% s1=Pnew(181:252,141:220)
% s2=Pold(181:252,141:220)
% 
% s3=s1-s2
% s=(s3<0)+0
% % contourf(s)
% % pause
% 
%  savefile='shadetemp.nc';
%  deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
%  delete(deletefile);  %clears any existing savefile with that name
%  deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
%  delete(deletefile);  %clears any existing savefile with that name
% 
% 
% nccreate(savefile,'shade','Dimensions',{'X',72,'Y',80})
% ncwrite(savefile,'shade',s)