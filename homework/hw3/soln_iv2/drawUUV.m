%=======================================================================
%  File:  drawUUV.m
% 
%  Description:
%     Draws and animates the body of the UUV rotating around the center
%     of mass. 
% 
%  Author:
%    Liang Sun 09/13/2012 
%=======================================================================

function drawUUV(u,MajorAxis,MinorAxis,C_M)

    % process inputs to function
    phi = u(1);
    t   = u(2);
    
    % define persistent variables 
    persistent UUV_handle
    
    % first time function is called, initialize plot and persistent vars
    if t==0,
        figure(1), clf
        UUV_handle = drawUUVbody(phi, MajorAxis, MinorAxis,C_M, [], 'normal');
        hold on
        
        % draw center of mass
        R = 0.3;
        tt = 0:0.1:2*pi;
        X = C_M(1)+R*cos(tt);
        Y = C_M(2)+R*sin(tt);
        fill(X,Y,'k')

        S = MajorAxis+5+max(abs(C_M));
        axis([-S, S, -S, S]);    
        set(gca,'FontSize',12)
        title('Unmanned Underwater Vehicle','FontSize',15)
        xlabel('East, m','FontSize',12)
        ylabel('North, m','FontSize',12)
        
    else 
        drawUUVbody(phi, MajorAxis, MinorAxis,C_M, UUV_handle);
    end
end

%
%=======================================================================
% drawUUVbody
% draw the UUV body
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawUUVbody(phi, MajorAxis, MinorAxis,C_M, handle, mode)  
    xi = 0:2*pi/50:2*pi;

    X = MajorAxis*cos(xi)-C_M(1);
    Y = MinorAxis*sin(xi)-C_M(2);

    XX = X*cos(phi)-Y*sin(phi)+C_M(1);
    YY = X*sin(phi)+Y*cos(phi)+C_M(2);
  
    if isempty(handle),
        handle = fill(XX, YY, 'c', 'EraseMode', mode);
    else
        set(handle,'XData',XX,'YData',YY);
        drawnow
    end
end

  