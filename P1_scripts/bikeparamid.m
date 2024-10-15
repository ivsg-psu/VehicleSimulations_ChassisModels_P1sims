function [Cf_est,Cr_est,Iz_est] = bikeparamid(t_start,t_end,Cf_0,Cr_0,Iz_0);

    % NLTLS formulation for Bicycle Model using Euler Integration
    % Version 1.1 by Shad Laws, 11/28/04
    % Version 2.1 by Shad Laws, 8/26/05.  Now it's a function.

    % Define some process parameters
    M = 10; %number of iterations
    alpha = 0.8; %update factor... between 0 and 1

    % See if postprocess was run.  If not, run it.
    if evalin('base','~(exist(''Steering'')&exist(''SSest''))');
        evalin('base','postprocess');
    elseif evalin('base','size(t,1)~=size(SSest,1)');
        evalin('base','postprocess');
    end;
   
    t = evalin('base','t');
    PostProc = evalin('base','PostProc');
    SSest = evalin('base','SSest');
    Ts = round((t(2)-t(1))*10000)/10000;
    
    % Get some other parameters
    p1_params;
    a = param.a;
    b = param.b;
    m = param.m;
    clear Cf Cr Iz;
    
    % Figure out time (and why it keeps slippin' into the future)
    T = (t_start/Ts):(t_end/Ts-1);  % "list" of timesteps we can use
    N = length(T);

    % Reconfigure the raw data 
    Vy_k_hat = SSest(T,12);
    Vy_k1_hat = SSest(T+1,12);
    r_k_hat = SSest(T,4);
    r_k1_hat = SSest(T+1,4);

    V_k = SSest(T,9);
    delta_k = PostProc(T,3);

    % Compile the measurements of the 2N "b" outputs and the 2N "a" inputs to the
    % function
    Y_hat = [Vy_k1_hat ; r_k1_hat ; Vy_k_hat ; r_k_hat];

    % Initialize our regressor and plug in the zeroth iteration
    Z = zeros(2*N+3,M+1);
    Z(:,1) = [Vy_k_hat ; r_k_hat ; Cf_0 ; Cr_0 ; Iz_0];

    % Clear some junk to save memory
    clear Cf_0  Cr_0  Iz_0  Vy_k_hat  Vy_k1_hat  r_k_hat  r_k1_hat;
    pack;

    for i=1:M;
        % display the current step
        disp(i);

        % breakup the regressor of our current iteration into its parts
        Vy_k = Z(1:N,i);
        r_k = Z(N+1:2*N,i);
        Cf = Z(2*N+1,i);
        Cr = Z(2*N+2,i);
        Iz = Z(2*N+3,i);

        % find our predictor x(k+1 | k,params) using the current iteration's
        % info, then compile it into Y
        Vy_k1 = Vy_k   +   Ts * (-(Cf+Cr) ./ (m.*V_k)) .* Vy_k   +   Ts * (-(a*Cf-b*Cr) ./ (m.*V_k) - V_k) .* r_k   +   Ts * (Cf / m) .* delta_k;
        r_k1 = r_k   +   Ts * (-(a*Cf-b*Cr) ./ (Iz.*V_k)) .* Vy_k   +   Ts * (-(a^2*Cf+b^2*Cr) ./ (Iz.*V_k)) .* r_k   +   Ts * (a*Cf / Iz) .* delta_k;
        Y = [Vy_k1 ; r_k1 ; Vy_k ; r_k];

        G = Y - Y_hat;

        % find the partial derivitives of stuff at k+1 w.r.t. stuff at k (look
        % at predictor... derivs of that stuff)
        dVy1_dVy = 1  +  Ts * (-(Cf+Cr) ./ (m.*V_k));
        dVy1_dr = Ts * (-(a*Cf-b*Cr) ./ (m.*V_k) - V_k);
        dr1_dVy = Ts * (-(a*Cf-b*Cr) ./ (Iz.*V_k));
        dr1_dr = 1  +  Ts * (-(a^2*Cf+b^2*Cr) ./ (Iz.*V_k));

        dVy1_dCf = Ts * (-1 ./ (m.*V_k)) .* Vy_k   +   Ts * (-a ./ (m.*V_k)) .* r_k   +   Ts * (1 / m) .* delta_k;
        dVy1_dCr = Ts * (-1 ./ (m.*V_k)) .* Vy_k   +   Ts * ( b ./ (m.*V_k)) .* r_k;
        dVy1_dIz = zeros(N,1);
        dr1_dCf = Ts * (-a ./ (Iz.*V_k)) .* Vy_k   +   Ts * (-a^2 ./ (Iz.*V_k)) .* r_k   +   Ts * (a / Iz) .* delta_k;
        dr1_dCr = Ts * ( b ./ (Iz.*V_k)) .* Vy_k   +   Ts * (-b^2 ./ (Iz.*V_k)) .* r_k;
        dr1_dIz = Ts * ((a*Cf-b*Cr) ./ (Iz^2.*V_k)) .* Vy_k   +   Ts * ((a^2*Cf+b^2*Cr) ./ (Iz^2.*V_k)) .* r_k   +   Ts * (-a*Cf / Iz^2) .* delta_k;

        % compile the derivatives into our big gradient matrix... this matrix
        % is 4N x 2N+3 which is gigantic.  It's the sparse version of this:
        % dG_dZ = [  diag(dVy1_dVy)  diag(dVy1_dr)       dVy1_dCf  dVy1_dCr  dVy1_dIz   ;
        %            diag(dr1_dVy)   diag(dr1_dr)        dr1_dCf   dr1_dCr   dr1_dIz    ;
        %                     eye(2*N,2*N)                       zeros(2*N,3)           ];
        dG_dZ = sparse([  sparse(1:N,1:N,dVy1_dVy)  sparse(1:N,1:N,dVy1_dr)       dVy1_dCf  dVy1_dCr  dVy1_dIz   ;
                          sparse(1:N,1:N,dr1_dVy)   sparse(1:N,1:N,dr1_dr)        dr1_dCf   dr1_dCr   dr1_dIz    ;
                                  sparse(1:2*N,1:2*N,ones(2*N,1))                        sparse(2*N,3)           ]);

        % clear up some more memory
        clear dVy1_dVy  dVy1_dr  dVy1_dCf  dVy1_dCr  dVy1_dIz  dr1_dVy  dr1_dr  dr1_dCf  dr1_dCr  dr1_dIz  Vy_k1  r_k1  Y;
        pack;

        % do the big LS problem, iterate, and go!
        Z(:,i+1) = Z(:,i)  -  alpha * dG_dZ\G;
    end;

    Cf_est = Z(2*N+1,M+1);
    Cr_est = Z(2*N+2,M+1);
    Iz_est = Z(2*N+3,M+1);
    Vy_new = Z(1:N,M+1);
    r_new = Z(N+1:2*N,M+1);

    figure;
    subplot(3,1,1);
    plot(0:M,Z(2*N+1,:));
    xlabel('iteration');
    ylabel('Cf');
    subplot(3,1,2);
    plot(0:M,Z(2*N+2,:));
    xlabel('iteration');
    ylabel('Cr');
    subplot(3,1,3);
    plot(0:M,Z(2*N+3,:));
    xlabel('iteration');
    ylabel('Iz');

    disp([Cf Cr Iz]);
    
return;
    