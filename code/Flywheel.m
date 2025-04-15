% %%Flywheel
% %Inputs
% Fly_k=68649.71932;  %Spring Constant k (N/m which is 392 lbs/in)
% Fly_x_1=0.5; %m (Not Actual Value)
% Fly_x_2=1; %m (Not Actual Value)
% Fly_w=6500*2*pi/60; %rad/s using 6500 RPM
% 
% %Other Variables
% Fly_CoefSpeed=0.001:0.001:0.25; %Range of tested Coefficients
% 
% %Equations
% Fly_Energy_1=0.5*Fly_k*Fly_x_1;
% Fly_Energy_2=0.5*Fly_k*Fly_x_2;
% Fly_Inertia=(Fly_Energy_2-Fly_Energy_1)./(Fly_CoefSpeed.*Fly_w^2);
% 
% %Output
% Fly_Inertia=Fly_Inertia; %kg m^2

%% flywheel rework

%input variables
Fly_k = 68649.71932;  %Spring Constant k (N/m which is 392 lbs/in)
Fly_w = 5525*2*pi/60; %rad/s using 5525 RPM
Fly_CoefSpeed = 0.001:0.001:0.25;


%% torque energy balance

Fly_CoefT = 0.5:0.5:2;

for i = 1:length(Tp2Toleranced)
    if Tp2Toleranced(i) < 0
        Fly_T_1(i) = 0;
    else
        Fly_T_1(i) = Tp2Toleranced(i);
    end
end
Fly_E_1 = max(cumtrapz(Fly_T_1));

for i = 1:length(Tp2Toleranced)
    if Tp2Toleranced(i) > 0
        Fly_T_2(i) = 0;
    else
        Fly_T_2(i) = Tp2Toleranced(i);
    end
end
Fly_E_2 = min(cumtrapz(Fly_T_2));

Fly_Inertia = (Fly_E_1-Fly_E_2)./(Fly_CoefSpeed.*Fly_w^2);







