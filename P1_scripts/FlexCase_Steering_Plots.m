% Plot the driver inputs
figure(1)
accel_pedal = 12*3.3/4096*double(bitor(bitshift(int16(rt_DriverInput(:,3)),8),int16(rt_DriverInput(:,2)))); 
plot(rt_tout,accel_pedal)
ylim([0 5])
ylabel('Accelerator Pedal Voltage')
xlabel('Time (s)')

figure(2)
steering_pot = 12*3.3/4096*double(bitor(bitshift(int16(rt_DriverInput(:,5)),8),int16(rt_DriverInput(:,4))));
steering_angle_pot = -5.24*(steering_pot - 1.08);
plot(rt_tout,steering_angle_pot*180/pi)
ylim([-200 200])
ylabel('Accelerator Pedal Voltage')
xlabel('Time (s)')

figure(3)
steering_encoder = double(bitor(bitor(bitor(bitshift(int32(rt_DriverInput(:,9)),24),...
    bitshift(int32(rt_DriverInput(:,8)),16)),...
    bitshift(int32(rt_DriverInput(:,7)),8)),int32(rt_DriverInput(:,6))));
% Unwrap the signal
unwrapped_encoder = steering_encoder;
for dataInd = 1:length(unwrapped_encoder)-1
    if unwrapped_encoder(dataInd) - unwrapped_encoder(dataInd+1) < -2^15
        unwrapped_encoder(dataInd+1:end) = -(2^16-1) + unwrapped_encoder(dataInd+1:end);
    elseif unwrapped_encoder(dataInd) - unwrapped_encoder(dataInd+1) > 2^15
        unwrapped_encoder(dataInd+1:end) = (2^16-1) + unwrapped_encoder(dataInd+1:end);
    end 
end
plot(rt_tout,steering_encoder,rt_tout,unwrapped_encoder)
ylim([-200000 200000])
legend('Raw Signal','Unwrapped')
ylabel('Handwheel Position (counts)')
xlabel('Time (s)')

figure(4)
plot(unwrapped_encoder,steering_angle_pot*180/pi,'.')
ylabel('Steering Angle from Potentiometer (deg)')
xlabel('Steering Encoder Value (counts)')
ylim([-300 300])
