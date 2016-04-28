J = 45;
m = 200;
L = 0.03;
b = 5;
kd = 112;
kp = 95;
g = 9.8;

s = tf('s');

num = [1/J];
den = [1 (kd+b)/J (kp+m*g*L)/J 0];

H = tf(num,den)

rltool(H)