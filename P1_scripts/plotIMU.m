% IMU plots only

%% IMU
% This addresses the IMU data figure, if it exists. If not, it
% creates a new one.
if ~exist('handleIMUFig','var')
    handleIMUFig = figure('Name','IMU','NumberTitle','off');
else
    figure(handleIMUFig)
end

% Acceleration X (Longitudinal)
subplot(3,2,1)
plot(rt_tout,IMU.accelX)
title('Acceleration X (Longitudinal)')
xlabel('Time (s)')
ylabel('m/s')
%ylim([-20 20])
grid on

% Rotation Rate X (Roll)
subplot(3,2,2)
plot(rt_tout,IMU.rotRateX)
title('Rotation Rate X (Roll)')
xlabel('Time (s)')
ylabel('deg/s')
%ylim([-500 500])
grid on

% Acceleration Y (Lateral)
subplot(3,2,3)
plot(rt_tout,IMU.accelY)
title('Acceleration Y (Lateral)')
xlabel('Time (s)')
ylabel('m/s')
%ylim([-20 20])
grid on

% Rotation Rate Y (Pitch)
subplot(3,2,4)
plot(rt_tout,IMU.rotRateY)
title('Rotation Rate Y (Pitch)')
xlabel('Time (s)')
ylabel('deg/s')
%ylim([-500 500])
grid on

% Acceleration Z (Heave)
subplot(3,2,5)
plot(rt_tout,IMU.accelZ)
title('Acceleration Z (Heave)')
xlabel('Time (s)')
ylabel('m/s')
ylim([-12 -7])
grid on

% Rotation Rate Z (Yaw)
subplot(3,2,6)
plot(rt_tout,IMU.rotRateZ)
title('Rotation Rate Z (Yaw)')
xlabel('Time (s)')
ylabel('deg/s')
%ylim([-500 500])
grid on