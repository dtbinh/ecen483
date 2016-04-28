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

Fe = g*(m1*l1 - m2*l2)/l1;

kp_psi = 0.66;
kd_psi = 0.465;

alat = l1*Fe/(m1*l1^2+m2*l2^2+jz);

s = tf('s');

num = alat;
den = [1 kd_psi*alat kp_psi*alat 0];

H = tf(num,den)

rltool(H)