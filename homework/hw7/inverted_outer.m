g = 9.8;
m1 = 0.35;
m2 = 2;
l = 0.5;
z0 = 0.25;


s = tf('s');

num = 5/7*g;
den = [1 0 0];

H = tf(num,den)

rltool(H)