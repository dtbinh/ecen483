function [sys,x0,str,ts] = second_order_m(t,x,u,flag,zeta,wn)
    switch flag,
        case 0,
            [sys,x0,str,ts]=mdlInitializeSizes;  % initialize block
        case 1,
            sys=mdlDerivatives(t,x,u,zeta,wn);  % define xdot = f(t,x,u)
        case 3,
            sys=mdlOutputs(t,x,u,wn);           % define xup = g(t,x,u)
        otherwise,
            sys = [];
    end

%============================================================================
function [sys,x0,str,ts]=mdlInitializeSizes
    sizes = simsizes;
    sizes.NumContStates  = 2;
    sizes.NumDiscStates  = 0;
    sizes.NumOutputs     = 1;
    sizes.NumInputs      = 1;
    sizes.DirFeedthrough = 0;
    sizes.NumSampleTimes = 1;     % at least one sample time is needed
    sys = simsizes(sizes);

    x0  = [0; 0];  %  define initial conditions
    str = [];  % str is always an empty matrix
    % initialize the array of sample times
    ts  = [0 0];      % continuous sample time

%============================================================================
function xdot=mdlDerivatives(t,x,u,zeta,wn)
    xdot(1) = -2*zeta*wn*x(1) - wn^2*x(2) + u;
    xdot(2) = x(1);

%============================================================================
function y=mdlOutputs(t,x,u,wn)
    y = wn^2*x(2);