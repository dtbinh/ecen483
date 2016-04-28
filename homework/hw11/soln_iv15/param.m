% system parameters
P.J = 45;
P.b = 5;
P.m = 200;
P.g = 9.81;
P.L = 0.03;

P.Ts = 0.01;

% initial conditions
P.phi0 = 0;
P.phidot0 = 0;

% control design
P.F = [0 1; -P.m*P.g*P.L/P.J -P.b/P.J]
P.G = [0; 1/P.J];
P.H = [1 0];
P.JJ = 0;

pp = [-1.3+1.3j -1.3-1.3j];
P.K = place(P.F,P.G,pp);

pe = 6*pp;
P.LL = place(P.F',P.H',pe)';

NN = inv([P.F P.G; P.H P.JJ])*[0; 0; 1];
P.Nx = NN(1:2);
P.Nu = NN(3);
P.Nbar = P.Nu + P.K*P.Nx;