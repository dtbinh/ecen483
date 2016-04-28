function out=ctrl_est(in,P)
    z_c  = in(1);
    z    = in(2);
    t    = in(3);
    x    = in(4:6);
    
    % equilibrium state, input, output
    F_e  = P.k1*z_c + P.k2*(z_c^3)-P.m*P.g*sin(45*pi/180);
    V_e = F_e;
    x_e = [z_c; 0; 0];
    
    % estimator
    persistent xhat_
    persistent V

    % estimator equations go here...

    N = 10;
    
    if t<P.Ts,
        xhat_ = [0;0;0];
        V = 0;
    else
        for i = 1:N,
            xhat_ = xhat_ + P.Ts/N*(P.F*(xhat_-x_e) + P.G*(V-V_e) + P.LL*(z-P.H*xhat_));
        end
    end
    
    xhat = xhat_; %use estimated state
%     xhat = x; %use true state
    
    V = -P.K*(xhat-x_e)+V_e;
    
    out = [V;xhat];
    
end
    
function out = sat(in,limit)
    if     in > limit,      out = limit;
    elseif in < -limit,     out = -limit;
    else                    out = in;
    end
end
    
