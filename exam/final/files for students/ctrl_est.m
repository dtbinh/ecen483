function out = ctrl_est(in,P)
    theta_c  = in(1);
    theta    = in(2);
    t        = in(3);
    x        = in(4:5);
    
    persistent xhat_
    persistent tau
    
    % equilibrium state, input, output
    x_e = [theta_c; 0];
    tau_e  = P.k1*theta_c + P.k2*theta_c^3+P.m*P.g*P.l*cos(theta_c);
    
    N = 10;
    
    if t<P.Ts,
        xhat_ = [0; 0];
        tau = 0;
    else
        for i=1:N,
          xhat_ = xhat_ + P.Ts/N*(P.F*xhat_+P.G*tau+ P.LL*(theta-P.H*xhat_));
        end
    end
        
    
    %xhat_-x
    xhat = xhat_; % use estimated state
%     xhat = x;  % use true state
    
    % state feedback with nonlinear feedforward
    tau = -P.K*(xhat-x_e) + tau_e;
   
    out = [tau; xhat];
    
end
    
function out = sat(in,limit)
    if     in > limit,      out = limit;
    elseif in < -limit,     out = -limit;
    else                    out = in;
    end
end
    
