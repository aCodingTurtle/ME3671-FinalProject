clc
clear
%Basic Radial Load Only Ball Bearing Rating Calculator:
%[C10] = BallBearing(DesiredHours,rpm,RatedLife,DesignLoad,ApplicationFactor,Theta,x0,b,DesiredReliability)
%Returns C10 (Dynamic) Load Rating
%Use C10 rating to select the bearing from catalog, and esnure that the C0
%(static) rating meets the max static load condition the bearing will
%experience.

%Design Parameters
ApplicationFactor = 1;
LifeHours = 50000;
rpm=3250;
DesiredReliability= .99;
%SKF Design Parameters:
x0S=0.02;
ThetaS=4.459;
bS=1.483;
LRS=1e6;

%Ball Bearing design life rating calculations:

%Bearing #A1
[C10A1] = BallBearing(LifeHours,rpm,LRS,19.0882,ApplicationFactor,ThetaS,x0S,bS,DesiredReliability)
%Bearing #A2
[C10A2] = BallBearing(LifeHours,rpm,LRS,23.5152,ApplicationFactor,ThetaS,x0S,bS,DesiredReliability)
%Bearing #B1
[C10B1] = BallBearing(LifeHours,rpm,LRS,7.7372,ApplicationFactor,ThetaS,x0S,bS,DesiredReliability)
%Bearing #B2
[C10B2] = BallBearing(LifeHours,rpm,LRS,3.6413,ApplicationFactor,ThetaS,x0S,bS,DesiredReliability)
%Bearing #B3
[C10B3] = BallBearing(LifeHours,rpm,LRS,15.8054,ApplicationFactor,ThetaS,x0S,bS,DesiredReliability)
%Bearing #C1
[C10C1] = BallBearing(LifeHours,rpm,LRS,3.5235,ApplicationFactor,ThetaS,x0S,bS,DesiredReliability)
%Bearing #C2
[C10C2] = BallBearing(LifeHours,rpm,LRS,8.1394,ApplicationFactor,ThetaS,x0S,bS,DesiredReliability)


%Needle Bearing Calculation:

%bearing rating (SKF Bearings)
DesignLoad = 1672.42;

%Cycle adjustment calculations
CrankCycle=60*LifeHours*rpm;
RodCycle=(16/360)*CrankCycle;
%Finding SKF C10 Rating
C10S=(ApplicationFactor*DesignLoad*((RodCycle/LRS)/(x0S+(ThetaS-x0S)*(1-DesiredReliability)^(1/bS)))^(3/10))*1e-3;
fprintf('SKF C10 Dynamic Load Rating (kN): %.4f\n',C10S)

%Journal Bearing Calculator:
%[S]= JournalBearing(ShaftDia,BoreDia,BearingLength,MaxLoad,rpm,OilViscF,OilConstF,BaseTemp)
%Returns Sommerfield Number (S)
%Asks for inputs from textbook figures in command window to evaluate
%bearing performance
[S]= JournalBearing(25.25,25.3492,19.05,1670.42,3250,.0141e-6,1360,70);









