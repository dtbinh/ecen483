clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% physical parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P.L1 = 0.85; % meters
P.L2 = 0.3048; % m
P.m1 = 0.535;  % kg
P.m2 = 1;      % kg
P.d = 0.213;   % m
P.Jx = 0.0047; % Newton meters
P.Jy = 0.0014; % N-m
P.Jz = 0.0041; % N-m
P.g  = 9.8;    % m/s^2
P.km = (P.m1*P.L1*P.g-P.m2*P.L2*P.g)/P.L1/2/58.3; % Newtons / (pwm command)

% initial conditions
P.phi0 = 0;%10*pi/180;
P.phidot0 = 0;
P.theta0 = 0*pi/180;
P.thetadot0 = 0;
P.psi0 = 0;%0*pi/180;
P.psidot0 = 0;

% sample time
P.Ts = 0.01;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear models 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% equilibrium force to balance whirlybird
P.Fe = (P.m1*P.L1-P.m2*P.L2)*P.g/P.L1; 

A_lon = [0, 1; 0, 0];
B_lon = [0; P.L1/(P.m1*P.L1^2+P.m2*P.L2^2+P.Jy)];
C_lon = [1, 0];
D_lon = 0;

Astar = P.L1*P.Fe/(P.m1*P.L1^2+P.m2*P.L2^2+P.Jz);
A_lat = [0, 1, 0, 0; 0, 0, 0, 0; 0, 0, 0, 1; Astar, 0, 0, 0];
B_lat = [0; 1/P.Jx; 0; 0];
C_lat = [0, 0, 1, 0];
D_lat = 0;

A_roll = [0, 1; 0, 0]; 
B_roll = [0; 1/P.Jx];
C_roll = [1, 0];
D_roll = 0;

A_yaw = [0, 1; 0, 0];
B_yaw = [0; Astar];
C_yaw = [1, 0];
D_yaw = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specifications 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% choose the damping ratio
zeta = 0.707;

% maximum force
Fmax = 200*P.km;
taumax = 100*P.km*P.d;
phibar = 30*pi/180;

% maximum step sizes
pitch_c = 30*pi/180;
roll_c = 30*pi/180;
yaw_c = 90*pi/180;

% compute minimum rise time
J = P.m1*P.L1^2+P.m2*P.L2^2+P.Jy;
tr_pitch = 2*2.2/sqrt(Fmax*P.L1*sqrt(1-zeta^2)/J/pitch_c);

J = P.Jx;
tr_roll = 2*2.2/sqrt(taumax*sqrt(1-zeta^2)/J/roll_c);

J = P.m1*P.L1^2+P.m2*P.L2^2+P.Jz;
tr_yaw = 2*2.2/sqrt(P.L1*P.Fe*sin(phibar)*sqrt(1-zeta^2)/J/yaw_c);
tr_yaw = max(tr_yaw, 5*tr_roll);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pole placement control design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% longitudinal control

% desired pole locations
wn = 2.2/tr_pitch;
p_lon = [-wn*zeta+j*wn*sqrt(1-zeta^2), -wn*zeta-j*wn*sqrt(1-zeta^2)];
P.K_lon = place(A_lon, B_lon, p_lon);
P.kr_lon = -1/(C_lon*inv(A_lon-B_lon*P.K_lon)*B_lon);

% lateral control

% desired pole locations
wn = 2.2/tr_roll;
p_roll = [-wn*zeta+j*wn*sqrt(1-zeta^2), -wn*zeta-j*wn*sqrt(1-zeta^2)];
wn = 2.2/tr_yaw;
p_yaw = [-wn*zeta+j*wn*sqrt(1-zeta^2), -wn*zeta-j*wn*sqrt(1-zeta^2)];
p_lat = [p_roll, p_yaw];
P.K_lat = place(A_lat, B_lat, p_lat);
P.kr_lat = -1/(C_lat*inv(A_lat-B_lat*P.K_lat)*B_lat);

% roll control

% desired pole locations
wn = 2.2/tr_roll;
p_roll = [-wn*zeta+j*wn*sqrt(1-zeta^2), -wn*zeta-j*wn*sqrt(1-zeta^2)];
P.K_roll = place(A_roll, B_roll, p_roll);
P.kr_roll = -1/(C_roll*inv(A_roll-B_roll*P.K_roll)*B_roll);

% yaw control

% desired pole locations
wn = 2.2/tr_yaw;
p_yaw = [-wn*zeta+j*wn*sqrt(1-zeta^2), -wn*zeta-j*wn*sqrt(1-zeta^2)];
P.K_yaw = place(A_yaw, B_yaw, p_yaw);
P.kr_yaw = -1/(C_yaw*inv(A_yaw-B_yaw*P.K_yaw)*B_yaw);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design integrator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AA = [A_lon, [0;0]; C_lon, 0];
BB = [B_lon; 0];
K = place(AA, BB, [p_lon, -.2]);
%P.K_lon = K(1:2);
P.ki_lon = K(3);

%P.m2 = .75*P.m2



