clear all
% system parameters
AP.m1 = 0.35;  % kg
AP.m2 = 2;     % kg
AP.L = 0.5; % m
AP.g = 9.8; % m/s^2


% initial conditions
AP.theta0 = 0*pi/180;
AP.thetadot0 = 0;
AP.y0 = 0;
AP.ydot0 = 0;

AP.F = (AP.m2*AP.g*AP.L/2 + AP.m1*AP.g*AP.y0)/AP.L;


