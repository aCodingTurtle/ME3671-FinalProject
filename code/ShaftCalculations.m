%% This script regards calculations for shaft forces
clear;
clc;
%% Knowns

g = 9.81;               % Gravity
n = 1.5; %safety factor

% Shaft Group
% 4340 hot rolled steel Specs Table A-22
% Or A36 steel specs on wikipedia?
S_y = 250;              % Yeild Strength (MPa)
S_u = 550;             % Ultimate Strength (MPa)
S_e = S_u/2;            % Endurance limit (MPa)

% Other Groups
m_fw = 2.25;               % Flywheel Mass(kg)
m_dg = 1;               % Drive Gear Mass
m_pg = 1;               % Driven Gear Mass
F_gear = 1;      %force transmitted by gears
GR = 1.1; %gear ratio


%% Shaft 1 (Motor and drive gear)
%assume fully reversed bending 
Kf = 2.14; %bending fatigue stress conentration factor for woodruff key
Kfs = 3; %torsional fatigue stress concentration factor for woodruff key
F_dg = m_dg * g + F_gear;        % Drive gear force (N)
F_m = F_dg / 2;         % Vertical motor force (N) 
F_b1 = F_dg / 2;        % Bearing force (N)

L1 = .1; %distance from bearing to gear

M1 = L1*F_b1; %moment at gear

T1 = 12.0803*GR; %torque at gear

A = sqrt(4*((Kf*M1)^2)+3*(Kfs*T1)^2); %at gear

B = 0; %assumed no mean stresses

dS1 = ((16*n/pi)*((A/(S_e*10^6))+(B/(S_u*10^6))))^(1/3);


%% Shaft 2 (Driven gear, flywheel, coupling to crankshaft)
%assume fully reversed bending (Mm = 0 and Tm = 0)
%assume maximum possible torsion (12.0803 NM)
Kf = 2.14; %bending fatigue stress conentration factor for woodruff key
Kfs = 3; %torsional fatigue stress concentration factor for woodruff key

F_pg = m_pg * g;        % Pinion gear weight (N)
F_fw = m_fw * g;        % Flywheel weight (N)
F_b2 = F_pg / 2;        % Bearing force 1 (N)
F_b3 = (F_pg+F_fw) / 2; % Bearing force 2 (N)
F_b4 = F_fw / 2;        % Bearing force 3 (N)
T_pg = 0;               % Pinion gear torque (N*m)
T_fw = 0;               % Flywheel torque (N*m)
T_cp = 12.0803;              % Max Coupling torque (N*m)

L1 = .05; %distance from bearing 1 to gear
L2 = .05; %distance from gear to bearing 2
L3 = .05; %distance from bearing 2 to flywheel
L4 = .05; %distance from flywheel to bearing 3

M1 = L1*F_b2; %Bending moment at gear
M2 = M1+L2*(F_pg+F_gear); %Bending moment at bearing 2
M3 = M2+L3*F_fw; %Bending moment at flywheel

A1 = sqrt(4*((Kf*M1)^2)+3*(Kfs*T_cp)^2); %at gear
A2 = sqrt(4*((M2)^2)+3*(T_cp)^2); %at bearing 2 (no key)
A3 = sqrt(4*((Kf*M3)^2)+3*(Kfs*T_cp)^2); %at flywheel

B = 0; %assumed no mean stresses

dS2_1 = ((16*n/pi)*((A1/(S_e*10^6))+(B/(S_u*10^6))))^(1/3);
dS2_2 = ((16*n/pi)*((A2/(S_e*10^6))+(B/(S_u*10^6))))^(1/3);
dS2_3 = ((16*n/pi)*((A3/(S_e*10^6))+(B/(S_u*10^6))))^(1/3);

%% Shaft 3 (Crank Shaft)
Kf = 1.8;           %Fatigue Bending stress concentration factor for a crankshaft
Kfs = 2.1;          %Fatigue torsional stress concentration for a crankshaft 

LB = .1;             %distance between two ball bearings 
LS = LB/2;          %distance between center of bearing and applied spring force
LK = .01;             %distance from center of ball bearing to edge of crank
F_spr_min = 700;      %minimum spring force (connecting rod)
F_spr_max = 1672;      %maximum spring force (connecting rod)
F_bB_min = F_spr_min*-1; %minimum bearing force
F_bB_max = F_spr_max*-1; %maximum bearing force 

Tm = 0;             %Mean torque
Ta1 = .0034;        %maximum alternating torque under normal opperation
Ta2 = 12.0803;      %Maximum alternating torque in the worst case scenario

%moments at edge of crank (equal on each crank edge)
Mm_edge = ((F_bB_max+F_bB_min)/2)*LK; %mean bending moment at edge of crank
Ma_edge = ((F_bB_max-F_bB_min)/2)*LK; %alternating  bending moment at edge of crank

%moments at center of crank 
Mm_center = ((F_bB_max+F_bB_min)/2)*LS; %mean bending moment at center of crank
Ma_center = ((F_bB_max-F_bB_min)/2)*LS; %alternating  bending moment at center of crank

%parameters for goodman criterion 
A1 = sqrt(4*((Kf*Ma_edge)^2)+3*(Kfs*Ta1)^2); %Normal Operation at edge of crank
A2 = sqrt(4*((Kf*Ma_edge)^2)+3*(Kfs*Ta2)^2); %Worst case scenario torque at edge of crank 

A3 = sqrt(4*((Ma_center)^2)+3*(Ta1)^2); %Normal Operation at center of crank
A4 = sqrt(4*((Ma_center)^2)+3*(Ta2)^2); %worst case scenario torque at center of crank 

B1 = sqrt(4*((Kf*Mm_edge)^2)+3*(Kfs*Tm)^2); %at edge of crank
B2 = sqrt(4*((Mm_center)^2)+3*(Tm)^2); %at center of crank 

%required minimum diameters to keep factor of safety according to goodman criterion
dS3_1 = ((16*n/pi)*((A1/(S_e*10^6))+(B1/(S_u*10^6))))^(1/3); %Normal operation at edge of crank
dS3_2 = ((16*n/pi)*((A2/(S_e*10^6))+(B1/(S_u*10^6))))^(1/3); %Worst case scenario at edge of crank
dS3_3 = ((16*n/pi)*((A3/(S_e*10^6))+(B2/(S_u*10^6))))^(1/3); %Normal operation at center of crank
dS3_4 = ((16*n/pi)*((A4/(S_e*10^6))+(B2/(S_u*10^6))))^(1/3); %worst case scenario at center of crank






