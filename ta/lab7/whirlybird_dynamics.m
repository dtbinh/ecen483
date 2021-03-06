function [sys,x0,str,ts] = whirlybird_dynamics(t,x,u,flag,P)

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes(P);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u,P);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u,P);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(P)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [P.phi0; P.phidot0; P.theta0; P.thetadot0; P.psi0; P.psidot0];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function xdot=mdlDerivatives(t,x,u,P)
  phi      = x(1);
  phidot   = x(2);
  theta    = x(3);
  thetadot = x(4);
  psi      = x(5);
  psidot   = x(6);
  f_left   = u(1);
  f_right  = u(2);
  
  cphi = cos(phi);
  sphi = sin(phi);
  cthe = cos(theta);
  sthe = sin(theta);
  cpsi = cos(psi);
  spsi = sin(psi);

  M = [...
      P.Jx,...
      0,...
      -P.Jx*sthe;...
      0,...
      P.m1*P.L1^2+P.m2*P.L2^2+P.Jy*cphi^2+P.Jx*sphi^2,...
      (P.Jy-P.Jz)*sphi*cphi*cthe;...
      -P.Jx*sthe,...
      (P.Jy-P.Jz)*sphi*cphi*cthe,...
      (P.m1*P.L1^2+P.m2*P.L2^2+P.Jy*sphi^2+P.Jz*cphi^2)*cthe^2 + P.Jx*sthe^2;...
      ];
  c(1,1) = ...
      -thetadot^2*(P.Jz-P.Jy)*sphi*cphi...
      +(psidot^2)*(P.Jz-P.Jy)*sphi*cphi*(cthe^2)...
      -thetadot*psidot*cthe*(P.Jx - (P.Jz-P.Jy)*(cphi^2-sphi^2));
  %
  c(2,1) = ...
      (psidot^2)*sthe*cthe*(-P.Jx+P.m1*P.L1^2+P.m2*P.L2^2+P.Jy*(sphi^2)+P.Jz*(cphi^2))...
      -2*phidot*thetadot*(P.Jz-P.Jy)*sphi*cphi...
      -phidot*psidot*cthe*(-P.Jx+(P.Jz-P.Jy)*cthe*(cphi^2-sphi^2));
  %
  c(3,1) = ...
      (thetadot^2)*(P.Jz-P.Jy)*sphi*cphi*sthe...
      -phidot*thetadot*cthe*(P.Jx+(P.Jz-P.Jy)*(cphi^2-sphi^2))...
      -2*phidot*psidot*(P.Jz-P.Jy)*sphi*cphi*(cthe^2)...
      +2*thetadot*psidot*sthe*cthe*(P.Jx-P.m1*P.L1^2-P.m2*P.L2^2-P.Jy*sphi^2-P.Jz*cphi^2);
  g = [...
      0;...
      (P.m1*P.L1-P.m2*P.L2)*P.g*cthe;...
      0;...
      ];
  Q = [...
      P.d*(f_left - f_right);...
      P.L1*(f_left + f_right)*cphi;...
      P.L1*(f_left + f_right)*cthe*sphi + P.d*(f_left-f_right)*sthe;...
      ];
  
  temp = inv(M)*(Q - c - g);
  
  phiddot   = temp(1);
  thetaddot = temp(2);
  psiddot   = temp(3);
 

  xdot = [phidot; phiddot; thetadot; thetaddot; psidot; psiddot];
% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u,P)

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)

sys = x;

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
