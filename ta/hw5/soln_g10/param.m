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


% mixing matrix
P.mixing = inv([1, 1; P.d, -P.d]);

wn = 2.2/8
th = 180/pi*asin(sqrt(log(100/15)^2/(log(100/15)^2+pi^2)))
sig = 1/20*log(141/1)


Delta_cl_d = poly([-0.2475+j*0.1191,-0.2475-j*0.1191])

% PD gains
P.kp = Delta_cl_d(3)*(P.mc+2*P.mr);
P.kd = Delta_cl_d(2)*(P.mc+2*P.mr);

