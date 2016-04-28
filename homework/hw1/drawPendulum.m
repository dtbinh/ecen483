function drawPendulum(u)

    % process inputs to function
    x        = u(1);
    theta1   = u(2);
    theta2   = u(3);
    t        = u(4);
    
    
    width = 50;
    height = 20;
    l1 = 10;
    l2 = 24;
    r = 1;
    d1 = 10;
    d2 = 40;
    
    % define persistent variables 
    persistent base_handle
    persistent rod_handle1
    persistent rod_handle2
    persistent circle_handle1
    persistent circle_handle2
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        figure(1), clf
        track_width=50;
        plot([-track_width,track_width],[0,0],'k'); % plot track
        hold on
        base_handle = drawBase(x, width, height, [], 'normal');
        rod_handle1  = drawRod(x, theta1, l1, d1, [], 'normal');
        rod_handle2  = drawRod(x, theta2, l2, d2, [], 'normal');
        circle_handle1 = drawCircle(theta1, x, l1, r, d1, [], 'normal');
        circle_handle2 = drawCircle(theta2, x, l2, r, d2, [], 'normal');
        axis([-track_width,track_width,-track_width,track_width]);
    
        
    % at every other time step, redraw base and rod
    else 
        drawBase(x, width, height, base_handle, 'normal');
        drawRod(x, theta1, l1, d1, rod_handle1, 'normal');
        drawRod(x, theta2, l2, d2, rod_handle2, 'normal');
        drawCircle(theta1, x, l1, r, d1, circle_handle1, 'normal');
        drawCircle(theta2, x, l2, r, d2, circle_handle2, 'normal');
        
    end
end

   
%
%=======================================================================
% drawBase
% draw the base of the pendulum
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawBase(x, width, height, handle, mode)
  
  X = [x, x+width, x+width, x];
  Y = [0, 0, height, height];

  if isempty(handle),
    handle = fill(X,Y,'m', 'EraseMode', mode);
    %handle = plot(X,Y,'m', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    drawnow
  end
end
 
%
%=======================================================================
% drawRod
% draw the pendulum rod
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawRod(x, theta, l, d, handle, mode)

  
  X = [x+d, x+d+l*cos(theta)];
  Y = [0, l*sin(theta)];

  if isempty(handle),
    handle = plot(X, Y, 'g', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    drawnow
  end
end

  
%
%=======================================================================
% drawCircle
%=======================================================================
%

function handle = drawCircle(theta, x, l, r, d, handle, mode)

  N = 20;
  xi = 0:(2*pi/N):2*pi;
  
  X = (l)*cos(theta)+x+d+r*cos(xi);
  Y = (l)*sin(theta)+r*sin(xi);

  if isempty(handle),
    handle = fill(X, Y, 'g', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    drawnow
  end
end