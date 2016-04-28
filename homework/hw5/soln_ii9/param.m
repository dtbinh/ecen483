% system parameters
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

% select PD gains
A_th = 2*pi/180;
zeta_th = 0.707;
kp_th = -AP.F_max/A_th;
wn_th = sqrt(-(AP.m1+AP.m2)*AP.g/AP.m2/AP.ell-kp_th/AP.m2/AP.ell);
kd_th = -2*zeta_th*wn_th*AP.m2*AP.ell;

% DC gain of the inner loop 
DCgain_th = -kp_th/(-(AP.m1+AP.m2)*AP.g-kp_th);

% specs (tuning parameters) for outer loop
A_z = 2;
zeta_z = 0.707;
kp_z = A_th/A_z;
wn_z = sqrt(AP.m1*AP.g/AP.m2*kp_z);
kd_z = AP.m2/AP.m1/AP.g*(-AP.b/AP.m2 + 2*zeta_z*wn_z);


