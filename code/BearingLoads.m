%% Bearing Loads
clc
clear
%Bearing Guide drawing has all distances and bearing numbers indicated

% Gravity (to convert to weight) [m/s^2]
g = 9.81; 

%Linear density of Shaft
Dens=7850;
Area=pi*((25e-3)/2)^2;
LinDens=Dens*Area; %kg/m3

% Shaft Dimensions [m]
A1 = 7e-3; 
A2 = 37e-3; 

B1 = 37e-3; 
B2 = 46e-3; 
B3 = 7e-3; 

C1 = 7e-3; 
C2 = 47.32e-3; 
C3 = 47.32e-3;

% Coupler Mass
CoupMass=0.7484; %kg

%GearMass
G1M = (1.2488e-4)*7800; %kg
G2M = (1.5205e-4)*7800; %kg

%Gear Force at steady state
G1F = 27.8649; %N
G2F = -27.8649; %N

%Connecting Rod Mass
CRM = Dens*0.00006375; %kg

%Flywheel 
FM = 2.2427; %kg



% Shaft A Bearings:
%Individual Forces [N]
FA1 = ((CoupMass/2) + (A1*LinDens))*g;
FA2 = ((A2*LinDens) + G1M)*g + G1F;

%Steady State Bearing forces[N]
BA2 = FA1 + (FA2/2)
BA1 = FA2/2

%Shaft B Bearings:
%individual forces
FB1 = ((B1*LinDens) + G2M)*g + G2F;
FB2 = ((B2*LinDens) + FM)*g;
FB3 = (B3*LinDens + CoupMass/2)*g;
%Steady State Bearing Forces [N]
BB1 = FB1/2
BB2 = FB1/2 + FB2/2
BB3 = FB2/2 + FB3

%Shaft C Bearings
%Individual Forces
FC1 = (CoupMass/2 + C1*LinDens)*g;
FCW = sqrt(2384.17^2 + ((CRM + C2*LinDens)*g*4)^2);
FC2 = (CRM + C2*LinDens)*g;
FC3 = (CRM + C3*LinDens)*g;

%Steady State Bearing Forces [N]
CC2 = FC1 + FC2/2
CC1 = FC3/2
%Worst case scenario bearing forces [N]
CC2WORST = FC1 + FCW/2
CC1WORST = FCW/2
%these forces would only happen for a very brief time if 3 springs broke,
%in which case the machine would stop. Ensure static load rating of bearing is
%higher than this force.






