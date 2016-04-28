function u=VTOL_ctrl(in,P)
    h_d   = in(1);
    z_d   = in(2);
    z     = in(3);
    h     = in(4);
    theta = in(5);
    t     = in(6);
    
    % use a digital differentiator to find hdot, zdot and thetadot
    persistent hdot
    persistent h_d1
    persistent zdot
    persistent z_d1
    persistent thetadot
    persistent theta_d1
    % reset persistent variables at start of simulation
    if t<P.Ts,
        hdot        = 0;
        h_d1        = 0;
        zdot        = 0;
        z_d1        = 0;
        thetadot    = 0;
        theta_d1    = 0;
    end
    hdot = (2*P.tau-P.Ts)/(2*P.tau+P.Ts)*hdot...
        + 2/(2*P.tau+P.Ts)*(h-h_d1);
    zdot = (2*P.tau-P.Ts)/(2*P.tau+P.Ts)*zdot...
        + 2/(2*P.tau+P.Ts)*(z-z_d1);
    thetadot = (2*P.tau-P.Ts)/(2*P.tau+P.Ts)*thetadot...
        + 2/(2*P.tau+P.Ts)*(theta-theta_d1);
    h_d1 = h;
    z_d1 = z;
    theta_d1 = theta;
    
    % integrator on altitude error
    error_h = h_d - h;
    persistent integrator_h
    persistent error_h_d1
    % reset persistent variables at start of simulation
    if t<P.Ts==1,
        integrator_h  = 0;
        error_h_d1    = 0;
    end
    if abs(hdot)<0.01,
        integrator_h = integrator_h + (P.Ts/2)*(error_h+error_h_d1);
    end
    error_h_d1 = error_h;

    % integrator on position error
    error_z = z_d - z;
    persistent integrator_z
    persistent error_z_d1
    % reset persistent variables at start of simulation
    if t<P.Ts==1,
        integrator_z  = 0;
        error_z_d1    = 0;
    end
    if abs(zdot)<0.01,
        integrator_z = integrator_z + (P.Ts/2)*(error_z+error_z_d1);
    end
    error_z_d1 = error_z;


    % longitudinal control for alititude
    % construct the state
    x_lon = [h; hdot];
    % equilibrium force
    Fe = (P.mc+2*P.mr)*P.g/cos(theta); 
        % divide Fe by cos(theta) so that force is right during
        % lateral translations.
    % compute the state feedback controller
    F_tilde = -P.K_lon*x_lon + P.kr_lon*h_d + P.ki_lon*integrator_h;
    F = Fe + F_tilde;

    % lateral control for position
    % construct the state
    x_lat = [z; theta; zdot; thetadot];
    % compute the state feedback controller
    tau = -P.K_lat*x_lat + P.kr_lat*z_d + P.ki_lat*integrator_z;

    % produce forces on right and left rotors
    u = P.mixing*[F; tau];

end

%-----------------------------------------------------------------
% saturation function
function out = sat(in,limit)
    if     in > limit,      out = limit;
    elseif in < -limit,     out = -limit;
    else                    out = in;
    end
end