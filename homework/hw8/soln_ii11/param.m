% actual system parameters
AP.m1 = 0.25;  % kg
AP.m2 = 1;     % kg
AP.ell = 0.5; % m
AP.b = 0.05; % N m
AP.g = 9.8; % m/s^2


% initial conditions
AP.z0 = 0;
AP.zdot0 = 0;
AP.theta0 = 0.1;
AP.thetadot0 = 0;


% input constraint
AP.F_max = 5;

% parameters known to the controll
P.m1  = AP.m1*.95;  % kg
P.m2  = AP.m2*1.03;     % kg
P.ell = AP.ell*.96; % m
P.b   = AP.b*1.05; % N m
P.g   = AP.g; % m/s^2

% input constraint
P.F_max = 5;

% select PD gains
P.A_th = 2*pi/180;
zeta_th = 0.707;
P.kp_th = -P.F_max/P.A_th;
wn_th = sqrt(-(P.m1+P.m2)*P.g/P.m2/P.ell-P.kp_th/P.m2/P.ell);
P.kd_th = -2*zeta_th*wn_th*P.m2*P.ell;

% DC gain of the inner loop 
DCgain_th = -P.kp_th/(-(P.m1+P.m2)*P.g-P.kp_th);

% specs (tuning parameters) for outer loop
A_z = 2;
zeta_z = 0.707;
P.kp_z = P.A_th/A_z;
wn_z = sqrt(P.m1*P.g/P.m2*P.kp_z);
P.kd_z = P.m2/P.m1/P.g*(-P.b/P.m2 + 2*zeta_z*wn_z);


P.ki_th = 0;
P.ki_z = 0;

P.Ts = 0.01;
P.tau = 0.05;

