function drawBall(u)

    % process inputs to function
    z        = u(1);
    theta    = u(2);
    t        = u(3);
    
    l = 0.5;
    r = 0.1;
    % define persistent variables 
    persistent rod_handle
    persistent circle_handle
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        figure(1), clf
        track_width=1;
        plot([-track_width,track_width],[0,0],'k'); % plot track
        hold on
        rod_handle  = drawRod(theta, l, [], 'normal');
        circle_handle = drawCircle(theta, z, r, [], 'normal');
        axis([-track_width,track_width,-track_width,track_width]);
    
        
    % at every other time step, redraw base and rod
    else 
        drawRod(theta, l, rod_handle, 'normal');
        drawCircle(theta, z, r, circle_handle, 'normal');
    end
end

%
%=======================================================================
% drawCircle
%=======================================================================
%

function handle = drawCircle(theta, z, r, handle, mode)

  xi = 0:0.1:2*pi;
  
  X = z*cos(theta)-r*sin(theta)+r*cos(xi);
  Y = z*sin(theta)+r*cos(theta)+r*sin(xi);

  if isempty(handle),
    handle = fill(X, Y, 'g', 'EraseMode', mode);
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
function handle = drawRod(theta, l, handle, mode)

  
  X = [0, l*cos(theta)];
  Y = [0, l*sin(theta)];

  if isempty(handle),
    handle = plot(X, Y, 'g', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    drawnow
  end
end

  