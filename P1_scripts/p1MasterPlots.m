% Master Plot for all data coming through P1 vehicle
% Compilation of all data

% Dependencies:
%       - bitUnpack() for getting values of individual bits within uint8
%       variables

% Section out the different data display types by the categories on the Car
% Data Signals google sheet file

%% Control Panel
figure('Name','Control Panel','NumberTitle','off')

% Switch Key Switch
subplot(5,3,1)
switchKeySwitch = bitUnpack(rt_ControlPanel,1,1);
plot(rt_tout,switchKeySwitch)
xlabel('Time (s)')
title('Key Switch')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch HV Enable
subplot(5,3,2)
switchHVEnable = bitUnpack(rt_ControlPanel,1,2);
plot(rt_tout,switchHVEnable)
xlabel('Time (s)')
title('HV Enable')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch DC/DC On
subplot(5,3,3)
switchDCDCOn = bitUnpack(rt_ControlPanel,1,3);
plot(rt_tout,switchDCDCOn)
xlabel('Time (s)')
title('DC/DC On')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Utility 1
subplot(5,3,4)
switchUtility1 = bitUnpack(rt_ControlPanel,1,4);
plot(rt_tout,switchUtility1)
xlabel('Time (s)')
title('Utility 1')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Utility 2
subplot(5,3,5)
switchUtility2 = bitUnpack(rt_ControlPanel,1,5);
plot(rt_tout,switchUtility2)
xlabel('Time (s)')
title('Utility 2')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Utility 3
subplot(5,3,6)
switchUtility3 = bitUnpack(rt_ControlPanel,1,6);
plot(rt_tout,switchUtility3)
xlabel('Time (s)')
title('Utility 3')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Cruise Set
subplot(5,3,7)
switchCruiseSet = bitUnpack(rt_ControlPanel,1,7);
plot(rt_tout,switchCruiseSet)
xlabel('Time (s)')
title('Cruise Set')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Cruise Enable
subplot(5,3,8)
switchCruiseEnable = bitUnpack(rt_ControlPanel,1,8);
plot(rt_tout,switchCruiseEnable)
xlabel('Time (s)')
title('Cruise Enable')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp FNR (F)
subplot(5,3,9)
lampFNRF = bitUnpack(rt_ControlPanel,2,1);
plot(rt_tout,lampFNRF)
xlabel('Time (s)')
title('Lamp FNR (F)')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp FNR (R)
subplot(5,3,10)
lampFNRR = bitUnpack(rt_ControlPanel,2,2);
plot(rt_tout,lampFNRR)
xlabel('Time (s)')
title('Lamp FNR (R)')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp GPS OK
subplot(5,3,11)
lampGPSOK = bitUnpack(rt_ControlPanel,2,3);
plot(rt_tout,lampGPSOK)
xlabel('Time (s)')
title('Lamp GPS OK')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp WFT OK
subplot(5,3,12)
lampWFTOK = bitUnpack(rt_ControlPanel,2,4);
plot(rt_tout,lampWFTOK)
xlabel('Time (s)')
title('Lamp WFT OK')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp Drive Fault
subplot(5,3,13)
lampDriveFault = bitUnpack(rt_ControlPanel,2,5);
plot(rt_tout,lampDriveFault)
xlabel('Time (s)')
title('Lamp Drive Fault')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp Steer Fault
subplot(5,3,14)
lampSteerFault = bitUnpack(rt_ControlPanel,2,6);
plot(rt_tout,lampSteerFault)
xlabel('Time (s)')
title('Lamp Steer Fault')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp DC/DC OK
subplot(5,3,15)
lampDCDCOK = bitUnpack(rt_ControlPanel,2,7);
plot(rt_tout,lampDCDCOK)
xlabel('Time (s)')
title('Lamp DC/DC OK')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

%% Driver Input

figure('Name','Driver Input','NumberTitle','off')

% Brake Switch A
subplot(6,2,1)
brakeSwitchA = bitUnpack(rt_DriverInput,1,1);
plot(rt_tout,brakeSwitchA)
xlabel('Time (s)')
title('Brake Switch A')
yticks([0 1])
yticklabels({'Off' 'On'})

