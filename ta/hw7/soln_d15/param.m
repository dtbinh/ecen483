clear all

% actual system parameters
AP.m = 5;  % kg
AP.k = 3;  % Kg/s^2
AP.b = 0.5; % Kg/s


% initial conditions
AP.y0 = 0;
AP.ydot0 = 0;

% parameters known to controller
P.m = AP.m * .95;  % kg
P.k = AP.k * 1.01;  % Kg/s^2
P.b = AP.b * 1.05; % Kg/s

% sample time for controller
P.Ts = 0.01;

% dirty derivative gain
P.tau = 0.1;

% input constraint
P.Fmax = 2;

% maximum omega_n 
A = 1;
Fmax = P.Fmax - P.k*A/4;
zeta = 0.707;
P.kp = Fmax/A
wn = sqrt((P.k+P.kp)/P.m)
P.kd = 2*zeta*wn*P.m-P.b

% closed loop poles
roots([1,2*zeta*wn,wn^2])

% plot root locus 
%figure(2), clf
%rlocus([1/P.m], [1, (P.b+P.kd)/P.m, (P.k+P.kp)/P.m, 0])

% pick integrator gain
P.ki = 0.3;
