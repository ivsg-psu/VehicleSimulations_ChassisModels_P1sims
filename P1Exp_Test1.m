
%Natalie Rudisill
%8/19/24 
%The purpose of this script is to run an experimental simulation using the
%previously built vehicle model to simulate dynamics of P1. 

close all
clc


%Run this inital script to define parameters
if 1~=exist('p1params','var')
    p1_params_new  % Loads the parameters if the variable is not detected in the workspace
end

%Define time for how long to run simulation 
TotalTime = 250;

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


%% fcn_plotRoad_plotLL
% geoplots Latitude and Longitude data with user-defined formatting strings
% Plot to generate GPS
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

%Set range of plotting indices (time)
plotRange = (TotalTime*1000)+1;
fullPlotRange = 10000:plotRange;
shortPlotRange = 110000:140000; %Right before the query to a while after
longPlotRange = 70000:plotRange; %Right before the circular steady state to full plot
QueryPlotRange = 120000:130000; %Only limited query range
PreQueryPlotRange = 80000:90000; %Prior to the query 
TopQueryPlotRange = 123000:127000; %Only top of the query range
%% 


%I dont like how convoluted this is, so this is temporary. I dont think I
%need the zeros nonsense. Plus, this is going to have to be manually
%updated if you change run time. NO bueno. 
%Convert steer angles from rad to deg
SteerAngleDeg=SteerAngle.*180/pi;
%Calculate average steer angle
% SteerAdd=SteerAngleDeg(:,1)+SteerAngleDeg(:,2); % (Row, Column) 
% AvgSteerAngle=SteerAdd./2;
% SteerAngleVecL=zeros(plotRange, 1);
% SteerAngleVecR=zeros(plotRange, 1);
% SteerAngleVecAvg=zeros(plotRange,1);
% SteerAngleVecL(:,1)=SteerAngleDeg(1,1);
% SteerAngleVecR(:,1)=SteerAngleDeg(1,2);
% SteerAngleVecAvg(:,1)=AvgSteerAngle(1,1);
% %Plot road wheel steer angles
% figure(2)
% plot(tout, SteerAngleVecL, tout, SteerAngleVecR, tout, SteerAngleVecAvg), xlabel('Time (s)'), ylabel('Steer Angle (Deg)'), title('Road Wheel Steer Angle'), legend('Left Wheel', 'Right Wheel', 'Average'), axis ([15 TotalTime 8.5 10]);
%% 

%Money Plots
%Torque Request - shortPlotRange
% figure(3)
% plot(tout(shortPlotRange,1), DriveTorque(shortPlotRange,1:2),'Linewidth',2), xlabel('Time (s)'), ylabel('Torque (Nm)'), title('Torque Request Profile'), legend('Left Rear Wheel', 'Right Rear Wheel'), axis([115 135 -40 60]);

%% Yaw Rate Transfer Function for Steer

% figure(2)
% plot(tout(shortPlotRange,1), r(shortPlotRange,1));
% xlabel('Time (s)'),ylabel('Yaw Rate (rad/s)');
% title('Yaw Rate (Steering)');
% hold on
% plot(tout(shortPlotRange,1), YawRate_TF(shortPlotRange,1));
% legend('P1 Model', 'Steer TF');

%% Yaw Rate Transfer Function for Torque

%figure(3)
% plot(tout(shortPlotRange,1), r(shortPlotRange,1));
% xlabel('Time (s)'),ylabel('Yaw Rate (rad/s)');
% title('Yaw Rate (Torque)');
% hold on 
% plot(tout(shortPlotRange,1), YawRate_TF_Torque(shortPlotRange,1));
% legend('P1 Model','Torque TF');

%% Stacked Plot

