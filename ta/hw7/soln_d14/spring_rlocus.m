num = [1/AP.m];
den = [1 (P.b+P.kd)/AP.m (P.k+P.kp)/AP.m 0];
H = tf(num,den);

%rlocus(num,den);
rltool(H);