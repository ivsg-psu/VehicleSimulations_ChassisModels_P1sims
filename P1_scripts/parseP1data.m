% Parse all p1 data out into structures

excerptGoodSPI

Controls.switch.KeySwitch = bitUnpack(rt_ControlPanel,1,1);
Controls.switch.HVEnable = bitUnpack(rt_ControlPanel,1,2);
Controls.switch.DCDCOn = bitUnpack(rt_ControlPanel,1,3);
Controls.switch.Utility1 = bitUnpack(rt_ControlPanel,1,4);
Controls.switch.Utility2 = bitUnpack(rt_ControlPanel,1,5);
Controls.switch.Utility3 = bitUnpack(rt_ControlPanel,1,6);
Controls.switch.CruiseSet = bitUnpack(rt_ControlPanel,1,7);
Controls.switch.CruiseEnable = bitUnpack(rt_ControlPanel,1,8);
Controls.lamp.FNRF = bitUnpack(rt_ControlPanel,2,1);
Controls.lamp.FNRR = bitUnpack(rt_ControlPanel,2,2);
Controls.lamp.GPSOK = bitUnpack(rt_ControlPanel,2,3);
Controls.lamp.WFTOK = bitUnpack(rt_ControlPanel,2,4);
Controls.lamp.DriveFault = bitUnpack(rt_ControlPanel,2,5);
Controls.lamp.SteerFault = bitUnpack(rt_ControlPanel,2,6);
Controls.lamp.DCDCOK = bitUnpack(rt_ControlPanel,2,7);

Driver.brakeSwitchA = ~bitUnpack(rt_DriverInput,1,2);
Driver.switchFNRF = bitUnpack(rt_DriverInput,1,2);
Driver.switchFNRR = -1*bitUnpack(rt_DriverInput,1,3);
Driver.accel_pedal = 12*3.3/4096*uint8todouble(0,0,rt_DriverInput(:,2),rt_DriverInput(:,3)); 
Driver.steering_pot = uint8todouble(0,0,rt_DriverInput(:,4),rt_DriverInput(:,5));
Driver.steering_angle_pot = (Driver.steering_pot-208)/246*pi/2*60/18;
Driver.steering_encoder = uint8todouble(1,0,rt_DriverInput(:,6),rt_DriverInput(:,7),rt_DriverInput(:,8),rt_DriverInput(:,9));
unwrapped_encoder = Driver.steering_encoder;
for dataInd = 1:length(unwrapped_encoder)-1
    if unwrapped_encoder(dataInd) - unwrapped_encoder(dataInd+1) < -2^15
        unwrapped_encoder(dataInd+1:end) = -(2^16-1) + unwrapped_encoder(dataInd+1:end);
    elseif unwrapped_encoder(dataInd) - unwrapped_encoder(dataInd+1) > 2^15
        unwrapped_encoder(dataInd+1:end) = (2^16-1) + unwrapped_encoder(dataInd+1:end);
    end 
end
Driver.unwrapped_encoder = unwrapped_encoder;
Driver.handwheel_primary = uint8todouble(0,1,rt_DriverInput(:,10),rt_DriverInput(:,11),rt_DriverInput(:,12),rt_DriverInput(:,13));
Driver.handwheel_secondary = uint8todouble(0,1,rt_DriverInput(:,14),rt_DriverInput(:,15),rt_DriverInput(:,16),rt_DriverInput(:,17));
Driver.latch_time = uint8todouble(0,1,rt_DriverInput(:,18),rt_DriverInput(:,19),rt_DriverInput(:,20),rt_DriverInput(:,21));


noDiffInds = find(rt_GPS(:,4) < 4 & rt_GPS(:,4) >= 2);
diffInds = find(rt_GPS(:,4) >= 4);
allGNSSInds = sort([noDiffInds; diffInds]);
GPS.ToW = rt_GPS(:,1);
GPS.Week = rt_GPS(:,2);
GPS.Sats = rt_GPS(:,3);
GPS.Mode = rt_GPS(:,4);
GPS.Lat = rt_GPS(:,5);
GPS.Long = rt_GPS(:,6);
GPS.Alt = rt_GPS(:,7);
GPS.HorSpd = rt_GPS(:,8);
GPS.VrtSpd = rt_GPS(:,9);
GPS.CoG = rt_GPS(:,10);
GPS.Hdg = rt_GPS(:,11);
GPS.Roll = rt_GPS(:,12);
GPS.AttStat = [double(bitand(uint16(rt_GPS(:,14)),uint16(15))),...
    double(bitshift(bitand(uint16(rt_GPS(:,14)),uint16(240)),-4))+0.04,...
    double(bitshift(bitand(uint16(rt_GPS(:,14)),uint16(3840)),-8))+0.08];
GPS.HorRMS = rt_GPS(:,17);


