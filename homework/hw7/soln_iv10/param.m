clear all

P.J = 45;
P.b = 5;
P.m = 200;
P.g = 9.8;
P.L = 0.03;

P.phi0 = 0;
P.phidot0 = 0;

zeta = 0.7;
tau_max = 50;
e_max = 30*pi/180;

kp = tau_max/e_max;
wn = sqrt((P.m*P.g*P.L+kp)/P.J)
kd = 2*P.J*zeta*wn-P.b
ki = 30;

den = [1 2*zeta*wn wn*wn]
CLroots = roots(den)