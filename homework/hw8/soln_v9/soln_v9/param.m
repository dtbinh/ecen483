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
AP.Fmax = 15; % N
ye = AP.L/2;
Fe = AP.m1*AP.g*ye/AP.L+AP.m2*AP.g/2

% gains for the inner loop
a1 = AP.L/(AP.m2*AP.L^2/3+AP.m1*ye^2);
A_th = 1*pi/180; % deg
zeta_th = 0.6;
kp_th = (AP.Fmax-Fe)/A_th
wn_th = sqrt(a1*kp_th)
kd_th = 2*zeta_th*wn_th/a1

% closed loop poles of the inner loop
roots([1,2*zeta_th*wn_th,wn_th^2])


% gains for outer loop
A_z = AP.L/2;
kp_z = -A_th/A_z
wn_z = sqrt(-5/7*AP.g*kp_z)
zeta_z = 0.75;
kd_z = -14*zeta_z*wn_z/(5*AP.g)

% closed loop poles of the outer loop
roots([1,2*zeta_z*wn_z,wn_z^2])
