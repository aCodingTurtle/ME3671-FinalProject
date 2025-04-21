%% Bearing Loads

% Bearing Names: 
%   [BB BallBearing or JB JournalBearing]
%   [Shaft Letter A (Motor - Gearbox), B (Gearbox - Flywheel), C (Crank)]
%   [Index from End, starting at 1]

% Part Masses
m_coupler = 1;
m_gear = 1;
m_pinion = 1;
m_outshaft = 1;
m_flywheel = 1;
m_crankshaft = 1;
m_crod = 1;

% Gravity (to convert to weight) [m/s^2]
g = 9.81; 

% Radial Forces [N]
F_r_cr = 1; % Max radial force seen by bearings in connecting rod
F_r_gear = 1; % Max radial force seen by gear bearings

% Dimensions [m]
A1 = 1; % End to Gear
A2 = 1; % End to Bearing
A3 = 1; % End to Motor Coupler

B1 = 1; % End to Gear
B2 = 1; % End to BB_B2
B3 = 1; % BB_B2 to Flywheel
B4 = 1; % BB_B2 to BB_B3
B5 = 1; % BB_B3 to Drive Coupler
B6 = 1; % BB_B3 to BB_C2

C1 = 1; % End to Middle of Crankshaft
C2 = 1; % End to BB_C2

% Separating loads to bearings
F_BB_A0 = (A1/A2)*(m_pinion*g + F_r_gear);
F_BB_A1 = ((A2-A1)/A2)*(m_pinion*g + F_r_gear) + m_coupler*g;

F_BB_B0 = 0;

% Reporting data