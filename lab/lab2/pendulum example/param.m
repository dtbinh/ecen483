clear all

% physical constants
P.M = 10;
P.m = 2;
P.L = 10;
P.g = 9.8;

% initial conditions
P.y0 = 10;
P.ydot0 = 0;
P.theta0 = 0*pi/180;
P.thetadot0 = 0;

% sample time
P.Ts = 0.01;

% gain for dirty derivative
P.tau = 1/20;

% control design
A = [...
    0, 1, 0, 0;...
    0, 0, -P.m/P.M*P.g, 0;...
    0, 0, 0, 1;...
    0, 0, (P.M+P.m)/P.M/P.L*P.g, 0;....
    ];
B = [...
    0;...
    1/P.M;...
    0;...
    -1/P.M/P.L;...
    ];
P.Q = 10*diag([1,1,1,1]);
P.R = 1;
P.K = lqr(A,B,P.Q,P.R);

% drawing parameters
P.gap = 0.01;
P.width = 0.5;
P.height = 0.05;