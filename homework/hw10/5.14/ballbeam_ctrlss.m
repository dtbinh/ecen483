function F = ballbeam_ctrlss(in,AP)
% z_c         = in(1);
z           = in(2);
theta       = in(3);
zdot        = in(4);
thetadot    = in(5);

x = [z theta zdot thetadot]';
x1 = [AP.L/2 0 0 0]';
% u = z_c;
Fe = (AP.m2/2 + z*AP.m1/AP.L)*AP.g;
F = -AP.K*(x-x1) + Fe;% + P.Nbar*u;
end