% Brake Switch B
subplot(6,2,3)
brakeSwitchB = bitUnpack(rt_DriverInput,1,2);
plot(rt_tout,brakeSwitchA)
xlabel('Time (s)')
title('Brake Switch B')
yticks([0 1])
yticklabels({'Off' 'On'})

% Switch FNR (F)
subplot(6,2,2)
switchFNRF = bitUnpack(rt_DriverInput,1,3);
plot(rt_tout,switchFNRF)
xlabel('Time (s)')
title('Switch FNR (F)')
yticks([0 1])
yticklabels({'Off' 'On'})

% Switch FNR (R)
subplot(6,2,4)
switchFNRR = bitUnpack(rt_DriverInput,1,4);
plot(rt_tout,switchFNRR)
xlabel('Time (s)')
title('Switch FNR (R)')
yticks([0 1])
yticklabels({'Off' 'On'})

% Accelerator Potentiometer
subplot(3,2,3)
accel_pedal = 12*3.3/4096*uint8todouble(0,rt_DriverInput(:,2),rt_DriverInput(:,3)); 
plot(rt_tout,accel_pedal)
ylim([0 5])
ylabel('Accelerator Pedal Voltage (V)')
xlabel('Time (s)')

% Handwheel Potentiometer
subplot(3,2,4)
steering_pot = 12*3.3/4096*uint8todouble(0,rt_DriverInput(:,4),rt_DriverInput(:,5));
steering_angle_pot = -5.24*(steering_pot - 1.08);
plot(rt_tout,steering_angle_pot*180/pi)
ylim([-200 200])
ylabel('Steering Angle (deg)')
xlabel('Time (s)')

% Handwheel Encoder
subplot(3,2,5)
steering_encoder = uint8todouble(1,rt_DriverInput(:,6),rt_DriverInput(:,7),rt_DriverInput(:,8),rt_DriverInput(:,9));
% Unwrap the signal
unwrapped_encoder = steering_encoder;
for dataInd = 1:length(unwrapped_encoder)-1
    if unwrapped_encoder(dataInd) - unwrapped_encoder(dataInd+1) < -2^15
        unwrapped_encoder(dataInd+1:end) = -(2^16-1) + unwrapped_encoder(dataInd+1:end);
    elseif unwrapped_encoder(dataInd) - unwrapped_encoder(dataInd+1) > 2^15
        unwrapped_encoder(dataInd+1:end) = (2^16-1) + unwrapped_encoder(dataInd+1:end);
    end 
end
% Then plot both wrapped and unwrapped versions for comparison
plot(rt_tout,steering_encoder,rt_tout,unwrapped_encoder)
ylim([-200000 200000])
legend('Raw Signal','Unwrapped')
ylabel('Handwheel Position (counts)')
xlabel('Time (s)')

%% Steering (Left)

figure('Name','Steering (Left)','NumberTitle','off')

% Operational State (Flexcase)
% Might need to alter to use yticks
subplot(2,4,1)
plot(rt_tout,double(rt_SteeringLeft(:,1)))
title('Operational State (Flexcase)')
xlabel('Time (s)')
ylabel('Coded')

% Status Word
% Might need to alter to use yticks
subplot(2,4,2)
statusWordLeft = uint8todouble(0,rt_SteeringLeft(:,2),rt_SteeringLeft(:,3));
plot(rt_tout,statusWordLeft)
title('Status Word')
xlabel('Time (s)')
ylabel('Coded')

% Position Target Value
subplot(2,4,3)
posTargetValLeft = uint8todouble(1,rt_SteeringLeft(:,4),rt_SteeringLeft(:,5),rt_SteeringLeft(:,6),rt_SteeringLeft(:,7));
plot(rt_tout,posTargetValLeft)
title('Position Target Value')
xlabel('Time (s)')
ylabel('Counts')

% Velocity Feedforward
subplot(2,4,4)
velFeedFLeft = 10*uint8todouble(1,rt_SteeringLeft(:,8),rt_SteeringLeft(:,9),rt_SteeringLeft(:,10),rt_SteeringLeft(:,11));
plot(rt_tout,velFeedFLeft)
title('Velocity Feedforward')
xlabel('Time (s)')
ylabel('Counts/sec')

