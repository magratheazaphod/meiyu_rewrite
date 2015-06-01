%meiyu_dc.m

%written by Jesse Day, November 12th 2014

%intended to replace Ding & Chan's seminal precip figure that always gets
%copied and pasted (3b from Ding & Chan 2005).

%Makes a Hovmoller diagram of 57-year mean precipitation. Also in the
%process, creates sub-diagrams for two separate time periods: 1) 1951-1979
%and 2) 1980-2007, and subtracts the difference between them.

%relies primarily on Pchina.nc, the longitude mean of precip as calculated
%from Ferret. Latitude range is from 20N to 40N at quarter degree
%resolution. Pchina is 80 x 20819 in size

clear all;
close all;

P=ncread('Pchina.nc','PCHINA');


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

daynum(20455:20819) = [1:365]


%%% PART I - changes in rainfall between 1951-1979 and 1980-2007 %%%

Phov=zeros(80,366)
counter=zeros(1,366);

%1951-1979 - 1-10592; 1980-2007 - 10593-20819
for i=1:20819
    
    dd=daynum(i);
    m=1/(counter(dd)+1);
    Phov(:,dd)=Phov(:,dd)*(1-m)+P(:,i)*m;
    counter(dd)=counter(dd)+1;
    
%     if mod(i,50)==0
%         dd
%         m
%         Phov(:,dd)
%         counter(dd)
%         pause
%     end
%         
end

contourf(Phov)


%SAVE NETCDF FILE
savefile='meiyudingchan_updated.nc'
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);
deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%Make netcdf file with correct dimensions
nccreate(savefile,'P','Dimensions',{'Y',80,'time',365})
%nccreate(savefile,'Psmth5','Dimensions',{'Y',80,'time',365})

%write variables to file
ncwrite(savefile,'P',Phov(:,1:365))
%ncwrite(savefile,'Psmth5',Psmooth)

%move the resulting file if necessary
movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')


%%% PART II - changes in rainfall between 1979-1993 and 1994-2007

