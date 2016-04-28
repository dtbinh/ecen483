mc = P.mc;
m = P.m;
b = P.b;
L = P.L;
g = P.g;

n = 4;

F = [-.13333    0   0   3.27;...
    .0133      0   0   -1.308;...
    1          0   0   0;...
    0          1   0   0];
G = [6.6667e-04; -6.6667e-05; 0; 0];
H = [0 0 1 0];
J = 0;

C = [G F*G F*F*G F*F*F*G];
if rank(C) == n
    display('controllable');
end

Poles = [-.55+.75j -.55-.75j -.6 -1.5];

P.K = place(F,G,Poles)/5;
% K(1) is applied to phi and K(2) is applied to Phidot.
% This is perfectly analogous to PD control

 NN = inv([F G;H J]) * [0;0;0;0;1];
 Nx = NN(1:4);
 Nu = NN(5);
 P.Nbar = Nu + P.K*Nx;