% Current Feedforward
subplot(2,4,5)
currentFeedFLeft = 0.001*uint8todouble(1,rt_SteeringLeft(:,12),rt_SteeringLeft(:,13),rt_SteeringLeft(:,14),rt_SteeringLeft(:,15));
plot(rt_tout,currentFeedFLeft)
title('Current Feedforward')
xlabel('Time (s)')
ylabel('Nm')

% Position Actual Value
subplot(2,4,6)
posActualValLeft = uint8todouble(1,rt_SteeringLeft(:,16),rt_SteeringLeft(:,17),rt_SteeringLeft(:,18),rt_SteeringLeft(:,19));
plot(rt_tout,posActualValLeft)
title('Position Actual Value')
xlabel('Time (s)')
ylabel('Counts')

% Actual Velocity
subplot(2,4,7)
actualVelLeft = 10*uint8todouble(1,rt_SteeringLeft(:,20),rt_SteeringLeft(:,21),rt_SteeringLeft(:,22),rt_SteeringLeft(:,23));
plot(rt_tout,actualVelLeft)
title('Actual Velocity')
xlabel('Time (s)')
ylabel('Counts/sec')

% Torque Actual Value
subplot(2,4,8)
torqueActualValLeft = 0.001*uint8todouble(1,rt_SteeringLeft(:,24),rt_SteeringLeft(:,25),rt_SteeringLeft(:,26),rt_SteeringLeft(:,27));
plot(rt_tout,torqueActualValLeft)
title('Torque Actual Value')
xlabel('Time (s)')
ylabel('Counts/sec')

%% Steering (Right)

figure('Name','Steering (Right)','NumberTitle','off')

% Operational State (Flexcase)
% Might need to alter to use yticks
subplot(2,4,1)
plot(rt_tout,double(rt_SteeringRight(:,1)))
title('Operational State (Flexcase)')
xlabel('Time (s)')
ylabel('Coded')

% Status Word
% Might need to alter to use yticks
subplot(2,4,2)
statusWordRight = uint8todouble(0,rt_SteeringRight(:,2),rt_SteeringRight(:,3));
plot(rt_tout,statusWordRight)
title('Status Word')
xlabel('Time (s)')
ylabel('Coded')

% Position Target Value
subplot(2,4,3)
posTargetValRight = uint8todouble(1,rt_SteeringRight(:,4),rt_SteeringRight(:,5),rt_SteeringRight(:,6),rt_SteeringRight(:,7));
plot(rt_tout,posTargetValRight)
title('Position Target Value')
xlabel('Time (s)')
ylabel('Counts')

% Velocity Feedforward
subplot(2,4,4)
velFeedFRight = 10*uint8todouble(1,rt_SteeringRight(:,8),rt_SteeringRight(:,9),rt_SteeringRight(:,10),rt_SteeringRight(:,11));
plot(rt_tout,velFeedFRight)
title('Velocity Feedforward')
xlabel('Time (s)')
ylabel('Counts/sec')

% Current Feedforward
subplot(2,4,5)
currentFeedFRight = 0.001*uint8todouble(1,rt_SteeringRight(:,12),rt_SteeringRight(:,13),rt_SteeringRight(:,14),rt_SteeringRight(:,15));
plot(rt_tout,currentFeedFRight)
title('Current Feedforward')
xlabel('Time (s)')
ylabel('Nm')

% Position Actual Value
subplot(2,4,6)
posActualValRight = uint8todouble(1,rt_SteeringRight(:,16),rt_SteeringRight(:,17),rt_SteeringRight(:,18),rt_SteeringRight(:,19));
plot(rt_tout,posActualValRight)
title('Position Actual Value')
xlabel('Time (s)')
ylabel('Counts')

% Actual Velocity
subplot(2,4,7)
actualVelRight = 10*uint8todouble(1,rt_SteeringRight(:,20),rt_SteeringRight(:,21),rt_SteeringRight(:,22),rt_SteeringRight(:,23));
plot(rt_tout,actualVelRight)
title('Actual Velocity')
xlabel('Time (s)')
ylabel('Counts/sec')

