%% Crank Kinematics
clear; clc; close all;

springSetup

crankR = spring.stroke/2; % [m] Crank Radius
rodL = .100; % [m] Connecting Rod Length
TDCdist = rodL - crankR; % [m] Top Dead Center dist from Crank Center

crankAngle = 1:360;
phi = asind(crankR*sind(crankAngle)/rodL);
disp = crankR*cosd(crankAngle) + rodL*cosd(phi) - TDCdist;

Fs = spring.K * (disp + spring.Xpre); % Spring Force
Fcr = Fs./cosd(phi); % Force through Connecting Rod
Fwall = Fcr.*sind(phi); % Reaction force on wall from cylinder cap

alpha = 180 - crankAngle - phi;
beta = abs(90-alpha);

T = crankR.*Fcr.*cosd(beta); % Torque required by shaft

ts = cosd(beta);

%% Angle Offsets
Fs90 = circshift(Fs,90); % 90 degree offset spring force
Fcr90 = circshift(Fcr,90); % 90 degree offset crank shaft force

Fs180 = circshift(Fs,180); % 180 degree offset spring force
Fcr180 = circshift(Fcr,180); % 180 degree offset crank shaft force

Fs270 = circshift(Fs,270); % 270 degree offset spring force
Fcr270 = circshift(Fcr,270); % 270 degree offset crank shaft force

T90 = circshift(T,90); % torque at 90 degree offset
T180 = circshift(T,180); % torque at 180 degree offset
T270 = circshift(T,270); % torque at 270 degree offset

%adjusted offset for a 1 degree angular machining tolerance
T89 = circshift(T,89); % torque at 89 degree offset
T1 = circshift(T,1); %torque at 1 degree offset
T181 = circshift(T1,180);
T269 = circshift(T89,180);

%% Torque Profiles

% Tp1 = 2 springs per crank offset, 2x180 degrees
Tp1 = 2*T + 2*T180;

% Tp2 = 1 spring per crank offset, 4x90 degrees
Tp2 = T + T90 + T180 + T270;
Tp2Toleranced = T1 + T89 + T181 +T270;

%% Graphs

figure
hold on 
grid on
plot(crankAngle, Fs, 'k-')
plot(crankAngle, Fcr, 'b-')
plot(crankAngle, Fwall, 'r-')
xlim([0 360])
xticks(0:45:360)
xlabel("Crank Angle (degrees)")
ylabel("Force (N)")
title("Forces every Crank Revolution")
legend("Spring","Connecting Rod", "Wall","Location","best")

figure
hold on
grid on
plot(crankAngle,phi, 'b-')
plot(crankAngle,ts, 'r-')
xlim([0 360])
xticks(0:45:360)
title("Connecting Rod - Piston Angle")


figure
hold on 
grid on
%plot(crankAngle, Tp1, 'k-')
plot(crankAngle, Tp2, 'r-')
plot(crankAngle, Tp2Toleranced, 'k-')
xlim([0 360])
xticks(0:45:360)
xlabel("Crank Angle (degrees)")
ylabel("Torque (NM)")
title("1 Spring Every 90 Degree")
legend("0 degree crank tolerance","1 degree crank tolerance")

figure
hold on 
grid on
plot(crankAngle, T)
plot(crankAngle, T90)
plot(crankAngle, T180)
plot(crankAngle, T270)
xlim([0 360])
xticks(0:45:360)
xlabel("Crank Angle (degrees)")
ylabel("Torque (NM)")
title("Torque Offsets")
legend("0 Offset", "90 Offset","180 Offset","270 Offset")