% Some constants useful for converting the raw CAN message data
IMU.constants.IMUraw2degpersec = 500/32768;
IMU.constants.ACCraw2mpersec = 2*9.81/32768;
% Process the raw data into signals
IMU.accelX = IMU.constants.ACCraw2mpersec*uint8todouble(1,0,rt_IMU(:,7),rt_IMU(:,8));
IMU.rotRateX = IMU.constants.IMUraw2degpersec*uint8todouble(1,0,rt_IMU(:,1),rt_IMU(:,2));
IMU.accelY = IMU.constants.ACCraw2mpersec*uint8todouble(1,0,rt_IMU(:,9),rt_IMU(:,10));
IMU.rotRateY = IMU.constants.IMUraw2degpersec*uint8todouble(1,0,rt_IMU(:,3),rt_IMU(:,4));
IMU.accelZ = IMU.constants.ACCraw2mpersec*uint8todouble(1,0,rt_IMU(:,11),rt_IMU(:,12));
IMU.rotRateZ = IMU.constants.IMUraw2degpersec*uint8todouble(1,0,rt_IMU(:,5),rt_IMU(:,6));


% Universal Command
% LEFT
Motor.Left.Command.opStateMotorL = uint8todouble(0,0,rt_DrivetrainLeft(:,1),rt_DrivetrainLeft(:,2));
Motor.Left.Command.reqMotorTorqueL = (0.1*uint8todouble(0,0,rt_DrivetrainLeft(:,3),rt_DrivetrainLeft(:,4))) - 3212.8;
Motor.Left.Command.limMotorSpeedFL = (0.5*uint8todouble(0,0,rt_DrivetrainLeft(:,5),rt_DrivetrainLeft(:,6))) - 16064;
Motor.Left.Command.limMotorSpeedRL = (0.5*uint8todouble(0,0,rt_DrivetrainLeft(:,7),rt_DrivetrainLeft(:,8))) - 16064;
% Right
Motor.Right.Command.opStateMotorR = uint8todouble(0,0,rt_DrivetrainRight(:,1),rt_DrivetrainRight(:,2));
Motor.Right.Command.reqMotorTorqueR = (0.1*uint8todouble(0,0,rt_DrivetrainLeft(:,3),rt_DrivetrainLeft(:,4))) - 3212.8;
Motor.Right.Command.limMotorSpeedFR = (0.5*uint8todouble(0,0,rt_DrivetrainRight(:,5),rt_DrivetrainRight(:,6))) - 16064;
Motor.Right.Command.limMotorSpeedRR = (0.5*uint8todouble(0,0,rt_DrivetrainLeft(:,7),rt_DrivetrainLeft(:,8))) - 16064;

% Accurate feedback message
% LEFT
Motor.Left.Feedback.trueMotorTorqueL = (0.1*uint8todouble(0,0,rt_DrivetrainLeft(:,11),rt_DrivetrainLeft(:,12))) - 3212.8;
Motor.Left.Feedback.trueMotorVoltageL = (0.1*uint8todouble(0,0,rt_DrivetrainLeft(:,13),rt_DrivetrainLeft(:,14))) - 3212.8;
Motor.Left.Feedback.trueMotorCurrentL = (0.1*uint8todouble(0,0,rt_DrivetrainLeft(:,15),rt_DrivetrainLeft(:,16))) - 3212.8;
Motor.Left.Feedback.trueMotorSpeedL = (0.5*uint8todouble(0,0,rt_DrivetrainLeft(:,17),rt_DrivetrainLeft(:,18))) - 16064;
% RIGHT
Motor.Right.Feedback.trueMotorTorqueR = (0.1*uint8todouble(0,0,rt_DrivetrainRight(:,11),rt_DrivetrainRight(:,12))) - 3212.8;
Motor.Right.Feedback.trueMotorVoltageR = (0.1*uint8todouble(0,0,rt_DrivetrainRight(:,13),rt_DrivetrainRight(:,14))) - 3212.8;
Motor.Right.Feedback.trueMotorCurrentR = (0.1*uint8todouble(0,0,rt_DrivetrainRight(:,15),rt_DrivetrainRight(:,16))) - 3212.8;
Motor.Right.Feedback.trueMotorSpeedR = (0.5*uint8todouble(0,0,rt_DrivetrainRight(:,17),rt_DrivetrainRight(:,18))) - 16064;

Steering.Left.state = bitshift(bitand(hex2dec('f0'),rt_SteeringLeft(:,1)),-4);
Steering.Left.substate = bitand(hex2dec('f'),rt_SteeringLeft(:,1));
Steering.Left.statusWord = uint8todouble(0,0,rt_SteeringLeft(:,2),rt_SteeringLeft(:,3));
Steering.Left.posTargetVal = uint8todouble(1,0,rt_SteeringLeft(:,4),rt_SteeringLeft(:,5),rt_SteeringLeft(:,6),rt_SteeringLeft(:,7));
Steering.Left.posActualVal = uint8todouble(1,0,rt_SteeringLeft(:,16),rt_SteeringLeft(:,17),rt_SteeringLeft(:,18),rt_SteeringLeft(:,19));
Steering.Left.velFeedF = 10*uint8todouble(1,0,rt_SteeringLeft(:,8),rt_SteeringLeft(:,9),rt_SteeringLeft(:,10),rt_SteeringLeft(:,11));
Steering.Left.actualVel = 10*uint8todouble(1,0,rt_SteeringLeft(:,20),rt_SteeringLeft(:,21),rt_SteeringLeft(:,22),rt_SteeringLeft(:,23));
Steering.Left.currentFeedF = 0.001*uint8todouble(1,0,rt_SteeringLeft(:,12),rt_SteeringLeft(:,13),rt_SteeringLeft(:,14),rt_SteeringLeft(:,15));
Steering.Left.torqueActualVal = 0.925*0.001*uint8todouble(1,0,rt_SteeringLeft(:,24),rt_SteeringLeft(:,25));

