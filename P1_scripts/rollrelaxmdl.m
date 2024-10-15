function [sys,x0,str,ts] = rollrelaxmdl(t,x,u,flag,Ts,param)
% Generic vehicle model with roll and relaxation length
% Craig Beal, 09/20/05
% Version 1.0, 09/20/05
% Includes roll behavior and relaxation length
% Based on Mathworks's DSFUNC.M example for defining a discrete
% s-function.

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes(Ts);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u,Ts,param);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u,Ts,param);

  %%%%%%%%%%%%%%%%%%%
  % Unhandled flags %
  %%%%%%%%%%%%%%%%%%%
  case { 1, 4, 9 },
    sys = [];

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end
% end csfunc

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(Ts)

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 6;  %sideslip angle, yaw rate, roll angle, roll rate, front tire force, rear tire force
sizes.NumOutputs     = 3;  %sideslip angle, yaw rate, roll angle
sizes.NumInputs      = 6;  %steer_l, steer_r, i_l, i_r, yaw rate, velocity
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0  = zeros(6,1);
str = [];
ts  = [Ts 0];

% end mdlInitializeSizes
%
%=============================================================================
% mdlUpdate
% Return the updates for the discrete states.
%=============================================================================
%
function sys=mdlUpdate(t,x,u,Ts,param)

% break up input vector
V = max([1 u(6)]);  %vehicle velocity
delta = 0.5*(u(1) + u(2));

% Define some constants to speed things up
const_1 = (param.Ix+param.h_roll^2*param.m)/(param.Ix*param.m);
const_2 = param.h_roll/param.Ix;
Cf = param.fl.C+param.fr.C;
Cr = param.rl.C+param.rr.C;
sigmaf = 0.5*(param.fl.sigma + param.fr.sigma);
sigmar = 0.5*(param.rl.sigma + param.rr.sigma);
g = 9.81;

% build the matrices and go!
A = [0 -1 (param.m*g*param.h_roll-param.k_roll)*const_2/V -param.b_roll*const_2/V const_1/V const_1/V;
     0 0 0 0 param.a/param.Iz -param.b/param.Iz;
     0 0 0 1 0 0;
     0 0 (param.m*g*param.h_roll-param.k_roll)/param.Ix -param.b_roll/param.Ix const_2 const_2;
    -V*Cf/sigmaf -param.a*Cf/sigmaf 0 0 -V/sigmaf 0;
    -V*Cr/sigmar param.b*Cr/sigmar 0 0 0        -V/sigmar];

B = [0;
     0;
     0;
     0;
     V*Cf/sigmaf;
     0];
          
derivs = A*x + B*delta;

sys = x + Ts*derivs;

% end mdlUpdate
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%

function sys=mdlOutputs(t,x,u,Ts,param)

C = [1 0 0 0 0 0;
     0 1 0 0 0 0;
     0 0 1 0 0 0];
 
sys = C*x;

% end mdlOutputs