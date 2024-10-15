% Script for testing simple vehicle dynamics knowledge and ability to apply
% it to car testing for use of comparing measured data to simulated data
close all;
clear;
clc;

load('p1_MPU_2022-07-08_16-02-24.mat')

% Hannah's measured moment of inertia for one side of P1 rear wheel setup
% (integral of r^2 dm across all m)
I = (4215.33515 + 8982.7584)/3417.171903 ; % kg*m^2 ([axel assem + motor side]/(conversion factor))

calcWheelSpeed = zeros(length(rt_tout),1); accel = zeros(length(rt_tout),1);
% Find the measured wheel speed really quick since we have motor rpm and
% know the approximate ratio
wheelLeftSpeed = rt_MotorLeftSpeed*5.6*2*pi()/60; % rad/s (5.6 is conversion factor from motor rpm to wheel rpm)
for k = 1:length(rt_tout)-1
    % Determine the acceleration of the system at the given moment in time
    accel(k+1) = rt_MotorLeftTorque(k+1)/I; % Acceleration units???
    
    % Now use the approximate accleration to determine the calculated speed
    % based on the given time step
    calcWheelSpeed(k+1) = calcWheelSpeed(k) + accel(k+1)*(rt_tout(k+1)-rt_tout(k)); % 
end

% Plots
% Plot torque vs time
figure(1)
plot(rt_tout,rt_MotorLeftTorque,'-r')
xlabel('Time (s)')
ylabel('Left Motor Torque (Nm)')
ylim([-50 50])

% Plot measured and simulated wheel speeds
figure(2)
plot(rt_tout,wheelLeftSpeed,'.b',rt_tout,calcWheelSpeed,'.r')
legend('Measured Speed','Simulated Speed')
xlabel('Time (s)')
ylabel('Left Wheel Speed (rad/s)')
ylim([-0.3 0.3])

