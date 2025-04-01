%%Flywheel
%Inputs
Fly_r=1;    %in
Fly_t2=50;  %seconds
Fly_t1=0;   %seconds
Fly_Tr=100; %lbf in
Fly_T2=500; %lbf in
Fly_ws=200; %rad/s
Fly_wr=203; %rad/s

%Equations
Fly_a=-Fly_Tr/(Fly_ws-Fly_wr);
Fly_m=((Fly_t2-Fly_t1)*Fly_a)/(Fly_r^2*log(Fly_T2/Fly_Tr))*12*32.174;

%Output
Fly_m=Fly_m %lbm