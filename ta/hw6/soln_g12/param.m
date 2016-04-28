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
P.mc = 1.0;  % kg
P.mr = 0.25;     % kg
P.ml = AP.mr; % kg
P.Jc = 0.0042; %kg m^2
P.d = 0.3; % m
P.mu = 0.1; % kg/s
P.g = 9.81; % m/s^2

P.fmax = 10;

% mixing matrix
P.mixing = inv([1, 1; P.d, -P.d]);

% equilibrium force and constraints
P.F0 = (P.mc+2*P.mr)*P.g;
Ftildemax = 2*P.fmax - P.F0;
taumax = (P.fmax-P.F0/2)/P.d;

% design equations for longitudinal control
A_h    = 10;
zeta_h = 0.707;
P.kp_h = Ftildemax/A_h;
wn_h   = sqrt(P.kp_h/(P.mc+2*P.mr));
P.kd_h = 2*zeta_h*wn_h*(P.mc+2*P.mr);


% design equations for lateral control
% PD design for lateral inner loop
b0       = 1/(P.Jc+2*P.mr*P.d^2);
A_th     = 1;
zeta_th  = 0.707;
P.kp_th  = taumax/A_th;
wn_th    = sqrt(b0*P.kp_th);
P.kd_th  = 2*zeta_th*wn_th/b0;

% DC gain for lateral inner loop
k_DC_th = 1;

%PD design for lateral outer loop
b1       = -P.F0/(P.mc+2*P.mr);
a1       = P.mu/(P.mc+2*P.mr);
A_z      = 10;
zeta_z   = 0.707;
P.kp_z   = -A_th/A_z;
wn_z     = sqrt(b1*P.kp_z);
P.kd_z   = (2*zeta_z*wn_z-a1)/b1;



