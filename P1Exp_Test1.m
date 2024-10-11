
%Natalie Rudisill
%8/19/24 
%The purpose of this script is to run an experimental simulation using the
%previously built vehicle model to simulate dynamics of P1. 

close all
clc


%Run this inital script to define parameters?
if 1~=exist('p1params','var')
    p1_params_new  % Loads the parameters if the variable is not detected in the workspace
end

%Define inputs to the vehicle model 
%Define steering input
Period = 10;

%Define time for how long to run simulation 
TotalTime = 4*Period;

%future vector definition for steering input change


%Run the simulation in Simulink
flag_use2023a = 1; % A dumb flag variable so that Sean's weak computer can run the old-man version of MATLAB
if flag_use2023a
    sim('p1_digital_twin_R2023a',TotalTime);
else
    sim('p1_digital_twin', TotalTime); %#ok<UNRCH>
end

%%

parseP1data
plotAllData

%%

%GPS to position conversions
LatPos=(rt_GPS(:,5)-40.9546).*111139; %Convert lat GPS signal to m
LongPos=(rt_GPS(:,6)+76.8820).*111139; %Convert long GPS signal to m

%Create array for longitudinal values
LongVelArray=zeros(40001,1);
LongVelArray(:)=LongVel;
LongAccArray=zeros(40001,1);
LongAccArray(:)=LongAcc;
FxTireArray=zeros(40001,1);
FxTireArray(:)=FxTire;

%Create sideslip values
Beta=atan2(LatVel,LongVelArray);
Beta1=atan2(LongVelArray,LatVel);

%Plot Figures
figure(1) 
geoplot(rt_GPS(:,5),rt_GPS(:,6)) %plot with GPS coordinates

figure(2)
plot(LongPos,LatPos),xlabel('X Position (m)'), ylabel('Y Position (m)'), title('Vehicle Trajectory'), axis equal %x-y plot of vehicle trajectory (meters)

figure(3)
plot(tout, LatVel), xlabel('Time (S)'), ylabel('Lateral Velocity (m/s)'), title('Lateral Velocity') %Lateral velocity vs time

figure(4)
plot(tout, LongVelArray,'k.-'), xlabel('Time (S)'), ylabel('Longitudinal Velocity (m/s)'),title('Longitudinal Velocity') %Longitudinal velocity vs time 

figure(5)
plot(tout, yawrate),xlabel('Time (S)'),ylabel('Yaw Rate (rad/s)'), title('Yaw Rate') %Yaw rate vs time

figure(6)
plot(tout,Beta), xlabel('Time (S)'), ylabel('Vehicle Side Slip (rad)'), title('Vehicle Body Slip') %Sideslip vs time

%Need to separate these lines with a legend
figure(7)
plot(tout, FyTire), xlabel('Time (S)'), ylabel('Lateral Tire Force (N)'),title('Lateral Tire Force') %Tire force vs time

figure(8)
plot(tout, FxTireArray), xlabel('Time (S)'), ylabel('Tire Force (N)'),title('Longitudinal Tire Force') %no data

figure(9)
plot(tout, SlipAngle), xlabel('Time (S)'), ylabel('Slip Angles (rad)'),title('Individual Tire Slip Angles')

figure(10)
plot(SlipAngle, FyTire), xlabel('Tire Slip Angle (rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Force vs Slip Angle'),set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin') %Tire force vs tire slip

figure(11)
plot(Beta,yawrate), xlabel('Side Slip (rad)'), ylabel('Yaw Rate (rad/sec)') %Yaw rate

figure(12)
plot(LatAcc,LongAccArray), xlabel('Lateral Acceleration (m/s^2)'), ylabel('Longitudinal Acceleration (m/s^2)'),title('Longitudianl vs Lateral Acceleration') %Ax vs Ay 

figure(13) 
plot(tout,SteerAngle), xlabel('Time (S)'), ylabel('Steering Angle (Rad)'), title('Steering Angle') %Steering angle requested vs time

figure(14)
plot(tout, DriveTorque), xlabel('Time (S)'), ylabel('Throttle'), title('Throttle') %Throttle vs time

