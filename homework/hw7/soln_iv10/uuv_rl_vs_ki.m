% Integral gain design for UUV with PID controlJ = 45;m = 200;g = 9.81;L = 0.03;b = 5;kp = 95;kd = 112; ki = 60;tfinal = 40;% H is the TF taken from Evan's form for kinumH = 1/J;denH = [1 (b+kd)/J (m*g*L+kp)/J 0];H = tf(numH,denH);figure(1); clf;rlocus(H); hold on;rlocus(H,ki,'b^'); hold off;title('UUV roll control, root locus vs. ki');axis([-15 5 -10 10]); nCL = [kp/J ki/J];dCL = [1 (b+kd)/J (m*g*L+kp)/J ki/J]; sysCL = tf(nCL,dCL);figure(2);[yCL,t,xCL] = step(sysCL,tfinal);plot(t,yCL); grid;title('UUV Roll Response, PID Control');xlabel('time (sec)');ylabel('roll angle (rad)');