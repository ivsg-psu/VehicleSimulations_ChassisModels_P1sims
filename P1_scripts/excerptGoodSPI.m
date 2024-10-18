% Script to excerpt only the good data in the set, avoiding bad SPI
% transmissions

spiGoodInds = find(sum(diff(double(rt_spiBytesIn),1,2)==0,2)<100);

% rt_adc0 = rt_adc0(spiGoodInds);
% rt_adc1 = rt_adc1(spiGoodInds);
% rt_adc2 = rt_adc2(spiGoodInds);
% rt_adc3 = rt_adc3(spiGoodInds);
% rt_adc4 = rt_adc4(spiGoodInds);
% rt_adc5 = rt_adc5(spiGoodInds);
% rt_adc6 = rt_adc6(spiGoodInds);
% rt_adc7 = rt_adc7(spiGoodInds);
rt_ControlPanel = rt_ControlPanel(spiGoodInds,:);
rt_DriverInput = rt_DriverInput(spiGoodInds,:);
rt_DrivetrainLeft = rt_DrivetrainLeft(spiGoodInds,:);
rt_DrivetrainRight = rt_DrivetrainRight(spiGoodInds,:);
rt_GPS = rt_GPS(spiGoodInds,:);
rt_Ignition = rt_Ignition(spiGoodInds);
rt_IMU = rt_IMU(spiGoodInds,:);
rt_SPI_tout = rt_SPI_tout(spiGoodInds);
rt_spiBytesIn = rt_spiBytesIn(spiGoodInds);
rt_SteeringLeft = rt_SteeringLeft(spiGoodInds,:);
rt_SteeringRight = rt_SteeringRight(spiGoodInds,:);
rt_tout = rt_tout(spiGoodInds);
rt_WheelForceLeft = rt_WheelForceLeft(spiGoodInds,:);
rt_WheelForceRight = rt_WheelForceRight(spiGoodInds,:);
