num = [AP.g];
den = [1 -AP.g*P.kd_z -AP.g*P.kp_z 0];
H = tf(num,den);

%rlocus(num,den);
rltool(H);