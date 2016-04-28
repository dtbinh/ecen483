
mc = 1500;    % kg
m = 500;     % kg
b = 2000;     % N-s/m
L = 10;       % m
g = 9.81;     % m/s^2

num = [-L 0 g];
den = [1 0 0];

G = 0.79*tf(num,den)

sisotool(G);