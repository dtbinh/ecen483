function pwm_commands = autopilot(u, P)
    
    % Convert force and torque to PWM outputs
    u_left = 1/(2*P.km)*(u(2) + u(1)/P.d);
    u_right = 1/(2*P.km)*(u(2) - u(1)/P.d);

    pwm_commands = [u_left; u_right];  
end