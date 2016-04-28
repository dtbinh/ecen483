clear all

% gain for dirty derivative
P.K = [0.7216 0.1148 0.1 0.137];

% drawing parameters
P.g = 9.81;
P.l1 = 0.85;
P.l2 = 0.3048;
P.m1 = 0.891;
P.m2 = 1;
P.d = 0.178;
P.h = 0.65;
P.r = 0.12;
P.jx = 0.0047;
P.jy = 0.0014;
P.jz = 0.0041;
P.km = 0.0546;
P.sig_gyro = 8.7266*10^(-5);
P.sig_pixel = 0.05;

P.Ts = 0.01;
P.tau = 1/(30*2*pi);
P.Fe = P.g*(P.m1*P.l1 - P.m2*P.l2)/P.l1;
P.Tau_e = 0;
P.F_max = 10.92;

% phi
P.phi_a0 = 0;
P.phi_a1 = 0;
P.max_L_pwm = 100;
P.max_R_pwm = 100;
P.kp_phi = 1.856;
P.kd_phi = 0.131;
P.ki_phi = 0;
%  P.kp_phi = 1.1137;
%  P.kd_phi = 0.0723;
%  P.ki_phi = 0;


% theta
P.theta_a0 = 0;
P.theta_a1 = 0;
P.theta_b0 = 1.152;
P.theta_b1 = 0;
P.kp_th = 10.9;
P.kd_th = 4.35;
P.ki_th = 2.4;
%  P.kp_th = 10.8805;
%  P.kd_th = 4.3026;
%  P.ki_th = 11;

% psi
%  P.kp_psi = 0.3954;
%  P.kd_psi = 0.4110;
%  P.ki_psi = 0.1748;
P.kp_psi = 0.66;
P.kd_psi = 0.465;
P.ki_psi = 0.1;
% % P.ki_psi = 0.4;

% wn_phi = 19.9
% wn_psi = 1.99