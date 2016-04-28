function plotWhirlybird(uu)

    % process inputs to function
    phi       = uu(1);        % roll angle of whirlybird     
    phidot    = uu(2);        % roll rate
    theta     = uu(3);        % pitch angle or arm
    thetadot  = uu(4);        % pitch rate
    psi       = uu(5);        % yaw angle of arm
    psidot    = uu(6);        % yaw rate
    tpsi      = uu(7)*pi/180; % yaw angle of target   
    t         = uu(8);        % simulation time

    % define persistent variables 
    persistent fig_whirlybird;  % figure handle for whirlybird
    persistent fig_rod;        % figure handle for rod
    persistent fig_target;     % figure handle for target

    target_size = .05; % size of the target

    % first time function is called, initialize plot and persistent vars
    if t<0.1,
        figure(1), clf
        drawBase;
        fig_whirlybird = drawWhirlybird(phi,theta,psi, [], 'normal');
        fig_rod        = drawRod(theta,psi,[],'normal');
        hold on
        fig_target     = drawTarget(tpsi,target_size,[],'normal');
        title('Whirlybird and target')
        xlabel('East')
        ylabel('North')
        zlabel('-Down')
        view(32,47)  % set the vieew angle for figure
        axis([-2,2,-2,2,-.1,  2]);
        grid on
        
        
    % at every other time step, redraw quadrotor and target
    else 
        drawWhirlybird(phi,theta,psi,fig_whirlybird);
        drawRod(theta,psi,fig_rod);
        drawTarget(tpsi,target_size,fig_target);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define the quadrotor parameters
function P = defineParameters

    % base parameters
    P.basewidth = 1;
    P.baseheight = 1;
    
    % rod parameters
    P.rodlength = 3;
    P.rodwidth  = 0.05;

    % whirlybird parameters
    P.w = 0.25;   % width of the center pod
    P.l = .4;   % length of connecting rods
    P.lw = 0.05; % width of rod
    P.r = 0.3;   % radius of the rotor
    P.N = 10;     % number of points defining rotor
    P.cam_fov = 30*pi/180; % field of view of the camera

    % define colors for faces
    P.red    = [1, 0, 0];
    P.green  = [0, 1, 0];
    P.blue   = [0, 0, 1];
    P.rodcolor = [.1, 0, .5];
    P.yellow = [1,1,0];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handle = drawBase;
  % draw whirlybird base
  
  P = defineParameters;
  
  Vertices = [...
      P.basewidth/2, P.basewidth/2, 0;...
      P.basewidth/2, -P.basewidth/2, 0;...
      -P.basewidth/2, P.basewidth/2, 0;...
      -P.basewidth/2, -P.basewidth/2, 0;...
      0, 0, -P.baseheight;...
      ];
  Faces = [...
      1, 3, 5;...
      1, 2, 5;...
      2, 4, 5;...
      4, 3, 5;...
      ];
  
  patchcolors = [...
      P.blue;...
      P.green;... % front
      P.blue;...
      P.blue;...
      ];
  
    % transform vertices from NED to XYZ
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  Vertices = Vertices*R;

  handle = patch('Vertices', Vertices, 'Faces', Faces,...
                 'FaceVertexCData',patchcolors,...
                 'FaceColor','flat');
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handle = drawRod(theta, psi, handle, mode);
  % plot whirlybird rod

  P = defineParameters;
  
  Vertices = [...
      P.rodlength/2, P.rodwidth/2,  P.rodwidth/2;...
      P.rodlength/2, P.rodwidth/2, -P.rodwidth/2;...
      P.rodlength/2, -P.rodwidth/2, P.rodwidth/2;...
      P.rodlength/2, -P.rodwidth/2,-P.rodwidth/2;...
      -P.rodlength/4, P.rodwidth/2,  P.rodwidth/2;...
      -P.rodlength/4, P.rodwidth/2, -P.rodwidth/2;...
      -P.rodlength/4, -P.rodwidth/2, P.rodwidth/2;...
      -P.rodlength/4, -P.rodwidth/2,-P.rodwidth/2;...
      ];
  Faces = [...
      1, 2, 4, 3;...
      5, 6, 8, 7;...
      1, 2, 6, 5;...
      2, 4, 8, 6;...
      3, 4, 8, 7;...
      1, 5, 7, 3;...
      ];
  
  patchcolors = [...
      P.rodcolor;...
      P.rodcolor;...
      P.rodcolor;...
      P.rodcolor;...
      P.rodcolor;...
      P.rodcolor;...
      P.rodcolor;...
      P.rodcolor;...
      ];
  
  Vertices = rotateVert(Vertices, 0, theta, 0);
  Vertices = translateVert(Vertices, [0; 0; -P.baseheight]);
  Vertices = rotateVert(Vertices, 0, 0, psi);
  
  % transform vertices from NED to XYZ
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  Vertices = Vertices*R;

  if isempty(handle),
  handle = patch('Vertices', Vertices, 'Faces', Faces,...
                 'FaceVertexCData',patchcolors,...
                 'FaceColor','flat',...
                 'EraseMode', mode);
  else
    set(handle,'Vertices',Vertices,'Faces',Faces);
    drawnow
  end
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handle = drawWhirlybird(phi, theta, psi, handle, mode);
  % plot of whirlybird

  P = defineParameters;

  [Vert_whirly, Face_whirly, colors_whirly] = whirlybirdVertFace(P);
  Vert_whirly = rotateVert(Vert_whirly, phi, 0, 0);
  Vert_whirly = translateVert(Vert_whirly, [P.rodlength/2; 0; 0]);
  Vert_whirly = rotateVert(Vert_whirly, 0, theta, 0);
  Vert_whirly = translateVert(Vert_whirly, [0; 0; -P.baseheight]);
  Vert_whirly = rotateVert(Vert_whirly, 0, 0, psi);
  % transform vertices from NED to XYZ
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  Vert_whirly = Vert_whirly*R;


  %----field-of-view vertices------
  [Vert_fov, Face_fov, colors_fov] = fovVertFace(phi,theta,psi,P);
  % transform vertices from NED to XYZ
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  Vert_fov = Vert_fov*R;

  % collect all vertices and faces
  V = [...
      Vert_whirly;...
      Vert_fov;...
      ];
  F = [...
      Face_whirly;...
      size(Vert_whirly,1) + Face_fov;...
      ]; 
  patchcolors = [...
      colors_whirly;...
      colors_fov;...
      ];

  if isempty(handle),
  handle = patch('Vertices', V, 'Faces', F,...
                 'FaceVertexCData',patchcolors,...
                 'FaceColor','flat',...
                 'EraseMode', mode);
  else
    set(handle,'Vertices',V,'Faces',F);
    drawnow
  end
