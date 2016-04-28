
mc = 1500;    % kg
m = 500;     % kg
b = 2000;     % N-s/m
L = 10;       % m
g = 9.81;     % m/s^2

num = [-1/(mc*L)];
den = [1 0 (mc+m)*g/(mc*L)];

G = tf(num,den)

sisotool(G);