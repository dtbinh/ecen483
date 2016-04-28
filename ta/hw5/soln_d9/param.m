% system parameters
AP.m = 5;  % kg
AP.k = 3;  % Kg/s^2
AP.b = 0.5; % Kg/s


% initial conditions
AP.y0 = 0;
AP.ydot0 = 0;

Delta_ol = [1,AP.b/AP.m,AP.k/AP.m];
p_ol = roots(Delta_ol);

Delta_cl_d = poly([-.5,-.2]);

P.kp =  AP.m*(Delta_cl_d(3)-Delta_ol(3));
P.kd = AP.m*(Delta_cl_d(2)-Delta_ol(2));
