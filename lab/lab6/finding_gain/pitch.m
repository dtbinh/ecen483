g = 9.81;
l1 = 0.85;
l2 = 0.3048;
m1 = 0.891;
m2 = 1;
d = 0.178;
h = 0.65;
r = 0.12;
jx = 0.0047;
jy = 0.0014;
jz = 0.0041;

kp_th = 10.9;
kd_th = 4.35;


alon = l1/(m1*l1^2+m2*l2^2+jy);

s = tf('s');

num = alon;
den = [1 alon*kd_th alon*kp_th 0];

H = tf(num,den)

rltool(H)