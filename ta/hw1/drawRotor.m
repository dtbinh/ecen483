function drawRotor(u)

    % process inputs to function
    z        = u(1);
    h        = u(2);
    theta    = u(3);
    t        = u(4);

    
    % define persistent variables 
    persistent body_handle
    persistent left_handle
    persistent right_handle
    persistent target_handle
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        figure(1), clf
        track_width=100;
        plot([-track_width,track_width],[0,0],'k'); % plot track
        hold on
        body_handle  = drawBody(theta, z, h, []);
%        circle_handle = drawCircle(theta, z, r, [], 'normal');
        axis([0,track_width,0,track_width]);    
        
    % at every other time step, redraw base and rod
    else 
        drawBody(theta, z, h, body_handle);
%         drawCircle(theta, z, r, circle_handle, 'normal');
    end
end

%
%=======================================================================
% drawBody
% draw Square Body
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%   
function handle = drawBody(theta, z, h, handle)
    
  width = 3;
  height = 3;

  X = [z*cos(theta), (z+width)*cos(theta), (z+width)*cos(theta),z*cos(theta)];
  Y = [h*sin(theta), (, height, height];

  if isempty(handle),
    handle = fill(X,Y,'m');
    %handle = plot(X,Y,'m', 'EraseMode', mode);
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

% function handle = drawCircle(theta, z, r, handle, mode)
% 
%   xi = 0:0.1:2*pi;
%   
%   X = z*cos(theta)-r*sin(theta)+r*cos(xi);
%   Y = z*sin(theta)+r*cos(theta)+r*sin(xi);
% 
%   if isempty(handle),
%     handle = fill(X, Y, 'g', 'EraseMode', mode);
%   else
%     set(handle,'XData',X,'YData',Y);
%     drawnow
%   end
% end


 
% %
% %=======================================================================
% % drawRod
% % draw the pendulum rod
% % return handle if 3rd argument is empty, otherwise use 3rd arg as handle
% %=======================================================================
% %
% function handle = drawRod(theta, l, handle, mode)
% 
%   
%   X = [0, l*cos(theta)];
%   Y = [0, l*sin(theta)];
% 
%   if isempty(handle),
%     handle = plot(X, Y, 'g', 'EraseMode', mode);
%   else
%     set(handle,'XData',X,'YData',Y);
%     drawnow
%   end
% end

  

