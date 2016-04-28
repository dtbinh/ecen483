syms g S ki kp kd

Plant = (-(5/7)*g)/(S^2);

bottom = 1 + (kd*S + kp + ki/S)*(Plant);

top = (ki/S+kp)*Plant;

PIDTF = simplify(top/bottom)

answer = simplify((ki/S+kp)*((-5/7)*g/S^2)/(1+(ki/S+kp+kd*S)*((-5/7)*g/S^2)))