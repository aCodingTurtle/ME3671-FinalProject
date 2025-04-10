%%Flywheel
%Inputs
Fly_k=68649.71932;  %Spring Constant k (N/m which is 392 lbs/in)
Fly_x_1=0.5; %m (Not Actual Value)
Fly_x_2=1; %m (Not Actual Value)
Fly_w=6500*2*pi/60; %rad/s using 6500 RPM

%Other Variables
Fly_CoefSpeed=0.001:0.001:0.25; %Range of tested Coefficients

%Equations
Fly_Energy_1=0.5*Fly_k*Fly_x_1;
Fly_Energy_2=0.5*Fly_k*Fly_x_2;
Fly_Inertia=(Fly_Energy_2-Fly_Energy_1)./(Fly_CoefSpeed.*Fly_w^2);

%Output
Fly_Inertia=Fly_Inertia %kg m^2
