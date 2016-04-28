function drawPendulum(u)
% process inputs to function
y        = u(1);
theta    = u(2);
t        = u(3);

% drawing parameters
L = 5;
gap = 0.01;
width = 1.0;
height = 0.3;

% define persistent variables 
persistent base_handle
persistent rod_handle

pause(0.01);

% first time function is called, initialize plot and persistent vars
if t==0,
  figure(1), clf
  track_width=6;
  plot([-track_width,track_width],[0,0],'k'); % plot track
  hold on
  base_handle = drawBase(y,width,height,gap,[],'normal');
  rod_handle  = drawRod(y,theta,L,gap,height,[],'normal');
  axis([-track_width,track_width,-L,2*track_width-L]);

% at every other time step, redraw base and rod
else 
  drawBase(y,width,height,gap,base_handle);
  drawRod(y,theta,L,gap,height,rod_handle);
end
