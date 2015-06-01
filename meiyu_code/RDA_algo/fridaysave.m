%fridaysave.m

%written by Jesse Day, August 21st 2013

%saves output of Meiyu Front. Requires external definition of year.

%many of the variable save names are weird because we later use ncrcat to
%join all the years together, and then rename the variables using ferret to
%put them on a calendar axis (something that is too stupidly complicated
%with MATLAB). tlt -> tilt, wdth -> width etc.

%create file name
str1='meiyu_';
str2=int2str(year);
str3='.nc';
savefile=strcat(str1,str2,str3)

deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create netcdf file
%must be created initially with correct dimensions
%days should be found above - 365 or 366

%the names used for the vars are slightly weird because we rename them
%later anyway
nccreate(savefile,'lat105','Dimensions',{'time',Inf})
nccreate(savefile,'lat115','Dimensions',{'time',Inf})
nccreate(savefile,'tlt','Dimensions',{'time',Inf})
nccreate(savefile,'intens','Dimensions',{'time',Inf})
nccreate(savefile,'wdth','Dimensions',{'time',Inf})
nccreate(savefile,'izmeiyu','Dimensions',{'time',Inf})
nccreate(savefile,'Qual1','Dimensions',{'time',Inf})
nccreate(savefile,'Qual1_alt','Dimensions',{'time',Inf})
nccreate(savefile,'lngth','Dimensions',{'time',Inf})
nccreate(savefile,'twfrak','Dimensions',{'time',Inf})
nccreate(savefile,'dnsity','Dimensions',{'X',longpts,'time',Inf})
nccreate(savefile,'cntit_1','Dimensions',{'time',Inf})
nccreate(savefile,'cntit_2','Dimensions',{'time',Inf})
nccreate(savefile,'c2typ','Dimensions',{'time',Inf})

%write variables to file
ncwrite(savefile,'lat105',lat105)
ncwrite(savefile,'lat115',lat115)
ncwrite(savefile,'tlt',tilt)
ncwrite(savefile,'intens',intensity)
ncwrite(savefile,'wdth',width)
ncwrite(savefile,'izmeiyu',ismeiyu)
ncwrite(savefile,'Qual1',Q1)
ncwrite(savefile,'Qual1_alt',Q1_alt)
ncwrite(savefile,'lngth',len)
ncwrite(savefile,'twfrak',twfrac)
ncwrite(savefile,'dnsity',density)
ncwrite(savefile,'cntit_1',countit_1)
ncwrite(savefile,'cntit_2',countit_2)
ncwrite(savefile,'c2typ',c2type)

%move the resulting file if necessary
movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')


%% PART II - Save statistics of SECOND Meiyu (if two detected on same day)

%create file name
str1='meiyu_2_';
str2=int2str(year);
str3='.nc';
savefile=strcat(str1,str2,str3)

deletefile=strcat('/Users/Siwen/Documents/MATLAB/',savefile);
delete(deletefile);  %clears any existing savefile with that name
deletefile=strcat('/Users/Siwen/Desktop/ferret/bin/',savefile);
delete(deletefile);  %clears any existing savefile with that name

%create netcdf file
%must be created initially with correct dimensions
%days should be found above - 365 or 366

%the names used for the vars are slightly weird because we rename them
%later anyway
nccreate(savefile,'lat105','Dimensions',{'time',Inf})
nccreate(savefile,'lat115','Dimensions',{'time',Inf})
nccreate(savefile,'tlt','Dimensions',{'time',Inf})
nccreate(savefile,'intens','Dimensions',{'time',Inf})
nccreate(savefile,'wdth','Dimensions',{'time',Inf})
nccreate(savefile,'izmeiyu','Dimensions',{'time',Inf})
nccreate(savefile,'qual2','Dimensions',{'time',Inf})
nccreate(savefile,'lngth','Dimensions',{'time',Inf})
nccreate(savefile,'dnsity','Dimensions',{'X',longpts,'time',Inf})

%write variables to file
ncwrite(savefile,'lat105',lat105_2)
ncwrite(savefile,'lat115',lat115_2)
ncwrite(savefile,'tlt',tilt_2)
ncwrite(savefile,'intens',intensity_2)
ncwrite(savefile,'wdth',width_2)
ncwrite(savefile,'izmeiyu',ismeiyu_2)
ncwrite(savefile,'qual2',Q2)
ncwrite(savefile,'lngth',len_2)
ncwrite(savefile,'dnsity',density_2)

%move the resulting file if necessary
movefile(savefile,'/Users/Siwen/Desktop/ferret/bin')
