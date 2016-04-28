function out=VTOL_ctrl(in,P)
    h_d   = in(1);
    z_d   = in(2);
    z     = in(3);
    h     = in(4);
    theta = in(5);
    t     = in(6);

    % equilibrium force
    Fe = (P.mc+2*P.mr)*P.g/cos(theta); 
        % divide Fe by cos(theta) so that force is right during
        % lateral translations.

    % implement observer
    persistent xhat_lon       % estimated state (for observer)
    persistent dhat_lon       % estimate disturbance
    persistent F
    persistent xhat_lat
    persistent dhat_lat       % estimate disturbance
    persistent tau
    if t<P.Ts,
        xhat_lon = [0;0];
        dhat_lon = 0;
        F    = 0;
        xhat_lat = [0;0;0;0];
        dhat_lat = 0;
        tau  = 0;
    end
    N = 10;
    for i=1:N,
        xhat_lon = xhat_lon + ...
            P.Ts/N*(P.A_lon*xhat_lon+P.B_lon*(F-Fe+dhat_lon)...
                    + P.L_lon*(h-P.C_lon*xhat_lon));
        dhat_lon = dhat_lon + P.Ts/N*P.Ld_lon*(h-P.C_lon*xhat_lon);

        xhat_lat = xhat_lat + ...
            P.Ts/N*(P.A_lat*xhat_lat+P.B_lat*(tau+dhat_lat)...
                    + P.L_lat*([z;theta]-P.C_lat*xhat_lat));
        dhat_lat = dhat_lat + P.Ts/N*P.Ld_lat*([z;theta]-P.C_lat*xhat_lat);
    end
        
    % integrator on altitude error
    error_h = h_d - h;
    persistent integrator_h
    persistent error_h_d1
    % reset persistent variables at start of simulation
    if t<P.Ts==1,
        integrator_h  = 0;
        error_h_d1    = 0;
    end
    if abs(xhat_lon(2))<0.01, %x_lon(2)=hdot
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
    if abs(xhat_lat(3))<0.01, %x_lat(3)=zdot
        integrator_z = integrator_z + (P.Ts/2)*(error_z+error_z_d1);
    end
    error_z_d1 = error_z;


    % longitudinal control for alititude
    % compute the state feedback controller
    F_tilde = -P.K_lon*xhat_lon + P.kr_lon*h_d + P.ki_lon*integrator_h - dhat_lon;
    F = Fe + F_tilde;

    % lateral control for position
    % compute the state feedback controller
    tau = -P.K_lat*xhat_lat + P.kr_lat*z_d + P.ki_lat*integrator_z - dhat_lat;

    % produce forces on right and left rotors
    u = P.mixing*[F; tau];

    % x = [z; h; theta; zdot; hdot; thetadot]
    out = [u;...
            xhat_lat(1); xhat_lon(1); xhat_lat(2);...
            xhat_lat(3); xhat_lon(2); xhat_lat(4)];

end

%-----------------------------------------------------------------
% saturation function
function out = sat(in,limit)
    if     in > limit,      out = limit;
    elseif in < -limit,     out = -limit;
    else                    out = in;
    end
end