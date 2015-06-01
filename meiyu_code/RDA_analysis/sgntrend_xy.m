function [sgn_t,sgn_mc,mtest,sgntest] = sgntrend_xy(xdata,ydata,nperm)

%Written by Jesse Day, 22nd of April 2014. Updated by Jesse Day, May 14
%2015

%uses two separate methods to calculate the statistical significance of a
%correlation that should converge on each other with sufficient number of
%trials: 1) Monte-Carlo method and 2) Calculation with t-statistic, since
%Pearson's r follows a known statistical distribution. These are returned
%as sgn_mc and sgn_t respectively.

%Mtest and ttest are optional output to see the slopes generated in each of the trials

n=length(ydata);
m=zeros(nperm+1,1); %vector that will store the slope of our fit
t=zeros(nperm+1,1);
p=polyfit(xdata,ydata,1);
m(1)=p(1)
plot(xdata,ydata,'x');
t(1)=m(1)*((n-2)/(1-m(1)^2))^.5;


for i=2:nperm+1
   
    newx=xdata(randperm(n)); 
    newy=ydata(randperm(n)); %these are two different random perturbations.
    p=polyfit(newx,newy,1);
    m(i)=p(1);
    t(i)=m(i)*((n-2)/(1-m(i)^2))^.5;
%    plot(newx,newy,'x')
    
end

%automatic calculation of the t-statistics
tstat=tcdf(t,n-2);
sgn_t=tstat(1);

mtest=m(2:nperm+1);
sgntest=tstat(2:nperm+1);

%calculation of sgn_mc - Montecarlo estimation of significance based on our
%data.
sgn_mc=sum(m(1)>m(2:nperm+1))/(nperm-1);