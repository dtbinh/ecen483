function output = autopilot(inputs)
%
% autopilot for whirlybird
% 
% Modification History:
%   10/1/09 - RWB
%   10/28/09 - RWB
%   11/3/09 - RWB
%   10/29/13 - RWB
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
L1 = 0.9144; % meters
L2 = 0.3048; % m
m1 = 0.535;  % kg
m2 = 1;      % kg
d = 0.213;   % m
Jx = 0.0047; % Newton meters
Jy = 0.0014; % N-m
Jz = 0.0041; % N-m
g  = 9.8;    % m/s^2
pi = 3.14159;
km = (m1*L1*g-m2*L2*g)/L1/2/58.3; % Newtons / (pwm command)

% equilibrium force to balance whirlybird
Fe = (m1*L1-m2*L2)*g*cos(Pitch)/L1; 

%---------------------------------------------------
% Get tuning parameters from gains
zeta_roll     = Gain2; % damping ratio for roll (for example)

%---------------------------------------------------
% Design equations should go here


%---------------------------------------------------
% define and initialize persistent variables.

if ElapsedTime<=Ts,
    int_pitch_error    = 0;  % integral of pitch error
    pitch_error_d1     = 0;  % one step delay of pitch error
else
    int_pitch_error    = Variable1(1);
    pitch_error_d1     = Variable1(2);
end

% convert yaw and pitch commands to radians
PitchCommand = PitchSetpoint*pi/180;
YawCommand   = YawSetpoint*pi/180;


%---------------------------------------------------------------
% longitudinal controller

  % set the force equal to the equilibrium force (for example)
  F = Fe;

%---------------------------------------------------------------
% lateral controller
 
  % roll command (intermediate variable for successive loop closure)
  RollCommand = 0;

  % set the torque equal to zero (for example)
  tau = 0;

  
%---------------------------------------------------------------
% write persistent variables
 Variable1(1) = int_pitch_error; 
 Variable1(2) = pitch_error_d1;

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