% Torque Actual Value
subplot(2,4,8)
torqueActualValRight = 0.001*uint8todouble(1,rt_SteeringRight(:,24),rt_SteeringRight(:,25),rt_SteeringRight(:,26),rt_SteeringRight(:,27));
plot(rt_tout,torqueActualValRight)
title('Torque Actual Value')
xlabel('Time (s)')
ylabel('Counts/sec')


%% Motor (Left)

figure('Name','Motor (Left)','NumberTitle','off')

% Operational State (Flexcase)
subplot(2,4,1)
opStateMotorLeft = uint8todouble(0,rt_MotorLeft(:,1),rt_MotorLeft(:,2));
plot(rt_tout,opStateMotorLeft)
title('Operational State (Flexcase)')
xlabel('Time (s)')
ylabel('Coded')

% Universal Command
subplot(2,4,2)
uniCommandMotorLeft = 0;

%% Motor (Right)

figure('Name','Motor (Right)','NumberTitle','off')

%% IMU

figure('Name','IMU','NumberTitle','off')

% Acceleration X (Longitudinal)
subplot(3,2,1)
accelX = uint8todouble(1,rt_IMU(:,1),rt_IMU(:,2));
plot(rt_tout,accelX)
title('Acceleration X (Longitudinal)')
xlabel('Time (s)')
ylabel('% Full Scale')

% Rotation Rate X (Roll)
subplot(3,2,2)
rotRateX = uint8todouble(1,rt_IMU(:,7),rt_IMU(:,8));
plot(rt_tout,rotRateX)
title('Rotation Rate X (Roll)')
xlabel('Time (s)')
ylabel('% Full Scale')

% Acceleration Y (Lateral)
subplot(3,2,3)
accelY = uint8todouble(1,rt_IMU(:,3),rt_IMU(:,4));
plot(rt_tout,accelY)
title('Acceleration Y (Lateral)')
xlabel('Time (s)')
ylabel('% Full Scale')

% Rotation Rate Y (Pitch)
subplot(3,2,4)
rotRateY = uint8todouble(1,rt_IMU(:,9),rt_IMU(:,10));
plot(rt_tout,rotRateY)
title('Roation Rate Y (Pitch)')
xlabel('Time (s)')
ylabel('% Full Scale')

% Acceleration Z (Heave)
subplot(3,2,5)
accelZ = uint8todouble(1,rt_IMU(:,5),rt_IMU(:,6));
plot(rt_tout,accelZ)
title('Acceleration Z (Heave)')
xlabel('Time (s)')
ylabel('% Full Scale')

% Rotation Rate Z (Yaw)
subplot(3,2,6)
rotRateZ = uint8todouble(1,rt_IMU(:,11),rt_IMU(:,12));
plot(rt_tout,accelZ)
title('Rotation Rate Z (Yaw)')
xlabel('Time (s)')
ylabel('% Full Scale')

%% Wheel Force Transducer (Left)

figure('Name','Wheel Force Transducer (Left)','NumberTitle','off')

% Left Front Forces combined
subplot(3,2,1)
sglfxForce = 1.220703*uint8todouble(1,rt_WheelForceLeft(:,1),rt_WheelForceLeft(:,2));
sglfyForce = 0.6103515625*uint8todouble(1,rt_WheelForceLeft(:,3),rt_WheelForceLeft(:,4));
sglfzForce = 1.220703*uint8todouble(1,rt_WheelForceLeft(:,5),rt_WheelForceLeft(:,6));
plot(rt_tout,sglfxForce,rt_tout,sglfyForce,rt_tout,sglfzForce)
title('LF Tire Forces')
xlabel('Time (s)')
ylabel('Force (N)')
legend('X-Direction','Y-Direction','Z-Direction')

% Left Front Moments combined
subplot(3,2,2)
sglfxMoment = 0.18310546875*uint8todouble(1,rt_WheelForceLeft(:,7),rt_WheelForceLeft(:,8));
sglfyMoment = 0.18310546875*uint8todouble(1,rt_WheelForceLeft(:,9),rt_WheelForceLeft(:,10));
sglfzMoment = 0.18310546875*uint8todouble(1,rt_WheelForceLeft(:,11),rt_WheelForceLeft(:,12));
plot(rt_tout,sglfxMoment,rt_tout,sglfyMoment,rt_tout,sglfzMoment)
title('LF Tire Moments')
xlabel('Time (s)')
ylabel('Moment (Nm)')
legend('X-Direction','Y-Direction','Z-Direction')

