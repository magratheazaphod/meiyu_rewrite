function [c1,c2,c2type] = countmeiyu(twfrac,Q1,Q1_alt,Q2)
%countmeiyu.m

%Written by Jesse Day, July 7th 2014

%determines whether to count a detected Meiyu event based on simple
%criteria:
%1) Fraction of precip falling on Taiwan must be <20%
%2) Either Q1 > .6 (most of the time)
%   OR Q1_alt and Q2 both >.6 (double front days)

%c1 - whether first Meiyu counts
%c2 - whether second Meiyu counts
%c2type - if Q1> .6 and Q2>.6, c2type = 1
%         if Q1< .6 but Q2>.6 and Q1_alt>.6, c2type=2

if twfrac < 20 %first criterion - if failed, nothing else counts
    
    if Q1>.6
        
        c1=1;
        
        if Q2 > .6
            
            c2=1;
            c2type=1;
            
        else
            
            c2=0;
            c2type=NaN;
            
        end
        
    elseif ((Q1_alt > .6) & (Q2 > .6))
        
        c1=1;
        c2=1;
        c2type=2;
        
    else
        
        c1=0;
        c2=0;
        c2type=NaN;
        
    end
    
else
    
   c1=0;
   c2=0;
   c2type=NaN;
   
end