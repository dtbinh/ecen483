clear all;

% system parameters    
P.g = 9.81;
P.theta = 45*pi/180;
P.m = 0.5;
P.k1 = 0.05;
P.k2 = 0.02;
P.V_max = 25;
P.b = 0.1;
P.tau_a = 0.1;

% sample time for controller
P.Ts = 0.01;

% steady-state equilibrium force, voltage for z_e = 0;
P.z_e = 0;
P.F_e = P.k1*P.z_e + P.k2*(P.z_e^3)-P.m*P.g*sin(45*pi/180);              % Put expressions for the calculated equilibrium values
P.V_e = P.F_e;              % of the force and voltage here.

% initial conditions corresponding to equilibrium
P.z0 = P.z_e;
P.zdot0 = 0;
P.F0 = P.F_e;           

% Calculations for control designs

%==============================
% ROOT LOCUS DESIGN
%==============================
tm = P.tau_a*P.m;
num = 1/tm;
den = [1 (P.tau_a*P.b+P.m)/tm (P.tau_a*P.k1+P.b)/tm P.k1/tm];

S = tf('s');
H = tf(num, den);

% rltool(H)


%==============================
% FREQUENCY RESPONSE DESIGN
%==============================

w_c = 2;

phase_desired = 70;
phi_max = 80;
phi_max_rad = phi_max*pi/180;

alpha_lead = (1-sin(phi_max_rad))/(1+sin(phi_max_rad));
z_lead = w_c*sqrt(alpha_lead);
p_lead = w_c/sqrt(alpha_lead);

gain = 22.9;
D_lead = tf(gain*[1 z_lead], [1 p_lead]);

alpha_lag = 15;
z_lag = w_c/10;
p_lag = z_lag/alpha_lag;
D_lag = tf([1 z_lag], [1 p_lag]);

% sisotool(H)

% hold off;
% hold on;
% bode(H)
% bode(H*D_lead)
% bode(H*D_lead*D_lag)
% legend('Open loop', 'Lead', 'Lead-Lag')
% grid on


%==============================
% FREQUENCY RESPONSE DESIGN
%==============================

P.F = [0 1 0; -P.k1/P.m -P.b/P.m 1/P.m; 0 0 -1/P.tau_a];
P.G = [0; 0; 1/P.tau_a];
P.H = [1 0 0];
P.J = 0;

pp = [-1.8 -1.5+j -1.5-j];
P.K = place(P.F,P.G,pp);

NN = inv([P.F P.G; P.H P.J])*[0; 0; 0; 1];
P.Nx = NN(1:3);
P.Nu = NN(4);
P.Nbar = P.Nu + P.K*P.Nx;

pe = 5*pp;
P.LL = place(P.F', P.H', pe)';
