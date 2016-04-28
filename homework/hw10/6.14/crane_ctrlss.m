function F = crane_ctrlss(in,P)
z_c         = in(1);
zdot        = in(2);
thetadot    = in(3);
z           = in(4);
theta       = in(5);
u = z_c;

x = [zdot thetadot z theta]';
x1 = [0 0 0 0]';

F = -P.K*(x-x1) + P.Nbar*u;
end