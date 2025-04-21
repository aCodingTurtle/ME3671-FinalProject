%% flywheel rework

clear
clc

%input variables
Fly_k = 68649.71932;  %Spring Constant k (N/m which is 392 lbs/in)
Fly_w = 3250*2*pi/60; %rad/s using 3250 RPM
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


d_i = .01:.05:.46;
d_o = .05:.05:.5;
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

T = .05; %deceleration/accelertaion time

%T_Spoke = max(TP_Worst)
T_Spoke = I(MinMagPosition(1),MinMagPosition(2),MinMagPosition(3),MinMagPosition(4))*(Fly_w/T);

%set design space
d_shaft = .0255; %placeholder value until we talk to dom
d_hub = .02+d_shaft; %shaft diameter plus flywheel base

w = .005:.001:.05; %width
d = .005:.001:b(MinMagPosition(3)); %depth
N_Spokes = 4:2:10; %number of spokes

%set requirements
n_bending_min = 5; %minimum allowable failure in bending factor of safety
n_sheer_min = 5; %minimum allowable failure in sheer factor of safety
MinMagnitude = 1000000; %initial value to compare against

for i = 1:length(w)
    for j = 1:length(d)
        for k = 1:length(N_Spokes)
            m_spoke(i,j,k) = p(MinMagPosition(4))*w(i)*d(j)*(d_i(MinMagPosition(1))-d_hub);
            m_spokes(i,j,k) = m_spoke(i,j,k)*N_Spokes(k);
            n_bending(i,j,k) = Sy(MinMagPosition(4))/(6*(T_Spoke/N_Spokes(k))/(.5*(d_i(MinMagPosition(1))-d_hub)*w(i)^2));
            n_shear(i,j,k) = Sy(MinMagPosition(4))/sqrt(3*(3*T_Spoke/(.5*d_i(MinMagPosition(1)))/N_Spokes(k)/(2*w(i)*d(j)))^2);
            Magnitude2(i,j,k) = sqrt(m_spokes(i,j,k)^2+n_bending(i,j,k)^2+n_shear(i,j,k)^2);
            if n_bending(i,j,k) >= n_bending_min && n_shear(i,j,k) >= n_sheer_min && Magnitude2(i,j,k) < MinMagnitude 
                    MinMagnitude = Magnitude2(i,j,k);
                    MinMagPosition2(1) = i;
                    MinMagPosition2(2) = j;
                    MinMagPosition2(3) = k;
            end
        end
    end
end

%% Woodrfuff key optimization

Key_w = .0254*[1/8 1/8 1/8 5/32 5/32 5/32]; %standard woodruff key sizing in to mm
Key_h = .0254*[.203 .25 .313 .25 .313 .375 ]; %standard woodruff key sizing in to mm
Key_D = .0254*[1/2 5/8 3/4 5/8 3/4 7/8];

n_bending_key_min = 1;
MinMagnitude = 100000;
Min_T = 10;
% for i = 1:length(Key_w)
%         for j = 1:length(p)
%             n_bending_key(i,j) = Sy(j)/(6*(T_Spoke)/(.5*(Key_h(i))*Key_w(i)^2));
%             Magnitude3(i,j) = sqrt(n_bending_key(i,j)^2+Key_w(i)^2);
%             if n_bending(i,j) >= n_bending_key_min && Magnitude3(i,j) < MinMagnitude 
%                     MinMagnitude = Magnitude3(i,j);
%                     MinMagPosition3(1) = i;
%                     MinMagPosition3(2) = j;
%             end
%         end
% end

for i = 1:length(Key_w)
        for j = 1:length(p)
            T_Failure(i,j) = I(MinMagPosition(1),MinMagPosition(2),MinMagPosition(3),MinMagPosition(4))*(Fly_w)/(Sy(j)/(6*(1)/(.5*(Key_h(i))*Key_w(i)^2))); %failure time in rapid acceleration/deceleration (factor of safety in bending of 1 used)
            if T_Failure(i,j) < Min_T
                    Min_T = T_Failure(i,j);
                    MinMagPosition3(1) = i;
                    MinMagPosition3(2) = j;
            end
        end
end

I_gear1 = 200;

for i = 1:length(Key_w)
        for j = 1:length(p)
            T_Failure2(i,j) = 2*I_gear1*(Fly_w)/(Sy(j)*Key_h(i)^2); %failure time in rapid acceleration/deceleration (factor of safety in bending of 1 used)
            if T_Failure2(i,j) < Min_T
                    Min_T = T_Failure2(i,j);
                    MinMagPosition4(1) = i;
                    MinMagPosition4(2) = j;
            end
        end
end

I_gear2 = 200;

for i = 1:length(Key_w)
        for j = 1:length(p)
            T_Failure2(i,j) = 2*I_gear2*(Fly_w)/(Sy(j)*Key_h(i)^2); %failure time in rapid acceleration/deceleration (factor of safety in bending of 1 used)
            if T_Failure2(i,j) < Min_T
                    Min_T = T_Failure2(i,j);
                    MinMagPosition4(1) = i;
                    MinMagPosition4(2) = j;
            end
        end
end

%% Final Calculations
m_hub = pi*d(MinMagPosition2(2))*((.5*d_hub)^2-(.5*d_shaft));

m_final = m(MinMagPosition(1),MinMagPosition(2),MinMagPosition(3),MinMagPosition(4))+m_spokes(MinMagPosition2(1),MinMagPosition2(2),MinMagPosition2(3))+m_hub %final mass of the donut, hub, and spokes
I_Final = I(MinMagPosition(1),MinMagPosition(2),MinMagPosition(3),MinMagPosition(4))+.5*m_hub*((.5*d_hub)^2+(.5*d_shaft)^2)+(w(MinMagPosition2(1))*d_i(MinMagPosition(1))^3)/12-(w(MinMagPosition2(1))*d_hub^3)/12; %final moment of inertia for fonut, hub, and spokes

CS_Worst_Final = (Fly_E_1_Worst-Fly_E_2_Worst)/(I_Final*Fly_w^2)
CS_Avg_Final = (Fly_E_1_Avg-Fly_E_2_Avg)/(I_Final*Fly_w^2)

Worst_Speed_Fluctuation = CS_Worst_Final*Fly_w/(2*pi/60) %rpm
Avg_Speed_Fluctuation = CS_Avg_Final*Fly_w/(2*pi/60) %rpm


%Fly_CS_Avg = (Fly_E_1_Avg-Fly_E_2_Avg)/(I(MinMagPosition(1),MinMagPosition(2),MinMagPosition(3),MinMagPosition(4))*Fly_w^2);

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
ylim([0 50])
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
ylim([0 50])
hold off

%woodruff key plot

figure
grid on
hold on
scatter(Sy(:,:),T_Failure(:,:),'k')
xlabel('Material Yield Strength')
ylabel('Time (s)')
title("Woodruff Key Time to Full Stop Without Breaking (flywheel)")
hold off

figure
grid on
hold on
scatter(Sy(:,:),T_Failure2(:,:),'k')
xlabel('Material Yield Strength')
ylabel('Time (s)')
title("Woodruff Key Time to Full Stop Without Breaking (gear 1) ")
hold off

figure
grid on
hold on
scatter(Sy(:,:),T_Failure3(:,:),'k')
xlabel('Material Yield Strength')
ylabel('Time (s)')
title("Woodruff Key Time to Full Stop Without Breaking (gear 2)")
hold off
