function drawMSD(u,w,L)

    % process inputs to function
    y        = u(1);
    %ydot     = u(2);
    t        = u(3);
    
    % define persistent variables 
    persistent mass_handle
    persistent spring_handle
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        figure(1), clf
        plot([-L-L/5,2*L],[0,0],'k--'); % plot track
        hold on
        plot([-L, -L], [0, 2*w],'k'); % plot wall
        mass_handle = drawMass(y, w, L, [], 'normal');
        spring_handle = drawSpring(y, w, L, [], 'normal');
        axis([-L-L/5, 2*L, -L, 2*L]);
    
        
    % at every other time step, redraw base and rod
    else 
        drawMass(y, w, L, mass_handle);
        drawSpring(y, w, L, spring_handle);
    end
end

   
%
%=======================================================================
% drawMass
% draw the mass
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawMass(y, w, L, handle, mode)
  
  X = [y-w/2, y+w/2, y+w/2, y-w/2];
  Y = [0, 0, w, w];
  
  if isempty(handle),
    handle = fill(X,Y,'b', 'EraseMode', mode);
    %handle = plot(X,Y,'b', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
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
function handle = drawSpring(y, w, L, handle, mode)

  X = [-L, y-w/2];
  Y = [w/2, w/2];

  if isempty(handle),
    handle = plot(X, Y, 'g', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    drawnow
  end
end

  