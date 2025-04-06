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
beta = 90 - alpha;

T = crankR.*Fcr.*cosd(beta); % Torque required by shaft

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
grid on
plot(crankAngle,phi, 'b-')
xlim([0 360])
xticks(0:45:360)
title("Connecting Rod - Piston Angle")