function output = whirlybird_ctrl(inputs)
%
% autopilot for whirlybird
% 
% Modification History:
%   10/1/09 - RWB
%   10/28/09 - RWB
%   11/3/09 - RWB
%   

% process inputs
PitchSetpoint = inputs(1);
YawSetpoint   = inputs(2);
Roll          = inputs(3);
RollRate      = inputs(4);
Pitch         = inputs(5);
PitchRate     = inputs(6);
Yaw           = inputs(7);
YawRate       = inputs(8);
ElapsedTime   = inputs(9);
Gain1         = inputs(10);
Gain2         = inputs(11);
Gain3         = inputs(12);
Gain4         = inputs(13);
Gain5         = inputs(14);
Gain6         = inputs(15);
Gain7         = inputs(16);
Gain8         = inputs(17);
Gain9         = inputs(18);

% persistent variables
persistent Variable1
persistent Variable2
persistent Variable3
persistent Variable4

dt = 0.01;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start autopilot code here (i.e., paste area)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------
%% define parameters
Ts = dt; % sample rate
L1 = 0.85; % meters
L2 = 0.3048; % m
m1 = 0.891;  % kg
m2 = 1;      % kg
d = 0.178;   % m
Jx = 0.0047; % Newton meters
Jy = 0.0014; % N-m
Jz = 0.0041; % N-m
g  = 9.8;    % m/s^2
pi = 3.14159;
km = 0.0546; % Newtons / (pwm command)
tau = 0.05;  % dirty derivative gain

% Linear models 

% equilibrium force to balance whirlybird
Fe = (m1*L1-m2*L2)*g*cos(Pitch)/L1;

% compute available force and torque limits
fmax = 100*km-0.5*(m1*L1-m2*L2)*g/L1;
taumax = 2*fmax*d;
Fmax   = 2*fmax;

% gains for pitch loop
A_th = Gain1; % 25*pi/180; % m
zeta_th = Gain2;
a1 = L1/(m1*L1^2+m2*L2^2+Jy)
kp_th = Fmax/A_th;
wn_th = sqrt(a1*kp_th);

kd_th = 2*zeta_th*wn_th/a1;
ki_th = Gain3;

% gains for roll loop
A_phi = Gain4; % 10*pi/180; % m
zeta_phi = Gain5;
a2 = 1/Jx;
kp_phi = taumax/A_phi;
wn_phi = sqrt(a2*kp_phi);
kd_phi = 2*zeta_th*wn_phi/a2;
ki_phi = 0;

% gains for yaw loop
A_psi = Gain6; % 10*pi/180; % m
zeta_phi = Gain7;
a3 = (m1*L1-m2*L2)*g/(m1*L1^2+m2*L2^2+Jz);
kp_psi = A_phi/A_psi;
wn_psi = sqrt(a3*kp_phi);
kd_psi = 2*zeta_th*wn_phi/a3;
ki_psi = 0;

%---------------------------------------------------
% define and initialize persistent variables.

if ElapsedTime<=Ts,
    Variable1(1) = 0;  % integral of pitch error
    Variable1(2) = 0;  % one step delay of pitch error
    Variable1(3) = 0;  % derivative of pitch error - not used but shows how to implement differentiator
end
    pitch_integrator   = Variable1(1);
    pitch_error_d1     = Variable1(2);

% convert yaw and pitch commands to radians
PitchCommand = PitchSetpoint*pi/180;
YawCommand   = YawSetpoint*pi/180;

%-------------------------------------
% implement PID control for pitch
pitch_error = PitchCommand-Pitch;
pitch_integrator = pitch_integrator + (Ts/2)*(pitch_error+pitch_error_d1);
kp_th
pitch_error
ki_th
pitch_integrator
kd_th
PitchRate
F_unsat = kp_th*pitch_error + ki_th*pitch_integrator - kd_th*PitchRate;
% saturate Ftilde
if F_unsat > Fmax,
    Ftilde = Fmax;
elseif F_unsat < -Fmax,
    Ftilde = -Fmax;
else
    Ftilde = F_unsat;
end
% integrator anti-windup
if ki_th~=0
    pitch_integrator = pitch_integrator + Ts/ki_th*(Ftilde-F_unsat);
end
% force output 
F = Fe + Ftilde;

%-------------------------------------
% implement PD control for yaw
yaw_error = YawCommand-Yaw;
RollCommand = kp_psi*yaw_error - kd_psi*YawRate;

%-------------------------------------
% implement PD control for roll
roll_error = RollCommand-Roll;
tau_unsat = kp_phi*roll_error - kd_phi*RollRate;
% saturate Ftilde
if tau_unsat > taumax,
    tau = taumax;
elseif tau_unsat < -taumax,
    tau = -taumax;
end

  
%---------------------------------------------------------------
% write persistent variables
 Variable1 = [pitch_integrator; pitch_error];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stop autopilot code here (i.e., paste area)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


%---------------------------------------------------------------
% Convert force and torque to PWM outputs (don't change this)
  CommandL  = 1/2/km*(F + tau/d);
  CommandR = 1/2/km*(F - tau/d);
  
  % saturate PWM signals
  if CommandL > 100, CommandL=100;
  elseif CommandL < 0, CommandL = 0;
  end
  if CommandR > 100, CommandR=100;
  elseif CommandR < 0, CommandR = 0;
  end

  pwm_commands = [CommandL; CommandR];


%----------------------------------------------------------------
% collect commanded signals, 
  x_c = [...
      RollCommand;...    % commanded roll angle
      0;...        % commanded roll rate
      PitchCommand;...  % commanded pitch angle
      0;...        % commanded pitch rate
      YawCommand;...    % commanded yaw angle
      0;...        % commanded yaw rate
      F;...        % commanded force
      tau;...      % commanded torque
      CommandL;...   % left pwm
      CommandR;...  % right pwm
      ];
  
  
  output = [pwm_commands; x_c]; 