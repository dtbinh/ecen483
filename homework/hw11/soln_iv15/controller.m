function out = controller(in,P)

  % interpret input
  y   = in(1);
  t   = in(2);
   
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
  torque = -P.K*xhat;
  
  out = [torque; xhat];

end