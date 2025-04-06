%% LS3 Engine Valve Spring
% This script will set up a spring struct and leave it in the workspace

spring.K = 392 / .0254 * 4.44822; % [N/m] Spring Rate
spring.Fpre = 160 * 4.44822; % [N] Preload Force (Seat Pressure)
spring.Xpre = spring.Fpre / spring.K; % [m] Preload distance
spring.stroke = .6 * .0254; % [m] Stroke Length (Max Lift)