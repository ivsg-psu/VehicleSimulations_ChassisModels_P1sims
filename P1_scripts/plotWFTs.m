% Wheel Force Transducer plots only

%% Wheel Force Transducer (Left)
% This addresses the left WFT figure, if it exists. If not, it
% creates a new one.
if ~exist('handleWFTLeftFig','var')
    handleWFTLeftFig = figure('Name','Wheel Force Transducer (Left)','NumberTitle','off');
else
    figure(handleWFTLeftFig);
end

% Left Front Forces combined
subplot(3,2,1)
plot(rt_tout,WFT.left.Fx,rt_tout,WFT.left.Fy,rt_tout,WFT.left.Fz)
title('LF Tire Forces')
xlabel('Time (s)')
ylabel('Force (N)')
legend('X-Direction','Y-Direction','Z-Direction')

% Left Front Moments combined
subplot(3,2,2)
plot(rt_tout,WFT.left.Mx,rt_tout,WFT.left.My,rt_tout,WFT.left.Mz)
title('LF Tire Moments')
xlabel('Time (s)')
ylabel('Moment (Nm)')
legend('X-Direction','Y-Direction','Z-Direction')

% Left Front Velocity
subplot(3,2,3)
plot(rt_tout,WFT.left.Vel)
title('LF Tire Velocity')
xlabel('Time (s)')
ylabel('Velocity (rpm)')

% Left Front Position
subplot(3,2,4)
plot(rt_tout,WFT.left.Pos)
title('LF Tire Position')
xlabel('Time (s)')
ylabel('Position (deg)')

% Left Front Acceleration
subplot(3,2,5)
plot(rt_tout,WFT.left.Ax,rt_tout,WFT.left.Az)
title('LF Tire Acceleration')
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('X-direction','Z-Direction')

%% Wheel Force Transducer (Right)

% This addresses the right WFT figure, if it exists. If not, it
% creates a new one.
if ~exist('handleWFTRightFig','var')
    handleWFTRightFig = figure('Name','Wheel Force Transducer (Right)','NumberTitle','off');
else
    figure(handleWFTRightFig);
end

% Right Front Forces combined
subplot(3,2,1)
plot(rt_tout,WFT.right.Fx,rt_tout,WFT.right.Fy,rt_tout,WFT.right.Fz)
title('RF Tire Forces')
xlabel('Time (s)')
ylabel('Force (N)')
legend('X-Direction','Y-Direction','Z-Direction')

% Right Front Moments combined
subplot(3,2,2)
plot(rt_tout,WFT.right.Mx,rt_tout,WFT.right.My,rt_tout,WFT.right.Mz)
title('RF Tire Moments')
xlabel('Time (s)')
ylabel('Moment (Nm)')
legend('X-Direction','Y-Direction','Z-Direction')

% Right Front Velocity
subplot(3,2,3)
plot(rt_tout,WFT.right.Vel)
title('RF Tire Velocity')
xlabel('Time (s)')
ylabel('Velocity (rpm)')

% Right Front Position
subplot(3,2,4)
plot(rt_tout,WFT.right.Pos)
title('RF Tire Position')
xlabel('Time (s)')
ylabel('Position (deg)')

% Right Front Acceleration
subplot(3,2,5)
plot(rt_tout,WFT.right.Ax,rt_tout,WFT.right.Az)
title('RF Tire Acceleration')
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('X-direction','Z-Direction')