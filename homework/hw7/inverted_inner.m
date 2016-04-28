g = 9.8;
m1 = 0.35;
m2 = 2;
l = 0.5;
z0 = 0.25;

a1 = l/(1/3*m2*l^2+m1*z0^2);


s = tf('s');

num = a1;
den = [1 0 0];

H = tf(num,den)

rltool(H)