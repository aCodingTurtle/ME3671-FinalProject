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

p = [2.78 2.68 2.7 2.83 2.81 7.87 7.85 7.86 7.83];

%densities (g/cm^2)

d_i = 1:1:24;
d_o = 2:1:25;
b = 1:1:5;

A_1 = 1/4*pi*d_i.^2;
A_2 = 1/4*pi*d_o.^2;

MinMagnitude = 1000; %initial value to compare against
MinMagIndex = 0; %index the position of MinMagnitude for reference
CsMin = 1*10^-5; %set minimum Cs value

for i = 1:length(d_i)
    for j = 1:length(d_o)
        for k = 1:length(b)
            for h = 1:length(p)
                m(i,j,k,h) = (1/4*pi*b(k)*(d_o(j)^2-d_i(i)^2))*p(h);
                if m(i,j,k,h) < 0
                    m(i,j,k,h) = 0; %remove from design space
                    I(i,j,k,h) = 0;
                    Fly_CoefSpeed(i,j,k,h) = 0;
                else
                    I(i,j,k,h) = 1/8*m(i,j,k,h)*(d_o(j)^2-d_i(i)^2);
                    Fly_CoefSpeed(i,j,k,h) = (Fly_E_1-Fly_E_2)./(I(i,j,k,h)*Fly_w^2);
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
xlim([0 1000])
ylim([0 4*10^-5])
hold off


