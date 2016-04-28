function pwm_commands = autopilot(u, P)
    
    % Convert force and torque to PWM outputs
    u_left = 1/2/P.km*(P.Fe + P.Tau_e/P.d);
    u_right = 1/2/P.km*(P.Fe + P.Tau_e/P.d);

    pwm_commands = [u_left; u_right];  
end