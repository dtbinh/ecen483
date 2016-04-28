param;

mc = P.mc;      % kg
m = P.m;      % kg
b = P.b;        % N-s/m
L = P.L;         % m
g = P.g;       % m/s^2
xdot0 = P.xdot0;      % m/s
thdot0 = P.thdot0;     % deg/s
x0 = P.x0;             % m
th0 = P.th0;   % deg

% inner loop design
% assume b=0

kpth = -28980;
kdth = -10800;

numCLin = -kpth/(mc*L);
denCLin = [1 -kdth/(mc*L) (((mc+m)*P.g-kpth)/(mc*L))];
sysCLin = tf(numCLin,denCLin)

figure(2); clf;
step(sysCLin);

% outer loop design
kdx = -0.0685;
kpx = -0.0385;

Kthdc = 0.5963;
num_x_th = -[P.L 0 P.g];
den_x_th = [1 0 0];
sys_x_th = tf(num_x_th,den_x_th);
D = tf([kdx kpx],1);
G = Kthdc*sys_x_th;
sysCLout = feedback(D*G,1);

figure(3); clf;
step(sysCLout);

figure(4); clf;
rlocus(D*G); hold on;
rlocus(D*G,1,'r^');
sgrid([0.3 0.4],[0.4 0.5]);
hold off;