end
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Vertices, Faces, colors] = whirlybirdVertFace(P)
% Vertices = [x,y,z] position of each vertex
% Faces = defines how the vertices are connnected for form faces.  Each set
% of our vertices defines one face.


  %--------- vertices and faces for center pod ------------
  % vertices of the center pod
  Vert_center = [...
    P.w/2, P.w/2, P.w/2;...
    P.w/2, P.w/2, -P.w/2;...
    P.w/2, -P.w/2, -P.w/2;...
    P.w/2, -P.w/2, P.w/2;...
    -P.w/2, P.w/2, P.w/2;...
    -P.w/2, P.w/2, -P.w/2;...
    -P.w/2, -P.w/2, -P.w/2;...
    -P.w/2, -P.w/2, P.w/2;...
    ];
  % define faces of center pod
  Face_center = [...
        1, 2, 3, 4;... % front
        5, 6, 7, 8;... % back
        1, 4, 8, 5;... % top
        8, 4, 3, 7;... % right 
        1, 2, 6, 5;... % left
        2, 3, 7, 6;... % bottom
        ];
    
  %--------- vertices and faces for connecting rods ------------    
  % vertices for right rod
  Vert_rod_front = [...
    P.w/2, P.lw/2, 0;...
    P.w/2, -P.lw/2, 0;...
    P.w/2, 0, P.lw/2;...
    P.w/2, 0, -P.lw/2;...
    P.l+P.w/2, P.lw/2, 0;...
    P.l+P.w/2, -P.lw/2, 0;...
    P.l+P.w/2, 0, P.lw/2;...
    P.l+P.w/2, 0, -P.lw/2;...
    ];
  Vert_rod_right = Vert_rod_front*[0,1,0;1,0,0;0,0,1];
  Face_rod_right = 8 + [...
        1, 2, 6, 5;... % x-y face
        3, 4, 8, 7;... % x-z face
    ];
  % vertices for left rod 
 Vert_rod_left = Vert_rod_front*[0,-1,0;-1,0,0;0,0,1];
 Face_rod_left = 16 + [...
        1, 2, 6, 5;... 
        3, 4, 8, 7;... 
    ];

  %--------- vertices and faces for rotors ------------  
  Vert_rotor = [];
  for i=1:P.N,
    Vert_rotor = [Vert_rotor; P.r*cos(2*pi*i/P.N), P.r*sin(2*pi*i/P.N), 0];
  end
  for i=1:P.N,
    Vert_rotor = [Vert_rotor; P.r/10*cos(2*pi*i/P.N), P.r/10*sin(2*pi*i/P.N), 0];
  end
  Face_rotor = [];
  for i=1:P.N-1,
    Face_rotor = [Face_rotor; i, i+1, P.N+i+1, P.N+i];
  end
  Face_rotor = [Face_rotor; P.N, 1, P.N+1, 2*P.N];

  % right rotor
  Vert_rotor_right = Vert_rotor + repmat([0, P.w/2+P.l+P.r, 0],2*P.N,1);
  Face_rotor_right = 24 + Face_rotor;
  % left rotor
  Vert_rotor_left = Vert_rotor + repmat([0, -(P.w/2+P.l+P.r), 0],2*P.N,1);
  Face_rotor_left = 24 + 2*P.N + Face_rotor;

  % collect all of the vertices for the quadrotor into one matrix
  Vertices = [...
    Vert_center; Vert_rod_right; Vert_rod_left; Vert_rotor_right; Vert_rotor_left...
    ];
  % collect all of the faces for the quadrotor into one matrix 
  Faces = [...
    Face_center; Face_rod_right; Face_rod_left; Face_rotor_right; Face_rotor_left...
    ];

  
  colors = [...
    P.blue;... % fuselage front
    P.blue;... % back
    P.blue;... % bottom
    P.blue;... % left
    P.blue;... % right
    P.yellow;... % top
    P.green;... % rod right
    P.green;... %
    P.green;... % rod left
    P.green;... %
    ];
  for i=1:P.N,
    colors = [colors; P.green];  % right rotor
  end
  for i=1:P.N,
    colors = [colors; P.blue];  % left rotor
  end

