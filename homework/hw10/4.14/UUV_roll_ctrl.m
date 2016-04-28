function tau=UUV_roll_ctrl(in,P)
    r       = in(1);
    phi_d   = in(2);
    phi     = in(3);
  
    x = [phi; phi_d];
    
    F = [-P.b/P.J -P.m*P.g*P.L/P.J; 1 0];
    G = [1/P.J; 0];
    H = [0 1];  J = 0;
    
    C = [G F*G];
    
    if rank(C) ~= 2
        display('NOT CONTROLLABLE');
    end
    
    P = [-1.2-1.8j -1.2+1.8j];
    K = place(F,G,P)
    
    NN = inv([F G; H J])*[0; 0; 1];
    Nx = NN(1:2);
    Nu = NN(3);
    Nbar = Nu + K*Nx

    tau = -K*x + Nbar*r;
end
