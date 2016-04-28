function plotWhirlybirdStateVariables(uu)
%
% modified 10/1/2009 - RB


    % process inputs to function
    phi         = 180/pi*uu(1);      % roll angle of whirlybird     
    phidot      = 180/pi*uu(2);      % roll rate
    theta       = 180/pi*uu(3);      % pitch angle or arm
    thetadot    = 180/pi*uu(4);      % pitch rate
    psi         = 180/pi*uu(5);      % yaw angle of arm
    psidot      = 180/pi*uu(6);      % yaw rate
    phi_c       = 180/pi*uu(7);      % commanded roll angle
    phidot_c    = 180/pi*uu(8);      % commanded roll rate
    theta_c     = 180/pi*uu(9);      % commanded pitch angle
    thetadot_c  = 180/pi*uu(10);     % commanded pitch rate
    psi_c       = 180/pi*uu(11);     % commanded yaw angle
    psidot_c    = 180/pi*uu(12);     % commanded yaw rate
    F           = uu(13);            % commanded force
    tau         = uu(14);            % commanded torque
    pwm_l       = uu(15);            % left PWM signal
    pwm_r       = uu(16);            % right PWM signal
    t           = uu(17);            % simulation time
    
    phihat      = phi;
    phidothat   = phidot;
    thetahat    = theta;
    thetadothat = thetadot;
    psihat      = psi;
    psidothat   = psidot;

    % define persistent variables 
    persistent fig_phi;
    persistent fig_phidot;
    persistent fig_theta;
    persistent fig_thetadot;
    persistent fig_psi;
    persistent fig_psidot;
    persistent fig_F;
    persistent fig_tau;
    persistent fig_pwm;
    

  % first time function is called, initialize plot and persistent vars
    if t<0.1,
        figure(2), clf

        subplot(5,2,1)
        hold on
        fig_phi = graph_y_yhat_yd(t, phi, phihat, phi_c, '\phi', []);
        
        subplot(5,2,2)
        hold on
        fig_phidot = graph_y_yhat_yd(t, phidot, phidothat, phidot_c, 'phidot', []);
        
        subplot(5,2,3)
        hold on
        fig_theta = graph_y_yhat_yd(t, theta, thetahat, theta_c, '\theta', []);
        
        subplot(5,2,4)
        hold on
        fig_thetadot = graph_y_yhat_yd(t, thetadot, thetadothat, thetadot_c, 'thetadot', []);
        
        subplot(5,2,5)
        hold on
        fig_psi = graph_y_yhat_yd(t, psi, psihat, psi_c, '\psi', []);
        
        subplot(5,2,6)
        hold on
        fig_psidot = graph_y_yhat_yd(t, psidot, psidothat, psidot_c, 'psidot', []);
        
        subplot(5,2,7)
        hold on
        fig_F = graph_y(t, F, [], 'b');
        ylabel('F')
        
        subplot(5,2,8)
        hold on
        fig_tau = graph_y(t, tau, [], 'b');
        
        subplot(5,2,9)
        hold on
        fig_pwm = graph_y_yd(t, pwm_l, pwm_r, 'PWM', []);

        
    % at every other time step, redraw quadrotor and target
    else 
       graph_y_yhat_yd(t, phi, phihat, phi_c, '\phi', fig_phi);
       graph_y_yhat_yd(t, phidot, phidothat, phidot_c, '\dot{\phi}', fig_phidot);
       graph_y_yhat_yd(t, theta, thetahat, theta_c, '\theta', fig_theta);
       graph_y_yhat_yd(t, thetadot, thetadothat, thetadot_c, '\dot{\theta}', fig_thetadot);
       graph_y_yhat_yd(t, psi, psidot, psi_c, '\psi', fig_psi);
       graph_y_yhat_yd(t, psidot, psidothat, psidot_c, '\dot{\psi}', fig_psidot);
       graph_y(t, F, fig_F);
       graph_y(t, tau, fig_tau);
       graph_y_yd(t, pwm_l, pwm_r, 'PWM', fig_pwm);
    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph y with lable mylabel
function handle = graph_y(t, y, handle, color)
  
  if isempty(handle),
    handle    = plot(t,y,color);
  else
    set(handle,'Xdata',[get(handle,'Xdata'),t]);
    set(handle,'Ydata',[get(handle,'Ydata'),y]);
    %drawnow
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph y and yd with lable mylabel
function handle = graph_y_yd(t, y, yd, lab, handle)
  
  if isempty(handle),
    handle(1)    = plot(t,y,'b');
    handle(2)    = plot(t,yd,'g');
    ylabel(lab)
    set(get(gca, 'YLabel'),'Rotation',0.0);
  else
    set(handle(1),'Xdata',[get(handle(1),'Xdata'),t]);
    set(handle(1),'Ydata',[get(handle(1),'Ydata'),y]);
    set(handle(2),'Xdata',[get(handle(2),'Xdata'),t]);
    set(handle(2),'Ydata',[get(handle(2),'Ydata'),yd]);
    %drawnow
  end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the variable y in blue, its estimated value yhat in green, and its 
% desired value yd in red, lab is the label on the graph
function handle = graph_y_yhat_yd(t, y, yhat, yd, lab, handle)
  
  if isempty(handle),
    handle(1)   = plot(t,y,'b');
    handle(2)   = plot(t,yhat,'g');
    handle(3)   = plot(t,yd,'r');
    ylabel(lab)
    set(get(gca,'YLabel'),'Rotation',0.0);
  else
    set(handle(1),'Xdata',[get(handle(1),'Xdata'),t]);
    set(handle(1),'Ydata',[get(handle(1),'Ydata'),y]);
    set(handle(2),'Xdata',[get(handle(2),'Xdata'),t]);
    set(handle(2),'Ydata',[get(handle(2),'Ydata'),yhat]);
    set(handle(3),'Xdata',[get(handle(3),'Xdata'),t]);
    set(handle(3),'Ydata',[get(handle(3),'Ydata'),yd]);     
    %drawnow
  end

%
%=============================================================================
% sat
% saturates the input between high and low
%=============================================================================
%
function out=sat(in, low, high)

  if in < low,
      out = low;
  elseif in > high,
      out = high;
  else
      out = in;
  end

% end sat  


