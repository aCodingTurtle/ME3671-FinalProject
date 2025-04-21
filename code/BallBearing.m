function [C10] = BallBearing(DesiredHours,rpm,RatedLife,DesignLoad,ApplicationFactor,Theta,x0,b,DesiredReliability)
%Design Life (XD)
XD=(60*DesiredHours*rpm)/RatedLife;
%bearing rating
C10=ApplicationFactor*DesignLoad*(XD/(x0+(Theta-x0)*(1-DesiredReliability)^(1/b)))^(1/3);
