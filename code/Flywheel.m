%% flywheel rework

clear
clc

%input variables
Fly_k = 68649.71932;  %Spring Constant k (N/m which is 392 lbs/in)
Fly_w = 5525*2*pi/60; %rad/s using 5525 RPM
TP = CrankKinematics;

%% torque energy balance

for i = 1:length(TP)
    if TP(i) < 0
        Fly_T_1(i) = 0;
    else
        Fly_T_1(i) = TP(i);
    end
end
Fly_E_1 = max(cumtrapz(Fly_T_1));

for i = 1:length(TP)
    if TP(i) > 0
        Fly_T_2(i) = 0;
    else
        Fly_T_2(i) = TP(i);
    end
end
Fly_E_2 = min(cumtrapz(Fly_T_2));

%Fly_Inertia = (Fly_E_1-Fly_E_2)./(Fly_CoefSpeed.*Fly_w^2);

%% design space

p = [2.780 2.680 2.700 2.830 2.810 7.870 7.850 7.860 7.830];
p = p*1000;
%densities (g/cm^2)

d_i = .01:.01:.49;
d_o = .02:.01:.5;
b = .001:.001:.5;

% d_i = 1:1:29;
% d_o = 2:1:30;
% b = .1:.1:1;

MinMagnitude = 1000; %initial value to compare against
CsMin = .2; %set minimum Cs value

for i = 1:length(d_i)
    for j = 1:length(d_o)
        for k = 1:length(b)
            for h = 1:length(p)
                m(i,j,k,h) = (.25*pi*b(k)*(d_o(j)^2-d_i(i)^2))*p(h);
                if m(i,j,k,h) <= 0
                    m(i,j,k,h) = 0; %remove from design space
                    I(i,j,k,h) = 0;
                    Fly_CoefSpeed(i,j,k,h) = 0;
                else
                    I(i,j,k,h) = .5*m(i,j,k,h)*((.5*d_o(j))^2-(.5*d_i(i))^2);
                    Fly_CoefSpeed(i,j,k,h) = (Fly_E_1-Fly_E_2)/(I(i,j,k,h)*Fly_w^2);
                    Magnitude(i,j,k,h) = sqrt(Fly_CoefSpeed(i,j,k,h)^2+m(i,j,k,h)^2); %calculate magnitude to find optimum trade off of mass and coefficient of speed
                    if Fly_CoefSpeed(i,j,k,h) < CsMin && Magnitude(i,j,k,h) < MinMagnitude 
                        MinMagnitude = Magnitude(i,j,k,h);
                        MinMagPosition(1) = i;
                        MinMagPosition(2) = j;
                        MinMagPosition(3) = k;
                        MinMagPosition(4) = h;
                    end
                end
            end
        end
    end
end


figure
grid on
hold on
for k = 1:length(b)
    for h = 1:length(p)
        scatter(m(:,:,k,h),Fly_CoefSpeed(:,:,k,h),'k')
    end
end
xlabel('m')
ylabel('Cs')
title("Coefficient of Speed against Mass")
%xlim([0 1])
ylim([0 1])
hold off


