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

P.A_th = 1*pi/180;

P.Ts = 0.01;
P.tau = 0.05;
P.F_max = 10000000;

wnth = 1.8;
zetath = 0.2;

P.kpth = (P.mc+P.m)*P.g - wnth^2*P.mc*P.L;
P.kdth = -2*zetath*wnth*P.mc*P.L;

P.kdx = -0.0685;
P.kpx = -0.0385;
