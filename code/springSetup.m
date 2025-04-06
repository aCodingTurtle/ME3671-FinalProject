%% LS3 Engine Valve Spring
% This script will set up a spring struct and leave it in the workspace

spring.K = 392 / 8.851; % [N/m] Spring Rate
spring.Xpre = .001; % [m] Preload distance
spring.stroke = .660 * .0254; % [m] Stroke Length (Max Lift)