function F= ballbeam_ctrl(in,P)
    z_d   = in(1);
    theta  = in(2);
    z     = in(3);
    t     = in(4);
    
    % set persistent flag to initialize integrators and differentiators at
    % the start of the simulation
    persistent flag
    if t<P.Ts,
        flag = 1;
    else
        flag = 0;
    end
    
    Fe = P.m1*P.g*z/P.L + 0.5*P.m2*P.g;
    
    % compute the desired angled angle using the outer loop control
    theta_d = PID_z(z_d,z,flag,P.kp_z,P.ki_z,P.kd_z,P.A_th,P.Ts,P.tau);
    % compute the force using the inner loop
    F_tilde = PID_th(theta_d,theta,flag,P.kp_th,P.ki_th,P.kd_th,P.F_max,P.Ts,P.tau);
    F = Fe + F_tilde;
    
end

%------------------------------------------------------------
% PID control for position
function u = PID_z(z_c,z,flag,kp,ki,kd,limit,Ts,tau)
    % declare persistent variables
    persistent integrator
    persistent zdot
    persistent error_d1
    persistent z_d1
    % reset persistent variables at start of simulation
    if flag==1,
        integrator  = 0;
        zdot    = 0;
        error_d1    = 0;
        z_d1    = 0;
    end
    
    % compute the error
    error = z_c-z;
    % update derivative of z
    zdot = (2*tau-Ts)/(2*tau+Ts)*zdot + 2/(2*tau+Ts)*(z-z_d1);
    
    % update integral of error
    %if abs(zdot) < 0.005
        integrator = integrator + (Ts/2)*(error+error_d1);
    %end
    
    % update delayed variables for next time through the loop
    error_d1 = error;
    z_d1     = z;

    % compute the pid control signal
    u_unsat = kp*error + ki*integrator - kd*zdot;
    u = sat(u_unsat,limit);
    
    % integrator anti-windup
end


%------------------------------------------------------------
% PID control for angle theta
function u = PID_th(theta_c,theta,flag,kp,ki,kd,limit,Ts,tau,t)
    % declare persistent variables
    persistent integrator
    persistent thetadot
    persistent error_d1
    persistent theta_d1
    % reset persistent variables at start of simulation
    if flag==1,
        integrator  = 0;
        thetadot    = 0;
        error_d1    = 0;
        theta_d1    = 0;
    end
    
    % compute the error
    error = theta_c-theta;
    % update integral of error
    integrator = integrator + (Ts/2)*(error+error_d1);
    % update derivative of y
    thetadot = (2*tau-Ts)/(2*tau+Ts)*thetadot + 2/(2*tau+Ts)*(theta-theta_d1);
    % update delayed variables for next time through the loop
    error_d1 = error;
    theta_d1 = theta;

    % compute the pid control signal
    u_unsat = kp*error + ki*integrator - kd*thetadot;
    u = sat(u_unsat,limit);
    
    % integrator anti-windup
    %if ki~=0,
         %integrator = integrator + Ts/ki*(u-u_unsat);
     %end
end

%-----------------------------------------------------------------
% saturation function
function out = sat(in,limit)
    if     in > limit,      out = limit;
    elseif in < -limit,     out = -limit;
    else                    out = in;
    end
end