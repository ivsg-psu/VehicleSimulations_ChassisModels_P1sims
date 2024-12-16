
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

%Define time for how long to run simulation 
TotalTime = 80;

% Stops the code here
% return;

%Run the simulation in Simulink
flag_use2023a = 0; % A dumb flag variable so that Sean's weak computer can run the old-man version of MATLAB
if flag_use2023a
    sim('p1_digital_twin_R2023a',TotalTime);
else
    sim('p1_digital_twin', TotalTime); %#ok<UNRCH>
end

%%

%parseP1data
%plotAllData

%%

%GPS to position conversions
LatPos=(rt_GPS(:,5)-40.9546).*111139; %Convert lat GPS signal to m
LongPos=(rt_GPS(:,6)+76.8820).*111139; %Convert long GPS signal to m


%% fcn_plotRoad_plotLL
% geoplots Latitude and Longitude data with user-defined formatting strings

fig_num = 1;
figure(fig_num);
clf;

% NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
% LLdata = [data3(:,2), data3(:,1), data3(:,3)];
LLdata = [rt_GPS(:,5),rt_GPS(:,6), rt_GPS(:,9)];

% Test the function
clear plotFormat
plotFormat.Color = [1 1 0];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));

title(sprintf('Vehicle Path',fig_num), 'Interpreter','none');

% Was a figure created?
assert(all(ishandle(fig_num)));

% Is a plot handle returned?
assert(ishandle(h_geoplot))



%I dont like how convoluted this is, so this is temporary. I dont think I
%need the zeros nonsense. Plus, this is going to have to be manually
%updated if you change run time. NO bueno. 
%Convert steer angles from rad to deg
SteerAngleDeg=SteerAngle.*180/pi;
%Calculate average steer angle
SteerAdd=SteerAngleDeg(:,1)+SteerAngleDeg(:,2); % (Row, Column) 
AvgSteerAngle=SteerAdd./2;
SteerAngleVecL=zeros((TotalTime*1000)+1, 1);
SteerAngleVecR=zeros((TotalTime*1000)+1, 1);
SteerAngleVecAvg=zeros((TotalTime*1000)+1,1);
SteerAngleVecL(:,1)=SteerAngleDeg(1,1);
SteerAngleVecR(:,1)=SteerAngleDeg(1,2);
SteerAngleVecAvg(:,1)=AvgSteerAngle(1,1);
%Plot road wheel steer angles
figure(2)
plot(tout, SteerAngleVecL, tout, SteerAngleVecR, tout, SteerAngleVecAvg), xlabel('Time (s)'), ylabel('Steer Angle (Deg)'), title('Road Wheel Steer Angle'), legend('Left Wheel', 'Right Wheel', 'Average'), axis ([15 TotalTime 8.5 10]);

%Torque request 
figure(3)
plot(tout(15001:(TotalTime*1000)+1,1), DriveTorque(15001:(TotalTime*1000)+1,1:2)), xlabel('Time (s)'), ylabel('Torque (Nm)'), title('Torque Request Profile'), legend('Left Rear Wheel', 'Right Rear Wheel'), axis ([15 TotalTime 0 400]);

%Longitudinal Velocity
figure(4)
plot(tout(15001:(TotalTime*1000)+1,1), vx(15001:(TotalTime*1000)+1,1)), xlabel('Time (s)'), ylabel('Longitudinal Velocity (m/s)'),title('Longitudinal Velocity'), axis ([15 TotalTime 11.09 11.12]); %Longitudinal velocity vs time [11.09 11.12]

%Lateral Velocity
figure(5)
plot(tout(15001:(TotalTime*1000)+1,1), vy(15001:(TotalTime*1000)+1,1)), xlabel('Time (s)'), ylabel('Lateral Velocity (m/s)'), title('Lateral Velocity'), axis ([15 TotalTime -0.3 0]); %Lateral velocity vs time

%Yaw Rate
figure(6)
plot(tout(15001:(TotalTime*1000)+1,1), r(15001:(TotalTime*1000)+1,1)),xlabel('Time (s)'),ylabel('Yaw Rate (rad/s)'), title('Yaw Rate'), axis ([15 TotalTime 0.5 0.65]); %Yaw rate vs time

%Lateral Tire Forces
figure(7)
plot(tout(15001:(TotalTime*1000)+1,1), FyTire(15001:(TotalTime*1000)+1,1:4)), xlabel('Time (s)'), ylabel('Lateral Tire Force (N)'),title('Lateral Tire Force'),legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'), axis ([15 TotalTime 2000 4000]);

%Longitudinal Tire Forces
figure(8)
plot(tout(15001:(TotalTime*1000)+1,1), FxTire(15001:(TotalTime*1000)+1,1:4)), xlabel('Time (s)'), ylabel('Tire Force (N)'),title('Longitudinal Tire Force'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'), axis ([15 TotalTime -200 1000]); 

%Vehicle Side Slip calcs
BetaRad=atan(vy./vx);
BetaDeg=BetaRad.*180/pi;
%Vehicle Side Slip plot
figure(9)
plot(tout(15001:(TotalTime*1000)+1,1), BetaDeg(15001:(TotalTime*1000)+1,1)), xlabel('Time (s)'), ylabel('Side Slip (Degrees)'),title('Vehicle Side Slip'), axis ([15 TotalTime -1.5 0]);

%Convert alpha to deg
AlphaDeg=alpha.*180/pi;
%Tire Slip Angle
figure(10)
plot(tout(15001:(TotalTime*1000)+1,1), AlphaDeg(15001:(TotalTime*1000)+1,1:4)), xlabel('Time (s)'), ylabel('Tire Slip Angle (Degrees)'), title('Tire Slip Anlges'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'), axis ([15 TotalTime -7 -3]);

%Tire Forces vs Tire Slip Angles
figure(11)
plot(AlphaDeg(15001:(TotalTime*1000)+1,4), FyTire(15001:(TotalTime*1000)+1,1:4)), xlabel('Tire Slip Angle (Degrees)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel');

%Yaw Rate vs Vehicle Side Slip
figure (12)
plot(BetaDeg(15001:(TotalTime*1000)+1,1), r(15001:(TotalTime*1000)+1,1)), xlabel('Vehicle Side Slip Angle (deg)'), ylabel('Yaw Rate (rad/s)'), title('Yaw Rate vs Side Slip Angle');

%Acceleration Plots
figure(13)
plot(ay(15001:(TotalTime*1000)+1,1), ax(15001:(TotalTime*1000)+1,1)), xlabel('Lateral Acceleration (m/s^2)'), ylabel('Longitudinal Acceleration (m/s^2)'), title('Longitudinal vs Lateral Acceleration');
figure(14)
plot(tout(15001:(TotalTime*1000)+1,1), ax(15001:(TotalTime*1000)+1,1)),xlabel('Time (s)'), ylabel('Longitudinal Acceleration (m/s^2)'), title('Longitudinal Acceleration'), axis ([15 TotalTime -0.2 0.4]);
figure(15)
plot(tout(15001:(TotalTime*1000)+1,1), ay(15001:(TotalTime*1000)+1,1)),xlabel('Time (s)'), ylabel('Lateral Acceleration (m/s^2)'), title('Lateral Acceleration'), axis ([15 TotalTime 6 6.6]);
