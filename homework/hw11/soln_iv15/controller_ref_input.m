function out = controller_ref_input(in,P)

% interpret input
  r   = in(1);
  y   = in(2);
  t   = in(3);
   
  persistent xhat
  persistent torque
 
  xe = P.Nx*r;
  ue = P.m*P.g*P.L*sin(r);

  N = 10;
  
  if t<P.Ts,
        xhat  = [0; 0];
        torque = 0;
  else
      for i=1:N,
          xhat = xhat + P.Ts/N*(P.F*(xhat-xe)+P.G*(torque-ue)+ P.LL*(y-P.H*xhat));
      end
  end
  
  % state feedback with linear feedforward
  % torque = -P.K*xhat + P.Nbar*r;
  
  % state feedback with nonlinear feedforward
  torque = -P.K*(xhat-xe) + ue;
  
  out = [torque; xhat];

end