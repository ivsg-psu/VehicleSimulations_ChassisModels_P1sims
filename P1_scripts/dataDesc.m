% Adding descriptions to data file
data = struct([]);

time = rt_tout; % time vector in steps of 1/100ths of a second

%% For use with FlexCase and P1 data
ii = 1;
data(ii).name = '01 Control Panel';
data(ii).val.ControlPanel = rt_ControlPanel;
data(ii).size = length(rt_ControlPanel(1,:));
data(ii).units = {'rad' 'rad' 'amps' 'amps' 'volts' 'volts' 'rad' 'rad' 'ticks' 'ticks' 'volts' 'volts'};
data(ii).desc = 'Contains in order: ';

ii = 2;
data(ii).name = '02 Driver Input';
data(ii).val.DriverInput = rt_DriverInput;
data(ii).size = length(rt_DriverInput(1,:));
data(ii).units = {};
data(ii).desc = 'Contains in oder: ';

ii = 3;
data(ii).name = '03 Ignition';
data(ii).val.Ignition = rt_Ignition;
data(ii).size = length(rt_Ignition(1,:));
data(ii).units = {};
data(ii).desc = 'Contains in oder: ';

ii = 4;
data(ii).name = '04 IMU';
data(ii).val.IMU = rt_IMU;
data(ii).val.IMUaX = rt_IMUaX;
data(ii).val.IMUaY = rt_IMUaY;
data(ii).val.IMUaZ = rt_IMUaZ;
data(ii).val.IMUgX = rt_IMUgX;
data(ii).val.IMUgY = rt_IMUgY;
data(ii).val.IMUgZ = rt_IMUgZ;
data(ii).size = length(rt_IMU(1,:));
data(ii).units = {};
data(ii).desc = 'Contains in order: ';

ii = 5;
data(ii).name = '05 Motor';
data(ii).val.MotorLeft = rt_MotorLeft;
data(ii).val.MotorLeftCurrent = rt_MotorLeftCurrent;
data(ii).val.MotorLeftSpeed = rt_MotorLeftSpeed;
data(ii).val.MotorLeftTorque = rt_MotorLeftTorque;
data(ii).val.MotorLeftVoltage = rt_MotorLeftVoltage;
data(ii).val.MotorRight = rt_MotorRight;
data(ii).val.MotorRightCurrent = rt_MotorRightCurrent;
data(ii).val.MotorRightSpeed = rt_MotorRightSpeed;
data(ii).val.MotorRightTorque = rt_MotorRightTorque;
data(ii).val.MotorRightVoltage = rt_MotorRightVoltage;
data(ii).size = length(rt_MotorLeft(1,:))+length(rt_MotorRight(1,:));
data(ii).units = {};
data(ii).desc = 'Contains in oder: ';

ii = 6;
data(ii).name = '06 Steering';
data(ii).val.SteeringLeft = rt_SteeringLeft;
data(ii).val.SteeringRight = rt_SteeringRight;
data(ii).size = length(rt_SteeringLeft(1,:))+length(rt_SteeringRight(1,:));
data(ii).units = {};
data(ii).desc = 'Contains in order: ';

ii = 7;
data(ii).name = '07 Wheel Forces';
data(ii).val.WheelForceLeft = rt_WheelForceLeft;
data(ii).val.WheelForceRight = rt_WheelForceRight;
data(ii).size = length(rt_WheelForceLeft(1,:))+length(rt_WheelForceRight(1,:));
data(ii).units = {};
data(ii).desc = 'Contains in order: ';


%% Only for testing with RP4
% data(ii).name = '01 Steering';
% data(ii).y = y(2:13,:);
% data(ii).size = 12;
% data(ii).units = {'rad' 'rad' 'amps' 'amps' 'volts' 'volts' 'rad' 'rad' 'ticks' 'ticks' 'volts' 'volts'};
% data(ii).desc = 'Contains in order: L&R motor shaft angles, L&R motor currents, L&R motor voltages, L&R gearbox shaft angles, raw L&R encoder values, and raw L&R pot values';
% 
% ii = 2;
% data(ii).name = '02 INS';
% data(ii).y = y(14:19,:);
% data(ii).size = 6;
% data(ii).units = {'rad/s' 'm/s^ii' 'deg/s' 'm/s^ii' 'deg/s' 'm/s^ii'};
% data(ii).desc = 'Contains in order: Yaw rate, ax, roll rate, ay, pitch rate, & az';
% 
% ii = 3;
% data(ii).name = '03 GPS';
% data(ii).y = y(20:47,:);
% data(ii).size = 28;
% data(ii).units = {'na','s','na','deg','deg','m','m','m','m','m/s','m/s','deg','deg','deg','na','na','na','s','deg','deg','m','m','m^2','m^2','m^2','m^2','m^2','m^2'};
% data(ii).desc = 'PPS, time of week, week num, Latitude, Longitude, Altitude, ECEF X, ECEF Y, ECEF Z, horizontal speed, vert velocity, course over ground, heading, roll angle, nav mode, attitude status, sats used, differential age, yaw stddev, roll stddev, horizontal rms, vertical rms, covariance N-N, covariance N-E, covariance N-U, covariance E-E, covariance E-U, covariance U-U';
% 
% ii = 4;
% data(ii).name = '04 Handwheel';
% data(ii).y = y(49:51,:);
% data(ii).size = 3;
% data(ii).units = {'rad' 'rad' 'rad'};
% data(ii).desc = 'Contains three separate handwheel angle measurements.';

clear ii