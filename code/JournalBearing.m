function[S]= JournalBearing(ShaftDia,BoreDia,BearingLength,MaxLoad,rpm,OilViscF,OilConstF,BaseTemp)

Cmin=(BoreDia-ShaftDia)/2;
r=ShaftDia/2;
p=MaxLoad/(BearingLength*ShaftDia);

%Dynamic Viscocity of oil at temperature calculation. Refrence table 12-1
%Outputs in Pa*s
DynamVisc=(OilViscF*exp(OilConstF/(BaseTemp+95)))*6894.75048308463
%Convert rpm to rps
rps=rpm/60;
%constraining dimensions of bearing
Cmin=(BoreDia-ShaftDia)/2;
r=ShaftDia/2;
p=MaxLoad/(BearingLength*ShaftDia);
%bearing characteristic number:
S=((r/Cmin)^2)*((DynamVisc*rps)/(p*10^6));
fprintf('Sommerfield Number (S): %.4f\n',S)
%Give Unity Ratio
unityratio=BearingLength/ShaftDia;
fprintf('Unity Ratio (l/d): %.4f\n',unityratio);
%User input variables
hocenter=input('Enter ho/c from Figure 12-15:');
flowvar=input('Enter Flow variable from Figure 12-18:');
Qs=input('Input Qs/Q from Figure 12-19:');



%Evaluate Bearing:
%Coeff of friction;
f= (Cmin/r)*2*(pi^2)*S;
fprintf('Journal Coefficient of Friction: %.4f\n',f)
%Finding ho
ho=hocenter*Cmin;
homin = (0.0002+0.00004*(ShaftDia/25.4))*25.4;
fprintf('Calculated ho: %.4f\n',ho)
fprintf('Minimum ho: %.4f\n',homin)

%Flow rate
Q=flowvar*r*Cmin*rps*BearingLength;
fprintf('Flow rate to bearing (mm^3 /s): %.4f\n',Q)

%Temperature Rise
deltaT = (p * r * f / (0.12 * Cmin)) * (r * Cmin * rps * BearingLength) / (Q * (1 - 0.5 * Qs / Q));
fprintf('Temoerature Rise (C): %.4f\n',deltaT)

