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
A_lon = [...
    0, 1;...
    0, 0;...
    ];
B_lon = [0; 1/(P.mc+2*P.mr)];
C_lon = [1, 0];
A_lat = [...
    0, 0, 1, 0;...
    0, 0, 0, 1;...
    0, -(P.Fe/(P.mc+2*P.mr)), -(P.mu/(P.mc+2*P.mr)), 0;...
    0, 0, 0, 0;...
    ];
B_lat = [0;0;0;1/(P.Jc+2*P.mr*P.d^2)];
C_lat = [1, 0, 0, 0; 0, 1, 0, 0];

% gains for pole locations
wn_h    = 0.5936;
zeta_h  = 0.707;
wn_z    = 0.9905;
zeta_z  = 0.707;
wn_th   = 13.3803;
zeta_th = 0.707;

ol_char_poly_lon = charpoly(A_lon);
des_char_poly_lon = [1,2*zeta_h*wn_h,wn_h^2];
des_poles_lon = roots(des_char_poly_lon);

ol_char_poly_lat = charpoly(A_lat);
des_char_poly_lat = conv([1,2*zeta_z*wn_z,wn_z^2],...
                     [1,2*zeta_th*wn_th,wn_th^2]);
des_poles_lat = roots(des_char_poly_lat);

% gains for longitudinal system
if rank(ctrb(A_lon,B_lon))~=2, disp('Lon System Not Controllable'); end
P.K_lon = place(A_lon,B_lon,des_poles_lon);
P.kr_lon = -1/(C_lon*inv(A_lon-B_lon*P.K_lon)*B_lon);

% gains for lateral system
if rank(ctrb(A_lat,B_lat))~=4, disp('Lat System Not Controllable'); end
P.K_lat = place(A_lat,B_lat,des_poles_lat);
Cout = [1, 0, 0, 0];
P.kr_lat = -1/(Cout*inv(A_lat-B_lat*P.K_lat)*B_lat);




