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
x0  = (pi/180)*[...
       0;...
       0;...
       0;...
       0;...
       0;...
       0;...
       ];

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

  phi = x(1);
  phidot = x(2);
  theta = x(3);
  thetadot = x(4);
  psi = x(5);
  psidot = x(6);
  
  if u(1)<0
      u(1) = 0;
  elseif u(1)>100
      u(1) = 100;
  end
  
  if u(2)<0
      u(2) = 0;
  elseif u(2)>100
      u(2) = 100;
  end
      
  f_l = P.km*u(1);
  f_r = P.km*u(2);
  
  M = [P.jx 0 -P.jx*sin(theta);...
       0 P.m1*P.l1^2+P.jy*(cos(phi)^2)+P.jz*(sin(phi)^2) (P.jy-P.jz)*sin(phi)*cos(phi)*cos(theta);...
       -P.jx*sin(theta) (P.jy-P.jz)*sin(phi)*cos(phi)*cos(theta) (P.m1*P.l1^2+P.m2*P.l2^2+P.jy*sin(phi)^2+P.jz*cos(phi)^2)*cos(theta)^2+P.jx*sin(theta)^2;...
       ];
  
   C = [-thetadot^2*(P.jz-P.jy)*sin(phi)*cos(phi)+psidot^2*(P.jz-P.jy)*sin(phi)*cos(phi)*(cos(theta)^2)-thetadot*psidot*cos(theta)*(P.jx-(P.jz-P.jy)*(cos(phi)^2-sin(phi)^2));...
       psidot^2*sin(theta)*cos(theta)*(-P.jx+P.m1*P.l1^2+P.m2*P.l2^2+P.jy*sin(phi)^2+P.jz*cos(phi)^2)-2*phidot*thetadot*(P.jz-P.jy)*sin(theta)*cos(theta)-phidot*psidot*cos(theta)*(-P.jx+(P.jz-P.jy)*(cos(phi)^2-sin(phi)^2));...
       thetadot^2*(P.jz-P.jy)*sin(phi)*cos(phi)*sin(theta)-phidot*thetadot*cos(theta)*(P.jx+(P.jz-P.jy)*(cos(phi)^2-sin(phi)^2))-2*phidot*psidot*(P.jz-P.jy)*cos(theta)^2*sin(phi)*cos(phi)+2*thetadot*psidot*sin(phi)*cos(phi)*(P.jx-P.m1*P.l1^2-P.m2*P.l2^2-P.jy*sin(phi)^2-P.jz*cos(phi)^2);...
       ];
   
   dpdq = [0;...
          (P.m1*P.l1-P.m2*P.l2)*P.g*cos(phi);...
          0;...
          ];

   Q = [P.d*(f_l-f_r);...
       P.l1*(f_l+f_r)*cos(phi);...
       P.l1*(f_l+f_r)*cos(theta)*sin(phi)+P.d*(f_r-f_l)*sin(phi);...
       ];
   
   Final = M\(Q-C-dpdq);

  phiddot = Final(1);
  thetaddot = Final(2);
  psiddot = Final(3);
     
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
