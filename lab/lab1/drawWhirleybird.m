function drawWhirleybird(uu)

    % process inputs to function
    phi      = uu(1);       % roll angle         
    theta    = uu(2);       % pitch angle     
    psi      = uu(3);       % yaw angle     
    t        = uu(4);

    % define parameters
    
    g = 9.81;
    l1 = 0.85;
    l2 = 0.3048;
    m1 = 0.891;
    m2 = 1;
    d = 0.178;
    h = 0.65;
    r = 0.12;
    jx = 0.0047;
    jy = 0.0014;
    jz = 0.0041;
    km = 0.0546;
    sig_gyro = 8.7266*10^(-5);
    sig_pixel = 0.05;
    
    
    % define persistent variables 
    persistent arm_handle;
    persistent rod_handle;
    persistent roter_handle1;
    persistent roter_handle2;
    
    % first time function is called, initialize plot and persistent vars
    if t<=0.1,
        figure(1), clf
        drawBase(h);
        hold on
        arm_handle = drawArm(l1, l2, phi, theta, psi, [], 'normal');
        rod_handle = drawRod(l1, d, r, phi, theta, psi, [], 'normal');
        roter_handle1 = drawRoter(l1, d, r, phi, theta, psi, [], 'normal');
        roter_handle2 = drawRoter(l1, -d, -r, phi, theta, psi, [], 'normal');
        title('Whirleybird')
        xlabel('East')
        ylabel('North')
        zlabel('-Down')
        view(32,47)  % set the vieew angle for figure
        axis([-2,2,-2,2,-2,2]);
        hold on
        
    % at every other time step, redraw base and rod
    else 
        drawArm(l1, l2, phi, theta, psi, arm_handle, 'normal');
        drawRod(l1, d, r, phi, theta, psi, rod_handle, 'normal');
        drawRoter(l1, d, r, phi, theta, psi, roter_handle1, 'normal');
        drawRoter(l1, -d, -r, phi, theta, psi, roter_handle2, 'normal');
    end
end
 

% %%%%%%%%%%%%%%%%%%%%%%%
function XYZ=rotate(XYZ,phi,theta,psi);
  % define rotation matrix
  R_roll = [...
          1, 0, 0;...
          0, cos(phi), -sin(phi);...
          0, sin(phi), cos(phi)];
  R_pitch = [...
          cos(theta), 0, sin(theta);...
          0, 1, 0;...
          -sin(theta), 0, cos(theta)];
  R_yaw = [...
          cos(psi), -sin(psi), 0;...
          sin(psi), cos(psi), 0;...
          0, 0, 1];
  R = R_yaw*R_pitch*R_roll;

  % rotate vertices
  XYZ = R*XYZ;
  
end
% end rotateVert

function drawBase(h);
    
    X = [0, 0];
    Y = [0, 0];
    Z = [0, -h];
    
    plot3(X, Y, Z);

end


function handle = drawArm(l1, l2, phi, theta, psi,handle, mode);

    NED = [...
           -l2, l1;...
           0, 0;...
           0, 0;...
           ];
    NED = rotate(NED, phi, theta, psi);
    
       R = [...
       0, 1, 0;...
       1, 0, 0;...
       0, 0, -1;...
       ];
   XYZ = R*NED;

   if isempty(handle),
    handle = plot3(XYZ(1,:),XYZ(2,:),XYZ(3,:),'EraseMode', mode);
     %handle = plot(X,Y,'m', 'EraseMode', mode);
   else
    set(handle,'XData',XYZ(1,:),'YData',XYZ(2,:),'ZData',XYZ(3,:));
    drawnow
   end

end

function handle = drawRod(l1, d, r, phi, theta, psi, handle, mode);

    NED = [...
           l1, l1;...
           -(d-r), (d-r);...
           0, 0;...
           ];
    
    NED = rotate(NED, phi, theta, psi);
    
       R = [...
       0, 1, 0;...
       1, 0, 0;...
       0, 0, -1;...
       ];
   XYZ = R*NED;

   if isempty(handle),
    handle = plot3(XYZ(1,:),XYZ(2,:),XYZ(3,:),'EraseMode', mode);
     %handle = plot(X,Y,'m', 'EraseMode', mode);
   else
    set(handle,'XData',XYZ(1,:),'YData',XYZ(2,:),'ZData',XYZ(3,:));
     drawnow
   end

end

function handle = drawRoter(l1, d, r, phi, theta, psi, handle, mode);

    NED = [...
           l1-r, l1-r, l1+r, l1+r;...
           d-r, d+r, d+r, d-r;...
           0, 0, 0, 0;...
           ];
    
    NED = rotate(NED, phi, theta, psi);
    
       R = [...
       0, 1, 0;...
       1, 0, 0;...
       0, 0, -1;...
       ];
   XYZ = R*NED;

   if isempty(handle),
    handle = fill3(XYZ(1,:),XYZ(2,:),XYZ(3,:), 'g');
     %handle = plot(X,Y,'m', 'EraseMode', mode);
   else
    set(handle,'XData',XYZ(1,:),'YData',XYZ(2,:),'ZData',XYZ(3,:));
     drawnow
   end

end
