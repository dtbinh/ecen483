m1 = 0.35;
m2 = 2;
l = 0.5;
g = 9.8;
z0 = 0.25;

num = [-5/7*g];
den = [1 0 0];

G = tf(num,den)

sisotool(G);