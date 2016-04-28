kd = -0.15;
kp = -0.0698;
g = 9.8;

s = tf('s');

num = [5/7*g];
den = [1 -5/7*g*kd -5/7*g*kp 0];

H = tf(num,den)

rltool(H)