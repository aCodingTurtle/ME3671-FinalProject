clc;
clear all;
close all;

k= 392;                          % Spring rate (lbs/in)
g=32.17;                         % Gravity
do=1.304-0.95;                   % Outer spring wire diameter (in)
Do=1.304-(do/2);                 % Outer spring mean diameter (in)
di=0.95-0.694;                   % Inner spring wire diameter (in)
Di=0.95-(di/2);                  % Inner spring mean diameter (in)
G= 30.5*10^6;                    % Young's Modulus (lb/in^2)

Nao=(do^4*G)/(8*Do^3*k);         % Number of active coils for outer spring
Nai=(di^4*G)/(8*Di^3*k);         % Number of active coils for inner spring
gam= 0.284;                      % specific weight (lb/in^3)

Wo= (pi^2*do^2*Do*Nao*gam)/4;
Wi= (pi^2*di^2*Di*Nai*gam)/4;



f_ci = 0.5*sqrt((k*12*g)/Wi);

fprintf('%.6f Hz Crictical Frequency Inner Spring \n',f_ci)

f_co = 0.5*sqrt((k*12*g)/Wo);

fprintf('%.6f Hz Crictical Frequency Outer Spring \n',f_co)





