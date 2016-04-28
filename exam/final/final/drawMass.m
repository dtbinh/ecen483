function drawMass(u,w,L,theta)

    % process inputs to function
    y        = u(1);
    t        = u(2);
    
    % define persistent variables 
    persistent mass_handle
    persistent spring_handle
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        figure(1), clf
        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
        pts = [-3*L-L/5, 0; 0, 0]*R;
        plot(pts(:,1),pts(:,2),'k--'); % plot track
        hold on
        pts = [-3*L, 0; -3*L, 2*w]*R;
        plot(pts(:,1),pts(:,2),'k'); % plot wall
        mass_handle = drawMass_(y, w, L, theta, [], 'normal');
        spring_handle = drawSpring(y, w, L, theta, [], 'normal');
        axis([-3*L-L/5, L/5, -L/5, 3*L+L/5]);
        axis('square');
    
        
    % at every other time step, redraw base and rod
    else 
        drawMass_(y, w, L, theta, mass_handle);
        drawSpring(y, w, L, theta, spring_handle);
    end
end

   
%
%=======================================================================
% drawMass
% draw the mass
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawMass_(z, w, L, theta, handle, mode)
  
%  X = [y-w/2, y+w/2, y+w/2, y-w/2];
%  Y = [0, 0, w, w]; 
  
  R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
  pts = [z-w/2-2*L, 0; z+w/2-2*L, 0; z+w/2-2*L, w; z-w/2-2*L, w]*R;

  if isempty(handle),
    handle = fill(pts(:,1), pts(:,2), 'b', 'EraseMode', mode);
  else
    set(handle,'XData',pts(:,1),'YData',pts(:,2));
    drawnow
  end
  
end
 
%
%=======================================================================
% drawSpring
% draw the cord
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawSpring(z, w, L, theta, handle, mode)

  R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
  pts = [-3*L, w/2; z-w/2-2*L, w/2]*R;

  if isempty(handle),
    handle = plot(pts(:,1), pts(:,2), 'g', 'EraseMode', mode);
  else
    set(handle,'XData',pts(:,1),'YData',pts(:,2));
    drawnow
  end
end

  