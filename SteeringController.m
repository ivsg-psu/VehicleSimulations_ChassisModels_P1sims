% SteeringController.m

% -----------------------------------------------------------
% controller parameters
% -----------------------------------------------------------

% Feedback gains
Kp = 20000;             % proportional feedback gain
Ki = 0; %5000;				% integral feedback gain
Kd = 800;               % derivative feedback gain

% Use for holding the wheel in one place and not moving (not tested in real world)
% Kp = 80000;             % proportional feedback gain
% Ki = 0.0;				% integral feedback gain
% Kd = 1000;               % derivative feedback gain

% Feedforward gains
% KF = 0;	                % friction feedforward gain
% KB = (param.fl.bw+param.fl.bm+param.fr.bw+param.fr.bm)/2;   % viscous damping feedforward gain
% KJ = (param.fl.Jw+param.fl.Jm+param.fr.Jw+param.fr.Jm)/2;   % inertia feedforward gain
% Ka = 0;                 % aligning torque gain

% Misc.
wc = 10;                % low-pass filter cutoff frequency (Hz)
sr = 7.5;                % steering ratio
ack = 1;                % percentage Ackermann steering
                        %  1 = full Ackermann steering,
                        %  0 = parallel steering,
                        % -1 = reverse Ackermann steering.
hal_filter_num = [1*(2*pi*Ts)];     % HAL heavy filter numerator
hal_filter_den = [1 1*(2*pi*Ts)-1]; % HAL heavy filter denomenator

Ioff_l = -0.0791;       % Identified current offset. (Amps)
Ioff_r =  0.0591;       % Identified current offset. (Amps)

Igain_l = 1/0.6*1/160*1/0.85*7.843;   % Current gain on left controller
Igain_r = 1/0.6*1/160*1/0.85*7.843;   % Current gain on right controller

Imax_l = 20;            % Maximum current command (Amps)
Imax_r = 20;            % Maximum current command (Amps)

steering_limit = 35;    % Maximum effective roadwheel angle. (deg)

% Here's where we create the derivative/low-pass filter
% This is just a single-pole low-pass filter in combination with a derivative.
num=wc*2*pi*[1 -1];
den=[1 wc*2*pi*Ts-1];