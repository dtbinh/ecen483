clear all

P.mc = 1500;    % kg
P.m = 500;     % kg
P.b = 2000;     % N-s/m
P.L = 10;       % m
P.g = 9.81;     % m/s^2
P.xdot0 = 0;    % m/s
P.thdot0 = 0*pi/180; % deg/s
P.x0 = 0;       % m
P.th0 = 0*pi/180;   % deg

wnth = 1.8;
zetath = 0.2;

kpth = (P.mc+P.m)*P.g - wnth^2*P.mc*P.L
kdth = -2*zetath*wnth*P.mc*P.L

kdx = -0.0685;
kpx = -0.0385;
