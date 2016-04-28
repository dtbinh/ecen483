clear all

% intentionally b, m, L off by 5%

P.J = 45;
P.b = 4.75;
P.m = 190;
P.g = 9.8;
P.L = 0.0285;

P.phi0 = 0;
P.phidot0 = 0;

zeta = 0.7;
tau_max = 50;
P.tau_max = tau_max;
e_max = 30*pi/180;

P.Ts = 0.01;
P.tau = 0.05;

kp = tau_max/e_max;
wn = sqrt((P.m*P.g*P.L+kp)/P.J);
kd = 2*P.J*zeta*wn-P.b;
ki = 64;

P.ki = ki;
P.kp = kp;
P.kd = kd;

den = [1 2*zeta*wn wn*wn];
CLroots = roots(den);