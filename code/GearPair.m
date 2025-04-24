% Spur Gear
% 20 Degree Pressure Angle
wox = linspace(3200,3300,11); %RPM
wix = 3600; %RPM
woi = wox.*0.10472; %3200 RPM - 3300 RPM in terms of rad/s
wi = wix * 0.10472; %3600 RPM in terms of rad/s
Ko = 2; %High Shock
e = woi/wi; %ratio
mG = 1./e; %gear ratio
phi = deg2rad(20); %Pressure angle
k = 1; % full-depth function Yj = interpolateGeometryFactor(Np, Ng)

%Smallest spur pinion for no interference 
Nptheo = (2*k ./ ((1+2*mG)*(sin(phi)^2))) .* (mG+sqrt(mG.^2+(1+2.*mG)*(sin(phi)^2)));
Nps = ceil(Nptheo);% Pinion teeth = 13
Npm = 13; 
Ngm = mG.*Npm; %machinable number of teeth for output gear to shaft
Ngf = ceil(Ngm); % Gear teeth > 15

%Allowable range of Np and Ng based on theory: Np > 13 Ng > 15
%Allowable range of Np based on rule of thumb: Np > 17
Np = 18:1:28; % Input Gear
Ngx = mG .* Np; % Output Gear
Ng = ceil(Ngx);


%Design factors
m = [1, 1.25, 1.5, 2, 2.5, 3, 4, 5, 6, 8, 10]; %Preferred modules 
a = m; %Addendum
b = 1.25*m; %Dedendum
dpp = [];
dpg = [];

%ALL PITCH DIAMETERS, BASE RADII, CENTER LENGTH IN MM
gear_data = struct();      % Struct to store all gear sets

for i = 1:length(Np)
    curr_Np = Np(i);
    curr_Ng = Ng(i);       % Corresponding gear teeth
    % Preallocate vectors for this Np group
    mG_val = curr_Ng / curr_Np;
    wo = wi / mG_val;
    dpp_vec = zeros(1, length(m));
    dpg_vec = zeros(1, length(m));
    C_vec   = zeros(1, length(m));
    rbp_vec = zeros(1, length(m));
    rbg_vec = zeros(1, length(m));
    a_vec   = zeros(1, length(m));
    b_vec   = zeros(1, length(m));
    rdp_vec = zeros(1, length(m));
    rdg_vec = zeros(1, length(m));
    c_vec   = zeros(1, length(m));
    rfr_vec = zeros(1, length(m));
    ht_vec = zeros(1, length(m));

    fprintf('--- Np = %d | Ng = %d ---\n', curr_Np, curr_Ng);
    fprintf('Gear Ratio mG = %.3f\n', mG_val);
    fprintf('Output Speed wo (rad/s) = %.3f\n', wo)

    for j = 1:length(m)
        curr_m = m(j);
        dpp = curr_m * curr_Np;
        dpg = curr_m * curr_Ng;
        C   = (dpp + dpg)/2;
        rbp = (dpp/2) * cos(phi);
        rbg = (dpg/2) * cos(phi);

        a   = curr_m; % Addendum
        b   = 1.25*curr_m;       % Dedendum
        c   = b - a; % Clearance
        rfr = 0.3 ./ (1./curr_m); % Root fillet radius

        rdp = dpp - 2 * b;  % Root diameter pinion
        rdg = dpg - 2 * b;  % Root diameter gear
        ht = a+b; %Whole Depth
        % Store values in vectors
        dpp_vec(j) = dpp;
        dpg_vec(j) = dpg;
        C_vec(j)   = C;
        rbp_vec(j) = rbp;
        rbg_vec(j) = rbg;
        a_vec(j)   = a;
        b_vec(j)   = b;
        c_vec(j)   = c;
        rfr_vec(j) = rfr;
        rdp_vec(j) = rdp;
        rdg_vec(j) = rdg;
        ht_vec(j) = ht;
        % Print output
        fprintf(['Module = %.3f | dpp = %.3f | dpg = %.3f | C = %.3f | rbp = %.3f | rbg = %.3f | ' ...
                 'a = %.3f | b = %.3f | c = %.3f | rfr = %.3f | rdp = %.3f | rdg = %.3f | ht = %.3f\n'], ...
                 curr_m, dpp, dpg, C, rbp, rbg, a, b, c, rfr, rdp, rdg, ht);
    end

    % Store everything in the struct
    fieldName = sprintf('Np_%d', curr_Np);
    gear_data.(fieldName).Np        = curr_Np; %Gear teeth number
    gear_data.(fieldName).Ng        = curr_Ng; %Pinion teeth number
    gear_data.(fieldName).module    = m; %module
    gear_data.(fieldName).dpp       = dpp_vec; %Diametric Pitch Pinion
    gear_data.(fieldName).dpg       = dpg_vec; %Diametric Pitch Gear
    gear_data.(fieldName).C         = C_vec; %Center line length
    gear_data.(fieldName).rbpinion  = rbp_vec; %Base Radius of pinion
    gear_data.(fieldName).rbgear    = rbg_vec; %Base Radius of gear
    gear_data.(fieldName).a         = a_vec; %Addendum
    gear_data.(fieldName).b         = b_vec; %Deddendum
    gear_data.(fieldName).c         = c_vec; %Clearence
    gear_data.(fieldName).rfr       = rfr_vec; %Root fillet radius
    gear_data.(fieldName).rdp       = rdp_vec; %Root diameter pinion
    gear_data.(fieldName).rdg       = rdg_vec; %Root diameter gear
    gear_data.(fieldName).mG        = mG_val; %gear ratio
    gear_data.(fieldName).ht        = ht_vec; %Whole Depth
    fprintf('\n');
end

%% AGMA
% AGMA
% Variable Factors:
    %F = Face width
    %number of load cycles
%Material for AGMAStress: (Eg = Elasticity of gear, Ep = Elasiticity of pinion)
    vp = 0.3; %For all materials
    vg = 0.3; %For all materials
    % Steel
    Egs = 2*10^5; %Mpa
    Eps = 2*10^5; %Mpa
%Material for AGMAFactorOfSafety: (Bending Strength, Contact Strength)
    %Steel
        %Carburized and Hardened Grade 1
        BendingStrength = 379.2118; %Mpa for Bending
        ContactStrength = 1241.055; %Mpa for Contact
        



