
function newcoeffs = meiyufit(P,coeffs,longs,lats)
%  Written by Jesse Day, September 1st 2013

%  Convergent linear fit on the position of the Meiyu Front given a map of
%  precipitation for one day between 105E and 123E and 20N and 40N, as well
%  as an additional guess and the list of longitude points

%  Fit is coeffs(1)*x+coeffs(2) (y = mx + b)

xlen=length(longs);
ylen=length(lats);
xmin=min(longs);
xmax=max(longs);
ymin=min(lats);
ymax=max(lats);

myweight=zeros(xlen,1);
myposition=zeros(xlen,1);
mylatlocations=zeros(xlen,1);
newcoeffs=coeffs;
range=round([20:-1:9,8:-.5:.5]);
%as we converge we spend more time doing narrow ranges

for rr=1:length(range)
    
    %diagnostic 

    mylats=newcoeffs(1)*longs+newcoeffs(2);
    mylatindices=round((mylats-ymin)*4)+1;  %finds corresponding index
    %these are the meiyu latitudes predicted by my fit.
    
    %now, using my fit, find new maxima within the increasingly large range
    for i=1:length(longs)
        
        if (mylatindices(i) > 0) & (mylatindices(i) <= ylen)
            
            minrange=max(1,mylatindices(i)-range(rr));  %to avoid out-of-bounds
            maxrange=min(ylen,mylatindices(i)+range(rr));  %same
            [myweight(i), pos] = max(P(i,minrange:maxrange));
            myposition(i)=pos+minrange-1; 
            %have to adjust to correct index in list of latitudes
            
        else
            
            %have to include this line in case the suggested index is out
            %of bounds
            myweight(i)=0; myposition(i)=1;
            
        end    
            
    end
    
    mylatlocation=lats(myposition);
    
    %the line above is to make sure we don't end up out in the ocean
    %where the weight is -99.9
    myweight=max(myweight,zeros(xlen,1));
    newcoeffs=wpolyfit(longs,mylatlocation,1,myweight);
    
    %DEBUGGING - plot each step of the iterative fit
    %used to make figure S2 in paper (S2.ai)
    
%     if (range(rr)==20)|(range(rr)==8)|(range(rr)==1)|(range(rr)==16)|(range(rr)==12)|(range(rr)==4)
%         
%         %contourf(longs,lats,P',[0:5:50,100,200])
%         %plot(longs,newcoeffs(1)*longs+newcoeffs(2))
%         %pause
%         
%         range(rr)
%         meiyuplot2
%     
%     end
    
end

%plot output
%meiyuplot2