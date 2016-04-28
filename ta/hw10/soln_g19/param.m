clear all

% actual system parameters
AP.mc = 1.0;  % kg
AP.mr = 0.25;     % kg
AP.ml = AP.mr; % kg
AP.Jc = 0.0042; %kg m^2
AP.d = 0.3; % m
AP.mu = 0.1; % kg/s
AP.g = 9.81; % m/s^2

% initial conditions
AP.z0 = 0;
AP.zdot0 = 0;
AP.h0 = 0;
AP.hdot0 = 0;
AP.theta0 = 0;
AP.thetadot0 = 0;

% assumed system paramters used for design
P.mc = AP.mc;%*.95;  % kg
P.mr = AP.mr;%*1.05;     % kg
P.ml = P.mr; % kg
P.Jc = AP.Jc;%*0.95; %kg m^2
P.d = AP.d;%*1.03; % m
P.mu = AP.mu;%*0.98; % kg/s
P.g = 9.81; % m/s^2

% saturation limits for each rotor
P.fmax = 10;

% sample rate for controller
P.Ts = 0.01;

% dirty derivative gain for differentiator
P.tau = 0.05;

% mixing matrix
P.mixing = inv([1, 1; P.d, -P.d]);

% equilibrium force and constraints
P.Fe = (P.mc+2*P.mr)*P.g;
P.Ftildemax = 2*P.fmax - P.Fe;
P.taumax = (P.fmax-P.Fe/2)/P.d;

% % design equations for longitudinal control
% A_h    = 10;
% zeta_h = 0.707;
% P.kp_h = P.Ftildemax/A_h;
% wn_h   = sqrt(P.kp_h/(P.mc+2*P.mr));
% P.kd_h = 2*zeta_h*wn_h*(P.mc+2*P.mr);
% 
% P.ki_h = 0.5
% 
% % design equations for lateral control
% % PD design for lateral inner loop
% b0       = 1/(P.Jc+2*P.mr*P.d^2);
% A_th     = 1;
% zeta_th  = 0.707;
% P.kp_th  = P.taumax/A_th;
% wn_th    = sqrt(b0*P.kp_th);
% P.kd_th  = 2*zeta_th*wn_th/b0;
% 
% % DC gain for lateral inner loop
% k_DC_th = 1;
% 
% %PD design for lateral outer loop
% b1       = -P.Fe/(P.mc+2*P.mr);
% a1       = P.mu/(P.mc+2*P.mr);
% A_z      = 10;
% zeta_z   = 0.707;
% P.kp_z   = -A_th/A_z;
% wn_z     = sqrt(b1*P.kp_z);
% P.kd_z   = (2*zeta_z*wn_z-a1)/b1;
% 
% P.ki_z   = 0;

% state space design
P.A_lon = [...
    0, 1;...
    0, 0;...
    ];
P.B_lon = [0; 1/(P.mc+2*P.mr)];
P.C_lon = [1, 0];
P.A_lat = [...
    0, 0, 1, 0;...
    0, 0, 0, 1;...
    0, -(P.Fe/(P.mc+2*P.mr)), -(P.mu/(P.mc+2*P.mr)), 0;...
    0, 0, 0, 0;...
    ];
P.B_lat = [0;0;0;1/(P.Jc+2*P.mr*P.d^2)];
P.C_lat = [1, 0, 0, 0; 0, 1, 0, 0];

% form augmented system
A1_lon = [P.A_lon, zeros(2,1); P.C_lon, 0];
B1_lon = [P.B_lon; 0];
Cout_lat = [1, 0, 0, 0];
A1_lat = [P.A_lat, zeros(4,1); Cout_lat, 0];
B1_lat = [P.B_lat; 0];

% gains for pole locations
wn_h    = 0.5936;
zeta_h  = 0.707;
wn_z    = 0.9905;
zeta_z  = 0.707;
wn_th   = 13.3803;
zeta_th = 0.707;

ol_char_poly_lon = charpoly(P.A_lon);
des_char_poly_lon = conv([1,2*zeta_h*wn_h,wn_h^2],...
                          poly(-0.1));
des_poles_lon = roots(des_char_poly_lon);

ol_char_poly_lat = charpoly(P.A_lat);
des_char_poly_lat = conv(conv([1,2*zeta_z*wn_z,wn_z^2],...
                              [1,2*zeta_th*wn_th,wn_th^2]),...
                         poly(-0.1));
des_poles_lat = roots(des_char_poly_lat);

% gains for longitudinal system
% is the system controllable?
if rank(ctrb(A1_lon,B1_lon))~=3, 
    disp('System Not Controllable'); 
else % if so, compute gains
    K1_lon   = place(A1_lon,B1_lon,des_poles_lon); 
    P.K_lon  = K1_lon(1:2);
    P.ki_lon = K1_lon(3);
    P.kr_lon = -1/(P.C_lon*inv(P.A_lon-P.B_lon*P.K_lon)*P.B_lon);
end

% gains for lateral system
% is the system controllable?
if rank(ctrb(A1_lat,B1_lat))~=5, 
    disp('System Not Controllable'); 
else % if so, compute gains
    K1_lat   = place(A1_lat,B1_lat,des_poles_lat); 
    P.K_lat  = K1_lat(1:4);
    P.ki_lat = K1_lat(5);
    P.kr_lat = -1/(Cout_lat*inv(P.A_lat-P.B_lat*P.K_lat)*P.B_lat);
end


% observer design
% form augmented system for disturbance observer
A2_lon = [P.A_lon, P.B_lon; zeros(1,2), zeros(1,1)];
C2_lon = [P.C_lon, 0];
A2_lat = [P.A_lat, P.B_lat; zeros(1,4), zeros(1,1)];
C2_lat = [P.C_lat, zeros(2,1)];

% pick observer poles
wn_h_obs    = 10*wn_h;
wn_z_obs    = 10*wn_z;
wn_th_obs   = 5*wn_th;

des_obsv_poles_lon = roots([1,2*zeta_h*wn_h_obs,wn_h_obs^2]);
dist_obsv_pole_lon = -10;

des_obsv_poles_lat = [roots([1,2*zeta_z*wn_z_obs,wn_z_obs^2]);...
                      roots([1,2*zeta_th*wn_th_obs,wn_th_obs^2])];
dist_obsv_pole_lat = -10;


% is the longitudinal system observable?
if rank(obsv(A2_lon,C2_lon))~=3, 
    disp('System Not Observable'); 
else % if so, compute gains
    L2_lon = place(A2_lon', C2_lon', [des_obsv_poles_lon;dist_obsv_pole_lon])';
    P.L_lon = L2_lon(1:2);
    P.Ld_lon = L2_lon(3);
end


% is the lateral system observable?
if rank(obsv(A2_lat,C2_lat))~=5, 
    disp('System Not Observable'); 
else % if so, compute gains
    L2_lat = place(A2_lat', C2_lat', [des_obsv_poles_lat;dist_obsv_pole_lat])';
    P.L_lat = L2_lat(1:4,:);
    P.Ld_lat = L2_lat(5,:);
end






