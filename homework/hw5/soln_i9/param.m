% system parameters
AP.m = 0.5;  % kg
AP.ell = 0.3; % m
AP.b = 0.01; % N m s
AP.g = 9.8; % m/s^2


% initial conditions
AP.theta0 = 0;
AP.thetadot0 = 0;

% input constraint
AP.tau_max = 1;

% equalibrium torque
AP.theta_e = 0;
AP.tau_e = AP.m*AP.g*AP.ell/3*cos(AP.theta_e);

% select PD gains
A_th = 50*pi/180;
zeta = 0.707;
kp = (AP.tau_max-AP.tau_e)/A_th;
wn = sqrt(3*kp/AP.m/AP.ell^2);
kd = AP.m*AP.ell^2/3*2*zeta*wn-AP.b;



% maximum omega_n 
%zeta = 1/sqrt(2);
%M = (3/AP.m/AP.ell^2)*(AP.taumax-AP.taue);
%A = 10*pi/180;
%wn_max = sqrt(M/A*sqrt(1-zeta^2));
%wn = 0.9*wn_max;
%tr = pi/2/wn/sqrt(1-zeta^2);

% pd gains
%a1 = 3/AP.m/AP.ell^2;
%a2 = a1*AP.b;
%kp = wn^2/a1;
%kd = (2*zeta*wn-a2)/a1;

%ki = 0.5;

%k_antiwindup = 2;