%Steering Input, Torque Addition, Lateral Slip, Longitudinal Slip, Yaw Rate
%All against time, x=tout
%Convert HWA to Deg:
HandwheelAngleDeg = HandwheelAngle.*(180/pi);
%Create table 
Time = tout;
HandwheelAngleInput = HandwheelAngleDeg(shortPlotRange,1);
TorqueInput = AdditionalTorqueInput(shortPlotRange);
Alpha = alpha(shortPlotRange,1);
Kappa = kappa(shortPlotRange,1);
%LatForce = FyTire(fullPlotRange,1);
%LongForce = FxTire(fullPlotRange,1);
YawRate = r(shortPlotRange,1);
SteerTorqueCancel = table(HandwheelAngleInput, TorqueInput, Alpha, Kappa, YawRate);
newYlabels = ["Steer Angle (Deg)","Additional Torque Input (Nm)","Lateral Slip", "Longitudinal Slip","Yaw Rate (Rad/s)"];
figure(3)
s=stackedplot(SteerTorqueCancel,"DisplayLabels",newYlabels);
%Any limits needed for the stacked plotting
s.AxesProperties(1).YLimits = [0 15];
s.AxesProperties(2).YLimits = [-5 50];
s.AxesProperties(3).YLimits = [-0.02 -0.001];
s.AxesProperties(4).YLimits = [-0.00205 -0.0018];
s.AxesProperties(5).YLimits = [0 0.15];
% s.AxesProperties(6).YLimits = [-56 -54.5];
% s.AxesProperties(7).YLimits = [0.05 0.12];
% Heavy lineweight
s.LineProperties(1).Marker = '.'; s.LineProperties(2).Marker = '.'; s.LineProperties(3).Marker = '.'; s.LineProperties(4).Marker = '.'; s.LineProperties(5).Marker = '.';







%% Tire Force Plot
%Just in case I need this: Original Tire curve plotting

%Scale range for ramped steer only
% figure(4)
% plot(alpha(fullPlotRange,:),FyTire(fullPlotRange,:),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.2 0.15 -3200 5200]);

%Scale range for ramped torque only
%figure(4)
%plot(alpha(fullPlotRange,:),FyTire(fullPlotRange,:),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.017 0.02 -1200 900]);

%Scale range for Steer and torque inputs, controller on
% figure(4)
% plot(alpha(fullPlotRange,:),FyTire(fullPlotRange,:),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.06 0.08 -2000 1500]);

%Scale range for sloped corner cancel
figure(4)
plot(alpha(shortPlotRange,:),FyTire(shortPlotRange,:),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);













%% Final plots for all "No queries compiled" and "All queries compiled"

