function f = controller_whirlybird_lab2(u,P)

  % interpret input
  phi      = u(1);
  phidot   = u(2);
  theta    = u(3);
  thetadot = u(4);
  psi      = u(5);
  psidot   = u(6);
  
  % simple state feedback
  torque = -P.K*[phi; phidot; psi; psidot];
  F      = 1.73;
  
  % convert to left and right forces
  f_left = (F+torque)/2;
  f_right = (F-torque)/2;
  
  f = [f_left; f_right];
end