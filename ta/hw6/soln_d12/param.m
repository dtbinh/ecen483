% actual system parameters
AP.m = 5;  % kg
AP.k = 3;  % Kg/s^2
AP.b = 0.5; % Kg/s


% initial conditions
AP.y0 = 0;
AP.ydot0 = 0;

% parameters known to controller
P.m = AP.m;  % kg
P.k = AP.k;  % Kg/s^2
P.b = AP.b; % Kg/s

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
