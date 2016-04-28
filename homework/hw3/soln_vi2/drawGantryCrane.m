function drawGantryCrane(u,bar,crane,L1,R1,L2,R2)

    % process inputs to function
    x = u(1);
    theta1 = u(2);
    theta2 = u(3);
    t = u(4);
    
    % define persistent variables 
    persistent crane_handle
    persistent rod1_handle
    persistent mass1_handle
    persistent rod2_handle
    persistent mass2_handle
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        figure(1), clf;
        plot([-bar/2-crane(1)/2,bar/2+crane(1)/2],[0,0],'k'); % plot track
        hold on
        axis([-bar/2-bar/5, bar/2+bar/5, -bar, bar/2]);
        axis('square');
        crane_handle = drawCrane(x, theta1, theta2, crane, [],'normal');
        rod1_handle = drawRod1(x, theta1, theta2, crane, L1, R1, L2, R2, [],'normal');
        mass1_handle = drawMass1(x, theta1, theta2, crane, L1, R1, L2, R2, [],'normal');
        rod2_handle = drawRod2(x, theta1, theta2, crane, L1, R1, L2, R2, [],'normal');
        mass2_handle = drawMass2(x, theta1, theta2, crane, L1, R1, L2, R2, [],'normal');
        
        
    % at every other time step, redraw crane and loads
    else 
        drawCrane(x, theta1, theta2, crane, crane_handle);
        drawRod1(x, theta1, theta2, crane, L1, R1, L2, R2, rod1_handle);
        drawMass1(x, theta1, theta2, crane, L1, R1, L2, R2, mass1_handle);
        drawRod2(x, theta1, theta2, crane, L1, R1, L2, R2, rod2_handle);
        drawMass2(x, theta1, theta2, crane, L1, R1, L2, R2, mass2_handle);
    end
end
 
%
%=======================================================================
% drawCrane
% draw the crane mass
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawCrane(x, theta1, theta2, crane, handle, mode)

  
  X = [x-crane(1)/2, x+crane(1)/2, x+crane(1)/2, x-crane(1)/2, x-crane(1)/2];
  Y = [0, 0, -crane(2), -crane(2), 0];

  if isempty(handle),
    handle = fill(X, Y, 'g', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    drawnow
  end
end

%
%=======================================================================
% drawLoad1
% draw the load1 rod and mass
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawRod1(x, theta1, theta2, crane, L1, R1, L2, R2, handle, mode)
  
  X = [x-crane(1)/4, (x-crane(1)/4)+L1*sin(theta1)];
  Y = [-crane(2), -crane(2)-L1*cos(theta1)];
  
  if isempty(handle),
    handle = plot(X, Y, 'k', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);% 'mxData',mx,'myData',my);
    drawnow
  end
end

%
%=======================================================================
% drawMass1
% draw the load1 rod and mass
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawMass1(x, theta1, theta2, crane, L1, R1, L2, R2, handle, mode)
 
  xi = 0:(2*pi/100):2*pi;
  X = (x-crane(1)/4)+(L1+R1)*sin(theta1) + R1*cos(xi);
  Y = -crane(2)-(L1+R1)*cos(theta1) + R1*sin(xi);

  if isempty(handle),
    handle = fill(X, Y, 'b', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    drawnow
  end
end

%
%=======================================================================
% drawLoad2
% draw the load1 rod and mass
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawRod2(x, theta1, theta2, crane, L1, R1, L2, R2, handle, mode)
  
  X = [x+crane(1)/4, (x+crane(1)/4)+L2*sin(theta2)];
  Y = [-crane(2), -crane(2)-L2*cos(theta2)];
 
  if isempty(handle),
    handle = plot(X, Y, 'k', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    drawnow
  end
end

%
%=======================================================================
% drawMass1
% draw the load1 rod and mass
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawMass2(x, theta1, theta2, crane, L1, R1, L2, R2, handle, mode)
 
  xi = 0:(2*pi/100):2*pi;
  X = (x+crane(1)/4)+(L2+R2)*sin(theta2) + R2*cos(xi);
  Y = -crane(2)-(L2+R2)*cos(theta2) + R2*sin(xi);

  if isempty(handle),
    handle = fill(X, Y, 'b', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    drawnow
  end
end