% Left Front Velocity
subplot(3,2,3)
sglfVel = 0.06103515625*uint8todouble(1,rt_WheelForceLeft(:,13),rt_WheelForceLeft(:,14));
plot(rt_tout,sglfVel)
title('LF Tire Velocity')
xlabel('Time (s)')
ylabel('Velocity (rpm)')

% Left Front Position
subplot(3,2,4)
sglfPos = 0.010986328125*uint8todouble(1,rt_WheelForceLeft(:,15),rt_WheelForceLeft(:,16));
plot(rt_tout,sglfPos)
title('LF Tire Position')
xlabel('Time (s)')
ylabel('Position (deg)')

% Left Front Acceleration
subplot(3,2,5)
sglfAccelX = 0.0030517578125*uint8todouble(1,rt_WheelForceLeft(:,17),rt_WheelForceLeft(:,18));
sglfAccelZ = 0.0030517578125*uint8todouble(1,rt_WheelForceLeft(:,19),rt_WheelForceLeft(:,20));
plot(rt_tout,sglfAccelX,rt_tout,sglfAccelZ)
title('LF Tire Acceleration')
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('X-direction','Z-Direction')

%% Wheel Force Transducer (Right)

figure('Name','Wheel Force Transducer (Right)','NumberTitle','off')

% Right Front Forces combined
subplot(3,2,1)
sgrfxForce = 1.220703*uint8todouble(1,rt_WheelForceRight(:,1),rt_WheelForceRight(:,2));
sgrfyForce = 0.6103515625*uint8todouble(1,rt_WheelForceRight(:,3),rt_WheelForceRight(:,4));
sgrfzForce = 1.220703*uint8todouble(1,rt_WheelForceRight(:,5),rt_WheelForceRight(:,6));
plot(rt_tout,sgrfxForce,rt_tout,sgrfyForce,rt_tout,sgrfzForce)
title('RF Tire Forces')
xlabel('Time (s)')
ylabel('Force (N)')
legend('X-Direction','Y-Direction','Z-Direction')

% Right Front Moments combined
subplot(3,2,2)
sgrfxMoment = 0.18310546875*uint8todouble(1,rt_WheelForceRight(:,7),rt_WheelForceRight(:,8));
sgrfyMoment = 0.18310546875*uint8todouble(1,rt_WheelForceRight(:,9),rt_WheelForceRight(:,10));
sgrfzMoment = 0.18310546875*uint8todouble(1,rt_WheelForceRight(:,11),rt_WheelForceRight(:,12));
plot(rt_tout,sgrfxMoment,rt_tout,sgrfyMoment,rt_tout,sgrfzMoment)
title('RF Tire Moments')
xlabel('Time (s)')
ylabel('Moment (Nm)')
legend('X-Direction','Y-Direction','Z-Direction')

% Right Front Velocity
subplot(3,2,3)
sgrfVel = 0.06103515625*uint8todouble(1,rt_WheelForceRight(:,13),rt_WheelForceRight(:,14));
plot(rt_tout,sgrfVel)
title('RF Tire Velocity')
xlabel('Time (s)')
ylabel('Velocity (rpm)')

% Right Front Position
subplot(3,2,4)
sgrfPos = 0.010986328125*uint8todouble(1,rt_WheelForceRight(:,15),rt_WheelForceRight(:,16));
plot(rt_tout,sgrfPos)
title('RF Tire Position')
xlabel('Time (s)')
ylabel('Position (deg)')

% Right Front Acceleration
subplot(3,2,5)
sgrfAccelX = 0.0030517578125*uint8todouble(1,rt_WheelForceRight(:,17),rt_WheelForceRight(:,18));
sgrfAccelZ = 0.0030517578125*uint8todouble(1,rt_WheelForceRight(:,19),rt_WheelForceRight(:,20));
plot(rt_tout,sgrfAccelX,rt_tout,sgrfAccelZ)
title('RF Tire Acceleration')
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('X-direction','Z-Direction')


%% GPS

figure('Name','Control Panel','NumberTitle','off')


% Clean up
clear dataInd