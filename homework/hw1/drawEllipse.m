function drawEllipse(u)

    % process inputs to function
    phi    = u(1);
    t      = u(2);
    
    % drawing parameters
    L = 0.03;
    width = L;
    
    % define persistent variables 
    persistent base_handle
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        figure(1), clf
        track_width=3;
        plot([-track_width,track_width],[0,0],'k'); % plot track
        hold on
        base_handle = drawBase(phi, [], 'normal');
 
        axis([-track_width,track_width,-track_width,track_width]);
        
    % at every other time step, redraw base and rod
    else 
        drawBase(phi, base_handle, 'normal');
    end
end

   
%
%=======================================================================
% drawBase
% draw the base of the pendulum
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawBase(phi, handle, mode)
  
  X = [(-2)*cos(phi)-(-1)*sin(phi), (2)*cos(phi)-(-1)*sin(phi), (2)*cos(phi)-(2)*sin(phi), (-2)*cos(phi)-(2)*sin(phi)];
  Y = [(-2)*sin(phi)+(-1)*cos(phi), (2)*sin(phi)+(-1)*cos(phi), (2)*sin(phi)+(2)*cos(phi), (-2)*sin(phi)+(2)*cos(phi)];

  if isempty(handle),
    handle = fill(X,Y,'m', 'EraseMode', mode);
    %handle = plot(X,Y,'m', 'EraseMode', mode);
  else
    set(handle,'XData',X,'YData',Y);
    
  end
end
