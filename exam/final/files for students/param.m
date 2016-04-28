clear all
% You can use this if you want, but you don't have too.

% system parameters    
P.g = 9.81;
P.l = 0.25;
P.m = 0.1;
P.k1 = 0.02;
P.k2 = 0.01;
P.b = 0.1;

% max torque available
P.tau_max = 3;

P.tau_e = P.m*P.g*P.l;

P.theta0    = 0;
P.thetadot0 = 0;

% sample time for controller
P.Ts = 0.01;

% dirty derivative time constant
P.tau = 0.005;

% PART 3
% proportional gain
P.kp = (P.tau_max-P.tau_e)/(20*pi/180);

% natural frequency
P.wn = sqrt((P.kp+P.k1)/(P.m*P.l^2));

%zeta
P.zeta = 0.707;

% derivative gain
P.kd = 2*P.zeta*P.wn*P.m*P.l^2 - P.b;

% integrator gain
P.ki = 10;


% PART 4

w_c = 30;

ml_sqr = P.m*P.l^2;
num = 1/ml_sqr;
den = [1 P.b/ml_sqr P.k1/ml_sqr];

s = tf('s');
H = tf(num,den);

% sisotool(H)

phase_desired = 70;
[mag,phase] = bode(H, w_c);

phi_max = phase_desired-(phase+180);
phi_max_rad = phi_max*pi/180;

alpha_lead = (1-sin(phi_max_rad))/(1+sin(phi_max_rad));
z_lead = w_c*sqrt(alpha_lead);
p_lead = w_c/sqrt(alpha_lead);
gain = 14;
D_lead = tf(gain*[1 z_lead], [1 p_lead]);

ess_desired = 0.3;
alpha_lag = 2.2/ess_desired;
z_lag = w_c/10;
p_lag = z_lag/alpha_lag;
D_lag = tf([1 z_lag], [1 p_lag]);

% bode plots
% hold off;
% hold on;
% bode(H)
% bode(H*D_lead)
% bode(H*D_lead*D_lag)
% legend('Open loop', 'Lead', 'Lead-Lag')
% grid on

% PART 5

P.F = [0 1; -P.k1/ml_sqr -P.b/ml_sqr];
P.G = [0; 1/ml_sqr];
P.H = [1 0];
P.J = 0;
pp = [-25+15j -25-15j];
P.K = place(P.F,P.G,pp);

NN = inv([P.F P.G; P.H P.J])*[0;0;1];
P.Nx = NN(1:2);
P.Nu = NN(3);
P.Nbar = P.Nu + P.K*P.Nx;

pe = 5*pp;
P.LL = place(P.F',P.H',pe)';

% PART 6

rltool(H)

