function F=ballbeam_ctrl(in,P)
    z_d   = in(1);
    z     = in(2);
    theta = in(3);
    t     = in(4);
    
     % use a digital differentiator to find zdot and thetadot
    persistent zdot
    persistent z_d1
    persistent thetadot
    persistent theta_d1
    % reset persistent variables at start of simulation
    if t<P.Ts,
        zdot        = 0;
        z_d1        = 0;
        thetadot    = 0;
        theta_d1    = 0;
    end
    zdot = (2*P.tau-P.Ts)/(2*P.tau+P.Ts)*zdot...
        + 2/(2*P.tau+P.Ts)*(z-z_d1);
    thetadot = (2*P.tau-P.Ts)/(2*P.tau+P.Ts)*thetadot...
        + 2/(2*P.tau+P.Ts)*(theta-theta_d1);
    z_d1 = z;
    theta_d1 = theta;

    % construct the state
    x = [theta; z; thetadot; zdot];
    % equilibrium force
    Fe = 0.5*P.m2*P.g;% + P.m1*P.g*z/P.L;
    % compute the state feedback controller
    F_tilde = -P.K*x + P.kr*z_d;
    F = sat( Fe + F_tilde, P.Fmax);
end



%-----------------------------------------------------------------
% saturation function
function out = sat(in,limit)
    if     in > limit,      out = limit;
    elseif in < -limit,     out = -limit;
    else                    out = in;
    end
end