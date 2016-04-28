J = 45;
m = 200;
L = 0.03;
b = 5;
g = 9.8;


num = [1/J];
den = [1 b/J m*g*L/J];

G = tf(num,den)

sisotool(G);