% Tire Lateral Force vs Lateral Slip - QueryPlotRange
%figure(5)
%plot(alpha_10(QueryPlotRange,2),FyTire_10(QueryPlotRange,2),'r', 'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('10 Degrees Query', '10 Degrees Pre-Query', '20 Degrees Query', '20 Degrees Pre-Query', '30 Degrees Query', '30 Degrees Pre-Query'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_10(PreQueryPlotRange,2),FyTire_10(PreQueryPlotRange,2),'-r'), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('10 Degrees Query', '10 Degrees Pre-Query', '20 Degrees Query', '20 Degrees Pre-Query', '30 Degrees Query', '30 Degrees Pre-Query'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_20(QueryPlotRange,2),FyTire_20(QueryPlotRange,2),'g','Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('10 Degrees Query', '10 Degrees Pre-Query', '20 Degrees Query', '20 Degrees Pre-Query', '30 Degrees Query', '30 Degrees Pre-Query'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_20(PreQueryPlotRange,2),FyTire_20(PreQueryPlotRange,2),'-g'), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('10 Degrees Query', '10 Degrees Pre-Query', '20 Degrees Query', '20 Degrees Pre-Query', '30 Degrees Query', '30 Degrees Pre-Query'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_30(QueryPlotRange,2),FyTire_30(QueryPlotRange,2),'b','Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('10 Degrees Query', '10 Degrees Pre-Query', '20 Degrees Query', '20 Degrees Pre-Query', '30 Degrees Query', '30 Degrees Pre-Query'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_30(PreQueryPlotRange,2),FyTire_30(PreQueryPlotRange,2),'-b'), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('10 Degrees Query', '10 Degrees Pre-Query', '20 Degrees Query', '20 Degrees Pre-Query', '30 Degrees Query', '30 Degrees Pre-Query'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);

% 
% figure(6)
% plot(alpha_5(QueryPlotRange,2),FyTire_5(QueryPlotRange,2),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('5 Degrees', '10 Degrees', '15 Degrees', '20 Degrees', '25 Degrees', '30 Degrees', '35 Degrees'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_10(QueryPlotRange,2),FyTire_10(QueryPlotRange,2),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('5 Degrees', '10 Degrees', '15 Degrees', '20 Degrees', '25 Degrees', '30 Degrees', '35 Degrees'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_15(QueryPlotRange,2),FyTire_15(QueryPlotRange,2),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('5 Degrees', '10 Degrees', '15 Degrees', '20 Degrees', '25 Degrees', '30 Degrees', '35 Degrees'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_20(QueryPlotRange,2),FyTire_20(QueryPlotRange,2),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('5 Degrees', '10 Degrees', '15 Degrees', '20 Degrees', '25 Degrees', '30 Degrees', '35 Degrees'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_25(QueryPlotRange,2),FyTire_25(QueryPlotRange,2),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('5 Degrees', '10 Degrees', '15 Degrees', '20 Degrees', '25 Degrees', '30 Degrees', '35 Degrees'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_30(QueryPlotRange,2),FyTire_30(QueryPlotRange,2),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('5 Degrees', '10 Degrees', '15 Degrees', '20 Degrees', '25 Degrees', '30 Degrees', '35 Degrees'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% hold on 
% plot(alpha_35(QueryPlotRange,2),FyTire_35(QueryPlotRange,2),'Linewidth',2), xlabel('Tire Slip Angle (Rad)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Rad) - Right Front Tire'), legend('5 Degrees', '10 Degrees', '15 Degrees', '20 Degrees', '25 Degrees', '30 Degrees', '35 Degrees'), set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin'), axis([-0.05 0.02 -500 3000]);
% 
% 





% Max used friction compared to theoretical tire limit - QueryPlotRange
% %Convert alpha to deg
AlphaDeg=alpha.*180/pi;
FrictionLimits = Fz.*0.9;
% figure(13)
% plot(AlphaDeg(TopQueryPlotRange,4), FyTire(TopQueryPlotRange,1:4), AlphaDeg(TopQueryPlotRange,4), FrictionLimits(TopQueryPlotRange,1:4),'Linewidth',2), xlabel('Tire Slip Angle (Degrees)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle, Tire Friction Limit'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel', 'Left Front Friction Limit', 'Right Front Friction Limit', 'Left Rear Friction Limit', 'Right Rear Friction Limit');

%Total Tire Force (Calculation first) - shortPlotRange
TotalForce = sqrt(FxTire.^2 + FyTire.^2);
figure(18)
plot(tout(shortPlotRange,:), TotalForce(shortPlotRange,:),'Linewidth',2), xlabel('Time (s)'), ylabel('Force (N)'), title('Max Force Each Tire'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'), axis([115 135 450 1000]);

%Lateral Acceleration - shortPlotRange
figure(15)
plot(tout(shortPlotRange,1), ay(shortPlotRange,1), 'LineWidth',2),xlabel('Time (s)'), ylabel('Lateral Acceleration (m/s^2)'), title('Lateral Acceleration'), axis([115 135 0.1 0.9]);
%


%This works - I just need to figure out how to correctly incorporate the
%time variable on the x axis
% % figure(31)
% % plot(tout,ControllerOut), title('Controller Output');
% 
% %Longitudinal Velocity
% figure(4)
% plot(tout, vx,'.'), xlabel('Time (s)'), ylabel('Longitudinal Velocity (m/s)'),title('Longitudinal Velocity'), axis ([0 TotalTime 0 15]); %Longitudinal velocity vs time [11.09 11.12]
% 
% % %Lateral Velocity
% % figure(5)
% % plot(tout(shortPlotRange,1), vy(shortPlotRange,1)), xlabel('Time (s)'), ylabel('Lateral Velocity (m/s)'), title('Lateral Velocity'), axis ([15 TotalTime -0.3 0]); %Lateral velocity vs time
% 
% 
% 
% %Want to calculate (with torque) - (without torque)
% %r_torque - r 
% %Run the first run with the torque. Output both the r_torque and the r
% %term. Don't plot anything. 
% %Run the second time without torque. Comment out the r_torque so that it
% %doesn't overwrite. Keep the r value so that it does overwrite. Comment out
% %the Transfer function so that it doesn't overwrite. BUT then add the
% %plotting to the script. 
% 4/15 - right now I am going to skip fixing this because I forget how to
% do it :( Going to come back at a later date. 
% r_diff = r_torque-r;
% figure(10)
% plot(tout,r_diff);
% xlabel('Time');
% ylabel('Yaw Rate (rad/s)');
% title('Yaw Rate (Corrected Error)');
% hold on 
% plot(tout(shortPlotRange,1), YawRate_TF_Torque(shortPlotRange,1));
% legend('P1 Model','Torque TF');
% % 
%


figure(115)
plot(tout(longPlotRange,1), r(longPlotRange,1), 'LineWidth', 2);
xlabel('Time (s)'),ylabel('Yaw Rate (rad/s)');
title('Yaw Rate');
% axis([110 140 0.2 0.3])
% % 
% 
% 
% % figure(9)
% % plot(tout(shortPlotRange,1),r_torque(shortPlotRange,1));
% % xlabel('Time (s)'),ylabel('Yaw Rate (rad/s)');
% % title('Yaw Rate Torque Addition');
% 
% 
% 
% 
% 
%Lateral Tire Forces
figure(7)
plot(tout(:,1), FyTire(:,1:4), 'Linewidth',2), xlabel('Time (s)'), ylabel('Lateral Tire Force (N)'),title('Lateral Tire Force'),legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel');

%Longitudinal Tire Forces
figure(8)
plot(tout(:,1), FxTire(:,1:4), 'Linewidth',2), xlabel('Time (s)'), ylabel('Tire Force (N)'),title('Longitudinal Tire Force'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'); 
% 
% % %Vehicle Side Slip calcs
% % BetaRad=atan(vy./vx);
% % BetaDeg=BetaRad.*180/pi;
% % %Vehicle Side Slip plot
% % figure(9)
% % plot(tout(shortPlotRange,1), BetaDeg(shortPlotRange,1)), xlabel('Time (s)'), ylabel('Side Slip (Degrees)'),title('Vehicle Side Slip'), axis ([15 TotalTime -1.5 0]);
% % 




%Tire Slip Angle
% figure(10)
% plot(tout(shortPlotRange,1), AlphaDeg(shortPlotRange,1:4)), xlabel('Time (s)'), ylabel('Tire Slip Angle (Degrees)'), title('Tire Slip Anlges'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel'), axis ([15 TotalTime -7 -3]);

%Tire Forces vs Tire Slip Angles
% figure(11)
% plot(AlphaDeg(shortPlotRange,4), FyTire(shortPlotRange,1:4)), xlabel('Tire Slip Angle (Degrees)'), ylabel('Lateral Tire Force (N)'), title('Lateral Tire Force vs Tire Slip Angle (Deg)'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel');
% % % 
% % figure(22)
% % plot(tout, AlphaDeg), xlabel('time'), ylabel('alpha'), title('slip angle'), legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel');
% % % 
% %Yaw Rate vs Vehicle Side Slip
% % figure (12)
% % plot(BetaDeg(shortPlotRange,1), r(shortPlotRange,1)), xlabel('Vehicle Side Slip Angle (deg)'), ylabel('Yaw Rate (rad/s)'), title('Yaw Rate vs Side Slip Angle');
% % 
% figure(17)
% plot(tout, FrictionLimits,'.'), xlabel('Time (s)'), ylabel('Force (N)'),title('Tire Friction Limit'),legend('Left Front Wheel', 'Right Front Wheel', 'Left Rear Wheel', 'Right Rear Wheel');
% 


% mu = Fmaxlat./Fz
% FrictionUtilization = sqrt((FxTire./Fz).^2 + (FyTire./Fz).^2);
% figure(19)
% plot(tout, FrictionUtilization,'.'), xlabel('Time (s)'), ylabel('Friction'), title('Friction Utilization'), legend('LF', 'RF', 'LR', 'RR')

% 
% 
% % %Acceleration Plots
% % figure(13)
% % plot(ay(shortPlotRange,1), ax(shortPlotRange,1)), xlabel('Lateral Acceleration (m/s^2)'), ylabel('Longitudinal Acceleration (m/s^2)'), title('Longitudinal vs Lateral Acceleration');
% % figure(14)
% % plot(tout(shortPlotRange,1), ax(shortPlotRange,1)),xlabel('Time (s)'), ylabel('Longitudinal Acceleration (m/s^2)'), title('Longitudinal Acceleration'), axis ([15 TotalTime -0.2 0.4]);
 




% 
% %Calculating radius
% % R=2.5./(HandwheelAngle./10); 
% % figure(17)
% % plot(tout,R), xlabel('time'), ylabel('radius'),title('Vehicle Radius');
% % 
% 




%Transfer Function Calculations 

%Define constants

% m = 1724; % kg - mass
% r = 0.322; % m - Wheel effective radius
% a_1 = 1.35; %m - CG to front axle 
% b_1 = 1.15; % m - CG to rear axle 
% d = half track (m)
% L = a_1+b_1;
% Iz = 1300; % kgm^2 - yaw moment of inertia
% U = 11.1; % m/s - constant speed 
% Caf = 37500; % - front cornering stiffness
% Car = 67500; % - Rear cornering stiffness
% T_nom_f = 0; % Nm - Torque front wheels
% T_nom_r = 184; %Nm - Torque rear wheels - avg
% syms s %Define variable s as symbolic

%Poles calculation 

% pre_poles = [tout.^2] + [(((2*(Caf+Car))/(m*U))+(2*((Caf*(a_1^2))+(Car*(b_1^2))))/(Iz*U)).*tout] + [((4*Caf*Car*(L^2))/(m*Iz*(U^2)))-((2*((a_1*Caf)-(b_1*Car)))/Iz)];
% poles = vpa(pre_poles, 5);

%Transfer Function Calculation

% pre_Vel_Delta_f = [((2/m)*((T_nom_f/r)+Caf)*s) + ((2/(m*U*Iz))*((T_nom_f/r)+Caf)*((2*b_1*L*Car)-(a_1*m*(U^2))))]/poles;
% Vel_Delta_f = vpa(pre_Vel_Delta_f, 5)
% 
% pre_Vel_Delta_r = [((2/m)*((T_nom_r/r)+Car)*s) + ((2/(m*U*Iz))*((T_nom_r/r)+Car)*((2*a_1*L*Caf)+(b_1*m*(U^2))))]/poles;
% Vel_Delta_r = vpa(pre_Vel_Delta_r, 5)
% 
% pre_Yaw_Delta_f = (((2*a_1/Iz)*((T_nom_f/r)+Caf).*tout) + (((4*Car*L)/(m*U*Iz))*((T_nom_f/r)+Caf)))./poles;
% Yaw_Delta_f = vpa(pre_Yaw_Delta_f,5);
% figure(16)
% plot(tout, Yaw_Delta_f),xlabel('Time (s)'),ylabel('Yaw Rate (rad/s)'), title('Yaw Rate Transfer Function Bicycle Model')

% pre_Yaw_Delta_r = [((-2*b_1/Iz)*((T_nom_r/r)+Car)*s) + (((4*Caf*L)/(m*U*Iz))*((T_nom_f/r)+Car))]/poles;
% Yaw_Delta_r = vpa(pre_Yaw_Delta_r,5);


% Yaw_Torque = [-d/(r*Iz)*s  -  (2*s/(r*m*U*Iz)*(Car + Car)]/poles;



