P.x0 = [.1 0 0 0]';

% actual system parameters
AP.m1 = 0.35;  % kg
AP.m2 = 2;     % kg
AP.L = 0.5; % m
AP.g = 9.8; % m/s^2
% initial conditions
AP.y0        = P.x0(1);
AP.theta0    = P.x0(2);
AP.ydot0     = P.x0(3);
AP.thetadot0 = P.x0(4);
% limits on force
AP.F_max = 15; % N



% parameters known to the controller
P.m1 = AP.m1*.95;
P.m2 = AP.m2*1.1;
P.L  = AP.L*.9;
P.g  = AP.g;
% limits on force
P.F_max = AP.F_max;
P.Ts = 0.01; % sample rate of the controller
P.tau = 0.05; % dirty derivative gain



% equalibrium values
ye = P.L/2;
Fe = P.m1*P.g*ye/P.L+P.m2*P.g/2;

% gains for the inner loop
a1 = P.L/(P.m2*P.L^2/3+P.m1*ye^2);
P.A_th = 2*pi/180; % m
zeta_th = 0.707;
P.kp_th = (P.F_max-Fe)/P.A_th;
wn_th = sqrt(a1*P.kp_th);
P.kd_th = 2*zeta_th*wn_th/a1;
P.ki_th = 0;

% closed loop poles of the inner loop
roots([1,2*zeta_th*wn_th,wn_th^2]);


% gains for outer loop
A_z = 0.25;
zeta_z = 0.707;
P.kp_z = -P.A_th/A_z;
wn_z = sqrt(-P.m1*P.g*P.kp_z/P.m2);
P.kd_z = -2*P.m2*zeta_z*wn_z/P.m1/P.g;
P.ki_z = -0.05;

% closed loop poles of the outer loop
roots([1,2*zeta_z*wn_z,wn_z^2]);

ctrlss
