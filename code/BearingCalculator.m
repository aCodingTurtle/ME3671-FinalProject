clc
clear
%Basic Radial Load Only Ball Bearing Rating Calculator:
%[C10] = BallBearing(DesiredHours,rpm,RatedLife,DesignLoad,ApplicationFactor,Theta,x0,b,a,DesiredReliability)
%Returns C10 (Dynamic) Load Rating
%Use C10 rating to select the bearing from catalog, and esnure that the C0
%(static) rating meets the max static load condition the bearing will
%experience.


%Needle Bearing Calculation:
%bearing rating (SKF Bearings)
ApplicationFactor = 1.5;
DesignLoad = 1672.42;
LifeHours = 50000;
rpm=3250;
DesiredReliability= .99;
%SKF Design Parameters:
x0S=0.02;
ThetaS=4.459;
bS=1.483;
LRS=1e6;
%Timken Design Parameters:
x0T=1;
ThetaT=4.48;
bT=1.5;
LRT=90e6;

CrankCycle=60*LifeHours*rpm;

RodCycle=(16/360)*CrankCycle;

C10S=(ApplicationFactor*DesignLoad*((CrankCycle/LRS)/(x0S+(ThetaS-x0S)*(1-DesiredReliability)^(1/bS)))^(3/10))*1e-3;
fprintf('SKF C10 Dynamic Load Rating (kN): %.4f\n',C10S)
C10T=(ApplicationFactor*DesignLoad*((CrankCycle/LRS)/(x0T+(ThetaT-x0T)*(1-DesiredReliability)^(1/bT)))^(3/10))*1e-3;
fprintf('Timken C10 Dynamic Load Rating (kN): %.4f\n',C10T)

C10S=(ApplicationFactor*DesignLoad*((RodCycle/LRS)/(x0S+(ThetaS-x0S)*(1-DesiredReliability)^(1/bS)))^(3/10))*1e-3;
fprintf('SKF C10 Dynamic Load Rating (kN): %.4f\n',C10S)
C10T=(ApplicationFactor*DesignLoad*((RodCycle/LRS)/(x0T+(ThetaT-x0T)*(1-DesiredReliability)^(1/bT)))^(3/10))*1e-3;
fprintf('Timken C10 Dynamic Load Rating (kN): %.4f\n',C10T)


%Timken Engineering Manual Life Equation (Page 48):
C10TE = ApplicationFactor*DesignLoad*((CrankCycle/1e6)^(3/10))*1e-3

%Journal Bearing Calculator:
%[S]= JournalBearing(ShaftDia,BoreDia,BearingLength,MaxLoad,rpm,OilViscF,OilConstF,BaseTemp)
%Returns Sommerfield Number (S)
%Asks for inputs from textbook figures in command window to evalueate
%bearing performance
[S]= JournalBearing(25.25,25.3492,19.05,1670.42,3250,.0141e-6,1360,70);






