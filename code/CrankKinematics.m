function [TP_2x90,TPT_4x90] = CrankKinematics

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

Fcr = Fs./cosd(phi); % Force through Connecting Rod (and all bearings)
Fwall = Fcr.*sind(phi); % Reaction force on wall from cylinder cap

alpha = 180 - crankAngle - phi;
beta = abs(90-alpha);

T = crankR.*Fcr.*cosd(beta); % Torque required by shaft
pctCRtoTorque = cosd(beta);  % Percent Connecting Rod Force converted to Torque

% % Alternate Method (converting to X and Y axes)
% Bx = Fs;
% By = Bx .* tand(phi); % Same as Fwall
% Bmag = sqrt(Bx.^2 + By.^2); % Same as Fcr
% TT = crankR.*(Bx.*sind(crankAngle) + By.*cosd(crankAngle)); % Same as T

%% Angle Offsets
Fs90 = circshift(Fs,90); % 90 degree offset spring force
Fs180 = circshift(Fs,180); % 180 degree offset spring force
Fs270 = circshift(Fs,270); % 270 degree offset spring force

Fcr90 = circshift(Fcr,90); % 90 degree offset crank shaft force
Fcr180 = circshift(Fcr,180); % 180 degree offset crank shaft force
Fcr270 = circshift(Fcr,270); % 270 degree offset crank shaft force

T90 = circshift(T,90); % torque at 90 degree offset
T180 = circshift(T,180); % torque at 180 degree offset
T270 = circshift(T,270); % torque at 270 degree offset


%adjusted offset for a 1 degree angular machining tolerance
T89 = circshift(T,89);  % torque at 89 degree offset
T1 = circshift(T,1);    % torque at 1 degree offset
T181 = circshift(T1,180);
T269 = circshift(T89,180);

%% Torque Profiles
% TorqueProfile (+1deg Tolerance) _ Springs x Offset Angle

% TP_4x180 = 2 springs per crank offset, 4x180 degrees
TP_4x180 = 2*T + 2*T180;
TPT_4x180 = 2*T1 + 2*T181;
Tmax_4x180 = max(TP_4x180);
TmaxT_4x180 = max(TPT_4x180);

% TP_4x90 = 1 spring per crank offset, 4x90 degrees
TP_4x90 = T + T90 + T180 + T270;
TPT_4x90 = T1 + T89 + T181 +T269;
Tmax_4x90 = max(TP_4x90);
TmaxT_4x90 = max(TPT_4x90);

% TP_3x90 = 1 spring per crank offset, one broken spring
TP_3x90 = T + T90 + T180;
TPT_3x90 = T1 + T89 + T181;
Tmax_3x90 = max(TP_3x90);
TmaxT_3x90 = max(TPT_3x90);

% TP_2x90 = 1 spring per crank offset, two broken springs
TP_2x90 = T + T90;
TPT_2x90 = T1 + T89;
Tmax_2x90 = max(TP_2x90);
TmaxT_2x90 = max(TPT_2x90);

% TP_1x90 = 1 spring per crank offset, two broken springs
TP_1x90 = T;
TPT_1x90 = T1;
Tmax_1x90 = max(TP_1x90);
TmaxT_1x90 = max(TPT_1x90);


%% Plots

% Forces (Spring, Connecting Rod, Wall, Radial)
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
legend("Spring","Connecting Rod", "Wall")


% Angle (Connecting Rod to Piston)
figure
hold on
grid on
plot(crankAngle,phi, 'b-')
plot(crankAngle,pctCRtoTorque, 'r-')
xlim([0 360])
xticks(0:45:360)
title("Connecting Rod - Piston Angle")
legend("\phi Rod-Piston Angle", "% Rod Force converted to Torque")

% Camshaft Geometry Torque Profiles
figure
hold on 
grid on
plot(crankAngle, TP_4x180, 'r-', crankAngle, TPT_4x180, 'r--')
plot(crankAngle, TP_4x90, 'b-', crankAngle, TPT_4x90, 'b--')
xlim([0 360])
xticks(0:45:360)
xlabel("Crank Angle (degrees)")
ylabel("Torque (NM)")
title("Crank Geometry Torque Profiles")
legend("Springs every 180{\pm}0{\circ}", ...
    "Springs every 180{\pm}1{\circ}", ...
    "Springs every 90{\pm}0{\circ}", ...
    "Springs every 90{\pm}1{\circ}")

% Torque Profiles - 90deg Offsets, Broken Springs
figure

TPlayout = tiledlayout(2,2);
title(TPlayout,"Torque Profiles")

nexttile
plot(crankAngle, TP_4x90, 'b-', crankAngle, TPT_4x90, 'r-')
xlim([0 360])
xticks(0:45:360)
xlabel("Crank Angle (degrees)")
ylabel("Torque (NM)")
title("4 Springs, 1 Every 90 Degrees")
legend("90{\pm}0{\circ}","90{\pm}1{\circ}")

nexttile
plot(crankAngle, TP_3x90, 'b-', crankAngle, TPT_3x90, 'r-')
xlim([0 360])
xticks(0:45:360)
xlabel("Crank Angle (degrees)")
ylabel("Torque (NM)")
title("3 Springs/1 Broken, 1 Every 90 Degrees")
legend("90{\pm}0{\circ}","90{\pm}1{\circ}","Location","best")

nexttile
plot(crankAngle, TP_2x90, 'b-', crankAngle, TPT_2x90, 'r-')
xlim([0 360])
xticks(0:45:360)
xlabel("Crank Angle (degrees)")
ylabel("Torque (NM)")
title("2 Springs/2 Broken, 1 Every 90 Degrees")
legend("90{\pm}0{\circ}","90{\pm}1{\circ}")

nexttile
plot(crankAngle, TP_1x90, 'b-', crankAngle, TPT_1x90, 'r-')
xlim([0 360])
xticks(0:45:360)
xlabel("Crank Angle (degrees)")
ylabel("Torque (NM)")
title("1 Spring/3 Broken, 1 Every 90 Degrees")
legend("90{\pm}0{\circ}","90{\pm}1{\circ}")
