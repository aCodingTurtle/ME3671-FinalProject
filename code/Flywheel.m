%% flywheel rework

clear
clc

%input variables
Fly_k = 68649.71932;  %Spring Constant k (N/m which is 392 lbs/in)
Fly_w = 5525*2*pi/60; %rad/s using 5525 RPM
[TP_Worst,TP_Avg] = CrankKinematics;

close all

%% torque energy balance

%worst case scenario, 2 springs breaking
for i = 1:length(TP_Worst)
    if TP_Worst(i) < 0
        Fly_T_1_Worst(i) = 0;
    else
        Fly_T_1_Worst(i) = TP_Worst(i);
    end
end
Fly_E_1_Worst = max(cumtrapz(Fly_T_1_Worst));

for i = 1:length(TP_Worst)
    if TP_Worst(i) > 0
        Fly_T_2_Worst(i) = 0;
    else
        Fly_T_2_Worst(i) = TP_Worst(i);
    end
end
Fly_E_2_Worst = min(cumtrapz(Fly_T_2_Worst));

%average use with maximum manufacturing defect
for i = 1:length(TP_Avg)
    if TP_Avg(i) < 0
        Fly_T_1_Avg(i) = 0;
    else
        Fly_T_1_Avg(i) = TP_Avg(i);
    end
end
Fly_E_1_Avg = max(cumtrapz(Fly_T_1_Avg));

for i = 1:length(TP_Avg)
    if TP_Avg(i) > 0
        Fly_T_2_Avg(i) = 0;
    else
        Fly_T_2_Avg(i) = TP_Avg(i);
    end
end
Fly_E_2_Avg = min(cumtrapz(Fly_T_2_Avg));

%% design space

p = [2.780 2.680 2.700 2.830 2.810 7.870 7.850 7.860 7.830]; %densities (g/cm^2)
Sy = [345 193 276 490 503 415 685 1275 400]; %yield strength in Mpa

p = p*1000;
Sy = Sy*10^6;


d_i = .01:.01:.49;
d_o = .02:.01:.5;
b = .001:.001:.5;

MinMagnitude = 1000000; %initial value to compare against
CsMin = .2; %set minimum Cs value


for i = 1:length(d_i)
    for j = 1:length(d_o)
        for k = 1:length(b)
            for h = 1:length(p)
                m(i,j,k,h) = (.25*pi*b(k)*(d_o(j)^2-d_i(i)^2))*p(h);
                if m(i,j,k,h) <= 0
                    m(i,j,k,h) = 0; %remove from design space
                    I(i,j,k,h) = 0;
                    Fly_CS_Worst(i,j,k,h) = 0;
                else
                    I(i,j,k,h) = .5*m(i,j,k,h)*((.5*d_o(j))^2+(.5*d_i(i))^2);
                    Fly_CS_Worst(i,j,k,h) = (Fly_E_1_Worst-Fly_E_2_Worst)/(I(i,j,k,h)*Fly_w^2);
                    Magnitude(i,j,k,h) = sqrt(Fly_CS_Worst(i,j,k,h)^2+m(i,j,k,h)^2); %calculate magnitude to find optimum trade off of mass and coefficient of speed
                    if Fly_CS_Worst(i,j,k,h) < CsMin && Magnitude(i,j,k,h) < MinMagnitude 
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

%% Spoke Optimization
d_shaft = .1; %shaft diameter plus flywheel base

%set design space
w = .001:.001:.05; %width
d = .005:.005:b(MinMagPosition(3)); %depth
N_Spokes = 3:1:10; %number of spokes

%set requirements
n_bending_min = 2; %minimum allowable failure in bending factor of safety
n_sheer_min = 2; %minimum allowable failure in sheer factor of safety
MinMagnitude = 1000000; %initial value to compare against

for i = 1:length(w)
    for j = 1:length(d)
        for k = 1:length(N_Spokes)
            m_spoke(i,j,k) = p(MinMagPosition(4))*w(i)*d(j);
            m_spokes(i,j,k) = m_spoke(i,j,k)*N_Spokes(k);
            n_bending(i,j,k) = Sy(MinMagPosition(4))/((max(TP_Worst)/(.5*d_i(MinMagPosition(1)))/N_Spokes(k))/(m_spoke(i,j,k)/12*(w(i)^2+d(j)^2)));
            n_shear(i,j,k) = Sy(MinMagPosition(4))/sqrt(3*(3*max(TP_Worst)/N_Spokes(k)/(2*w(i)*d(j)))^2);
            Magnitude2(i,j,k) = sqrt(m_spokes(i,j,k)^2+n_bending(i,j,k)^2+n_shear(i,j,k)^2);
            if n_bending(i,j,k) >= n_bending_min && n_shear(i,j,k) >= n_sheer_min && Magnitude2(i,j,k) < MinMagnitude 
                    MinMagnitude = Magnitude(i,j,k);
                    MinMagPosition2(1) = i;
                    MinMagPosition2(2) = j;
                    MinMagPosition2(3) = k;
            end
        end
    end
end


%% Final Calculations
Fly_CS_Avg = (Fly_E_1_Avg-Fly_E_2_Avg)/(I(MinMagPosition(1),MinMagPosition(2),MinMagPosition(3),MinMagPosition(4))*Fly_w^2);

%% Graphing

%Flywheel outer donut design space

% figure
% grid on
% hold on
% for k = 1:length(b)
%     for h = 1:length(p)
%         scatter(m(:,:,k,h),Fly_CS_Worst(:,:,k,h),'k')
%     end
% end
% xlabel('m')
% ylabel('Cs')
% title("Coefficient of Speed against Mass")
% %xlim([0 1])
% ylim([0 1])
% hold off

%Flywheel spokes design space

figure

subplot(1,2,1)
grid on
hold on
for k = 1:length(N_Spokes)
    scatter(m_spokes(:,:,k),n_bending(:,:,k),'k')
end
xlabel('m')
ylabel('n_bending')
title("Factor of Safety in Bending against Spoke Mass")
%xlim([0 1])
ylim([0 10^3])
hold off

subplot(1,2,2)
grid on
hold on
for k = 1:length(N_Spokes)
    scatter(m_spokes(:,:,k),n_shear(:,:,k),'k')
end
xlabel('m')
ylabel('n_bending')
title("Factor of Safety in Shear against Spoke Mass")
%xlim([0 1])
ylim([0 10^3])
hold off
