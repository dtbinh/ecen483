m1 = AP.m1;  % kg
m2 = AP.m2;     % kg
L = AP.L; % m
g = AP.g; % m/s^2
ze = L/2;

n = 4;

a = ((m2*L^2)/3 + m1*ze^2);
F = [0      0       1       0;...
     0      0       0       1;...
     0      -5/7*g  0       0;...
     -m1*g/a 0       0       0];
G = [0;  0;   0;  L/a];
H = [1  0   0   0];
J = 0;

C = [G F*G F*F*G F*F*F*G];
if rank(C) == n
    display('controllable');
end

Poles = [-4.5+j*4.5 -6+j*1.5 -4.5-j*4.5 -6-j*1.5];

AP.K = place(F,G,Poles);
% K(1) is applied to phi and K(2) is applied to Phidot.
% This is perfectly analogous to PD control

% NN = inv([F G; H J])*[0; 0; 1];
% Nx = NN(1:2);
% Nu = NN(3);
% P.Nbar = Nu + P.K*Nx;