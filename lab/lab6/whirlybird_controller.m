function pwm_commands = whirlybird_controller(in,P)
%phidot; phiddot; thetadot; thetaddot; psidot; psiddot
    psi_d = in(1);
    psi = in(2);
    phi = in(3);
    theta_d = in(4);
    theta = in(5); 
    t = in(6);
    
    % set persistent flag to initialize integrators and differentiators at
    % the start of the simulation
    persistent flag
    if t<P.Ts,
        flag = 1;
    else
        flag = 0;
    end
    
    %equilibrium
    Fe = P.Fe;
    F_ff = Fe*cos(theta_d);
    
     % declare persistent variables
    persistent integrator_pitch
    persistent thetadot
    persistent error_d1_pitch
    persistent theta_d1
    % reset persistent variables at start of simulation
    if flag==1,
        integrator_pitch  = 0;
        thetadot    = 0;
        error_d1_pitch    = 0;
        theta_d1    = 0;
    end
    
    % compute the error
    error = theta_d-theta;
    % update integral of error
    integrator_pitch = integrator_pitch + (P.Ts/2)*(error+error_d1_pitch);
    % update derivative of y
    thetadot = (2*P.tau-P.Ts)/(2*P.tau+P.Ts)*thetadot + 2/(2*P.tau+P.Ts)*(theta-theta_d1);
    % update delayed variables for next time through the loop
    error_d1_pitch = error;
    theta_d1 = theta;

    % compute the pid control signal
    u_unsat = P.kp_th*error + P.ki_th*integrator_pitch - P.kd_th*thetadot + F_ff;
    
    if     u_unsat > P.F_max,      F_tilde = P.F_max;
    elseif u_unsat < -P.F_max,     F_tilde = -P.F_max;
    else                         F_tilde = u_unsat;
    end
    
    F = Fe + F_tilde;

    Tau_e = P.Tau_e;

    % compute the force using the inner loop
    persistent integrator_yaw
    persistent psidot
    persistent error_d1_yaw
    persistent psi_d1
    % reset persistent variables at start of simulation
    if flag==1,
        integrator_yaw  = 0;
        psidot    = 0;
        error_d1_yaw    = 0;
        psi_d1    = 0;
    end
    
    % compute the error
    error = psi_d-psi;
    % update derivative of z
    psidot = (2*P.tau-P.Ts)/(2*P.tau+P.Ts)*psidot + 2/(2*P.tau+P.Ts)*(psi-psi_d1);
    
    % update integral of error
    %if abs(zdot) < 0.005
        integrator_yaw = integrator_yaw + (P.Ts/2)*(error+error_d1_yaw);
    %end
    
    % update delayed variables for next time through the loop
    error_d1_yaw = error;
    psi_d1     = psi;

    % compute the pid control signal
    u_unsat = P.kp_psi*error + P.ki_psi*integrator_yaw - P.kd_psi*psidot;
    
    phi_d = u_unsat;
    
    persistent integrator_roll
    persistent phidot
    persistent error_d1_roll
    persistent phi_d1
    % reset persistent variables at start of simulation
    if flag==1,
        integrator_roll  = 0;
        phidot    = 0;
        error_d1_roll    = 0;
        phi_d1    = 0;
    end
    
    % compute the error
    error = phi_d-phi;
    % update integral of error
    integrator_roll = integrator_roll + (P.Ts/2)*(error+error_d1_roll);
    % update derivative of y
    phidot = (2*P.tau-P.Ts)/(2*P.tau+P.Ts)*phidot + 2/(2*P.tau+P.Ts)*(phi-phi_d1);
    % update delayed variables for next time through the loop
    error_d1_roll = error;
    phi_d1 = phi;

    % compute the pid control signal
    u_unsat = P.kp_phi*error + P.ki_phi*integrator_roll - P.kd_phi*phidot;
    
    Tau_tilde = u_unsat;
    
    Tau = Tau_e + Tau_tilde;
    
    % Convert force and torque to PWM outputs
    u_left = 1/(2*P.km)*(F + Tau/P.d);
    u_right = 1/(2*P.km)*(F - Tau/P.d);
  
  if u_left<0
     u_left = 0;
  elseif u_left>100
      u_left = 100;
  end
  
  if u_right<0
     u_right = 0;
  elseif u_right>100
      u_right = 100;
  end
    
    pwm_commands = [u_left; u_right];  

end