Steering.Right.state = bitshift(bitand(hex2dec('f0'),rt_SteeringRight(:,1)),-4);
Steering.Right.substate = bitand(hex2dec('f'),rt_SteeringRight(:,1));
Steering.Right.statusWord = uint8todouble(0,0,rt_SteeringRight(:,2),rt_SteeringRight(:,3));
Steering.Right.posTargetVal = uint8todouble(1,0,rt_SteeringRight(:,4),rt_SteeringRight(:,5),rt_SteeringRight(:,6),rt_SteeringRight(:,7));
Steering.Right.posActualVal = uint8todouble(1,0,rt_SteeringRight(:,16),rt_SteeringRight(:,17),rt_SteeringRight(:,18),rt_SteeringRight(:,19));
Steering.Right.velFeedF = 10*uint8todouble(1,0,rt_SteeringRight(:,8),rt_SteeringRight(:,9),rt_SteeringRight(:,10),rt_SteeringRight(:,11));
Steering.Right.actualVel = 10*uint8todouble(1,0,rt_SteeringRight(:,20),rt_SteeringRight(:,21),rt_SteeringRight(:,22),rt_SteeringRight(:,23));
Steering.Right.currentFeedF = 0.001*uint8todouble(1,0,rt_SteeringRight(:,12),rt_SteeringRight(:,13),rt_SteeringRight(:,14),rt_SteeringRight(:,15));
Steering.Right.torqueActualVal = 0.925*0.001*uint8todouble(1,0,rt_SteeringRight(:,24),rt_SteeringRight(:,25));

WFT.left.Fx = 1.220703*uint8todouble(1,0,rt_WheelForceLeft(:,1),rt_WheelForceLeft(:,2));
WFT.left.Fy = 0.6103515625*uint8todouble(1,0,rt_WheelForceLeft(:,3),rt_WheelForceLeft(:,4));
WFT.left.Fz = 1.220703*uint8todouble(1,0,rt_WheelForceLeft(:,5),rt_WheelForceLeft(:,6));
WFT.left.Mx = 0.18310546875*uint8todouble(1,0,rt_WheelForceLeft(:,7),rt_WheelForceLeft(:,8));
WFT.left.My = 0.18310546875*uint8todouble(1,0,rt_WheelForceLeft(:,9),rt_WheelForceLeft(:,10));
WFT.left.Mz = 0.18310546875*uint8todouble(1,0,rt_WheelForceLeft(:,11),rt_WheelForceLeft(:,12));
WFT.left.Vel = 0.06103515625*uint8todouble(1,0,rt_WheelForceLeft(:,13),rt_WheelForceLeft(:,14));
WFT.left.Pos = 0.010986328125*uint8todouble(1,0,rt_WheelForceLeft(:,15),rt_WheelForceLeft(:,16));
WFT.left.Ax = 0.0030517578125*uint8todouble(1,0,rt_WheelForceLeft(:,17),rt_WheelForceLeft(:,18));
WFT.left.Az = 0.0030517578125*uint8todouble(1,0,rt_WheelForceLeft(:,19),rt_WheelForceLeft(:,20));
WFT.right.Fx = 1.220703*uint8todouble(1,0,rt_WheelForceRight(:,1),rt_WheelForceRight(:,2));
WFT.right.Fy = 0.6103515625*uint8todouble(1,0,rt_WheelForceRight(:,3),rt_WheelForceRight(:,4));
WFT.right.Fz = 1.220703*uint8todouble(1,0,rt_WheelForceRight(:,5),rt_WheelForceRight(:,6));
WFT.right.Mx = 0.18310546875*uint8todouble(1,0,rt_WheelForceRight(:,7),rt_WheelForceRight(:,8));
WFT.right.My = 0.18310546875*uint8todouble(1,0,rt_WheelForceRight(:,9),rt_WheelForceRight(:,10));
WFT.right.Mz = 0.18310546875*uint8todouble(1,0,rt_WheelForceRight(:,11),rt_WheelForceRight(:,12));
WFT.right.Vel = 0.06103515625*uint8todouble(1,0,rt_WheelForceRight(:,13),rt_WheelForceRight(:,14));
WFT.right.Pos = 0.010986328125*uint8todouble(1,0,rt_WheelForceRight(:,15),rt_WheelForceRight(:,16));
WFT.right.Ax = 0.0030517578125*uint8todouble(1,0,rt_WheelForceRight(:,17),rt_WheelForceRight(:,18));
WFT.right.Az = 0.0030517578125*uint8todouble(1,0,rt_WheelForceRight(:,19),rt_WheelForceRight(:,20));