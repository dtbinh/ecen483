% system parameters
AP.m1 = 0.35;  % kg
AP.m2 = 2;     % kg
AP.L = 0.5; % m
AP.g = 9.8; % m/s^2

% initial conditions
AP.theta0 = 0;
AP.thetadot0 = 0;
AP.y0 = AP.L/2;
AP.ydot0 = 0;

% limits on force
AP.F_max = 15; % N

P.m1 = AP.m1*0.95;  % kg
P.m2 = AP.m2*1.1;     % kg
P.L = AP.L*0.9; % m
P.g = AP.g;
P.F_max = AP.F_max;
P.Ts = 0.01;
P.tau = 0.05;

% equalibrium values
ye = P.L/2;
Fe = P.m1*P.g*ye/P.L+P.m2*P.g/2;

% gains for the inner loop
a1 = P.L/(P.m2*P.L^2/3+P.m1*ye^2);
P.A_th = 2*pi/180; % deg
zeta_th = 0.707;
P.kp_th = (P.F_max - Fe) / P.A_th;
wn_th = sqrt(a1*P.kp_th);
P.kd_th = 2*zeta_th*wn_th/a1;
P.ki_th = 0;

% closed loop poles of the inner loop
roots([1,2*zeta_th*wn_th,wn_th^2]);


% gains for outer loop
A_z = 0.25;
zeta_z = 0.707;
P.kp_z = -P.A_th/A_z; %-A_th/A_z
wn_z = sqrt(-P.m1*P.g*P.kp_z/P.m2);
P.kd_z = -2*P.m2*zeta_z*wn_z/P.m1/P.g;%-14*zeta_z*wn_z/(5*AP.g)
P.ki_z = 0;%-0.05;

% closed loop poles of the outer loop
roots([1,2*zeta_z*wn_z,wn_z^2]);
