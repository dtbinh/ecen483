s = tf('s');

num = 1600;
den = [1 8 1600];

H = tf(num,den)

rltool(H);