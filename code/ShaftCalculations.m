%% This script regards calculations for shaft forces

%% Knowns
g = 9.81;               % Gravity

D_dg = 0;               % Drive Gear Diameter
D_pg = 0;               % Driven Gear Diameter
F_gc = 0;               % Gear Contact Force
m_fw = 2;               % Flywheel Mass(kg)
m_dg = 0;               % Drive Gear Mass
m_pg = 0;               % Driven Gear Mass
x_xx = 0;               % 
x_xx = 0;               % 



%% Shaft 1 (Motor and drive gear)
F_dg = m_dg * g;        % Drive gear force
F_m = F_dg / 2;         % Vertical motor force 
F_b1 = F_dg / 2;        % Bearing force
T_m = 0;                % Motor torque
T_dg = 0;               % Drive gear torque on shaft




%% Shaft 2 (Driven gear, flywheel, coupling to crankshaft)
F_pg = m_pg * g;        % Pinion gear force(N)
F_fw = m_fw * g;        % Flywheel force (N)
F_b2 = F_pg / 2;        % Bearing force 
F_b3 = (F_pg+F_fw) / 2; % Bearing force 
F_b4 = F_fw / 2;        % Bearing force 
T_pg = 0;               % Pinion gear torque
T_fw = 0;               % Flywheel torque
T_cp = 0;               % Coupling torque



%% Shaft 3 (Crank Shaft)




