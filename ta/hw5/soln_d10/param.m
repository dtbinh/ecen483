% system parameters
AP.m = 5;  % kg
AP.k = 3;  % Kg/s^2
AP.b = 0.5; % Kg/s


% initial conditions
AP.y0 = 0;
AP.ydot0 = 0;

Delta_ol = [1,AP.b/AP.m,AP.k/AP.m];
p_ol = roots(Delta_ol);

wn = 2.2/5;
th = 180/pi*asin(sqrt(log(100/5)^2/(log(100/5)^2+pi^2)));
sig = 1/10*log(141/1); 

Delta_cl_d = poly([-.49,-.49]);

P.kp =  AP.m*(Delta_cl_d(3)-Delta_ol(3));
P.kd = AP.m*(Delta_cl_d(2)-Delta_ol(2));
