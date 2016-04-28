function out = controller_ref_input(in,P)

% interpret input
  r   = in(1);
  y   = in(2);
  t   = in(3);
   
  persistent xhat
  persistent torque
  
  N = 10;
  
  if t<P.Ts,
        xhat  = [0; 0];
        torque = 0;
  else
      for i=1:N,
          xhat = xhat + P.Ts/N*(P.F*xhat+P.G*torque+ P.LL*(y-P.H*xhat));
      end
  end
  
  % simple state feedback
  torque = -P.K*xhat + P.Nbar*r;
  torque = -P.K*(xhat-P.Nx*r) + P.m*P.g*P.L*sin(r);
  
  out = [torque; xhat];

end