end % whirlybirdVertFace


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Vert_fov, Face_fov, colors_fov] = fovVertFace(phi,theta,psi,P)

  %-------vertices and faces for camera field-of-view --------------
  % vertices 
  Vert_fov = [...
    0, 0, -P.baseheight-P.rodlength/2*sin(theta);...
    tan(theta+P.cam_fov/2), tan(-phi+P.cam_fov/2), 0;...
    tan(theta-P.cam_fov/2), tan(-phi+P.cam_fov/2), 0;...
    tan(theta+P.cam_fov/2), -tan(phi+P.cam_fov/2), 0;...
    tan(theta-P.cam_fov/2), -tan(phi+P.cam_fov/2), 0;...
    ];
  Vert_fov = translateVert(Vert_fov,[P.rodlength/2*cos(theta); 0; 0]);
  Vert_fov = rotateVert(Vert_fov,0,0,psi);
  Face_fov = [...
        1, 1, 2, 2;... % x-y face
        1, 1, 3, 3;... % x-y face
        1, 1, 4, 4;... % x-y face
        1, 1, 5, 5;... % x-y face
        2, 3, 5, 4;... % x-y face
    ];

  colors_fov = [P.blue; P.blue; P.blue; P.blue; P.yellow];

end % fovVertFace


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handle = drawTarget(tpsi,size,handle,mode)

  P = defineParameters;

  % get the target data points
  [X,Y,Z] = targetXYZ;
  
  % scale by size
  X = X*size;
  Y = Y*size;
  Z = Z*size;
  
  [X,Y,Z] = rotateXYZ(X,Y,Z,0,0,-pi/2);
  [X,Y,Z] = translateXYZ(X,Y,Z,[P.rodlength/2, 0, 0]);
  [X,Y,Z] = rotateXYZ(X,Y,Z,0,0,-tpsi);
  
  if isempty(handle),
    handle = patch(Y, X, -Z, 'r', 'EraseMode', mode);
  else
    set(handle,'XData',Y,'YData',X,'ZData',-Z);
    drawnow
  end

end % drawTarget  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X,Y,Z] = targetXYZ
  
  z = -0.01;
  pts = [...
       2,  0, z;...
       0,  2, z;...
       0,  1, z;...
      -2,  1, z;...
      -2, -1, z;...
       0, -1, z;...
       0, -2, z;...
       2,  0, z;...
      ];
  X = pts(:,1);
  Y = pts(:,2);
  Z = pts(:,3);

end % targetXYZ

%%%%%%%%%%%%%%%%%%%%%%%
function Vert=rotateVert(Vert,phi,theta,psi);
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
  R = R_roll*R_pitch*R_yaw;

  % rotate vertices
  Vert = (R*Vert')';
  
end % rotateVert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by column vector T
function Vert = translateVert(Vert, T)

  Vert = Vert + repmat(T', size(Vert,1),1);

end % translateVert

%%%%%%%%%%%%%%%%%%%%%%%
function [X,Y,Z]=rotateXYZ(X,Y,Z,phi,theta,psi);
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
  R = R_roll*R_pitch*R_yaw;

  % rotate vertices
  pts = [X, Y, Z]*R;
  X = pts(:,1);
  Y = pts(:,2);
  Z = pts(:,3);
  
end % rotateVert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by column vector T
function [X,Y,Z] = translateXYZ(X,Y,Z,T)

  X = X + T(1)*ones(size(X));
  Y = Y + T(2)*ones(size(Y));
  Z = Z + T(3)*ones(size(Z));

end % translateXYZ

